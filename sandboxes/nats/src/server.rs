use async_nats::HeaderMap;
use futures::StreamExt;
use socketioxide::{
    SocketIo,
    extract::{Data, Event, SocketRef, State},
};
use std::net::SocketAddr;

#[derive(Clone)]
struct AppState {
    nats: async_nats::Client,
}

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    println!("Starting WebSocket server with socketioxide...");
    let client = async_nats::connect("nats:4222").await?;

    let (layer, io) = SocketIo::builder()
        .with_state(AppState { nats: client })
        .build_layer();

    io.ns("/", |State(app): State<AppState>, socket: SocketRef| {
        println!("Client connected: {}", socket.id);

        let socket_clone = socket.clone();
        tokio::spawn(async move {
            let mut subscriber = app.nats.subscribe("listener").await.unwrap();

            while let Some(message) = subscriber.next().await {
                let id = String::from_utf8(message.payload.to_vec()).unwrap();
                socket_clone.emit("listener", &id).ok();
            }
        });

        socket.on("subscribe", subscribe);
        socket.on_fallback(
            async |State(app): State<AppState>, Event(event): Event, Data(data): Data<String>| {
                println!("websocket [{}] -> nats", event);

                // todo: keep a record of uuid subscriptions & limit the subject here

                if let Some((subject, message)) = &event.split_once("/") {
                    let mut headers = HeaderMap::new();
                    headers.insert("message", message.to_string());
                    let data_bytes = bytes::Bytes::copy_from_slice(data.as_bytes());

                    let _ = app
                        .nats
                        .publish_with_headers(subject.to_string(), headers, data_bytes)
                        .await;
                }
            },
        )
    });

    let app = axum::Router::new()
        .route("/", axum::routing::get(serve_client_page))
        .layer(layer);

    let addr = SocketAddr::from(([0, 0, 0, 0], 3000));

    println!("WebSocket server running on http://{}", addr);
    println!("Connect using Socket.IO client to test the WebSocket connection");

    let listener = tokio::net::TcpListener::bind(addr).await.unwrap();
    axum::serve(listener, app).await?;

    Ok(())
}

async fn subscribe(State(app): State<AppState>, socket: SocketRef, Data(subject): Data<String>) {
    println!("subscribing to {}", subject);
    let mut subscriber = app
        .nats
        .subscribe(format!("{}/rsp", subject.clone()))
        .await
        .unwrap();

    tokio::spawn(async move {
        while let Some(message) = subscriber.next().await {
            println!("nats [{}] -> websocket", message.subject);

            let event_name = message
                .headers
                .as_ref()
                .and_then(|m| m.get("message").map(|v| v.to_string()))
                .unwrap_or_default();

            let event = format!("{}/{}", message.subject, event_name);
            let _ = socket.emit(event, &String::from_utf8(message.payload.to_vec()).unwrap());
        }
    });
}

async fn serve_client_page() -> axum::response::Html<String> {
    axum::response::Html(include_str!("client_home_page.html").to_string())
}
