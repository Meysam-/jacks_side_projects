use futures::StreamExt;
use std::env;
use uuid::Uuid;

#[tokio::main]
async fn main() -> Result<(), async_nats::Error> {
    let nats_url = env::var("NATS_URL").unwrap_or_else(|_| "nats:4222".to_string());

    println!("Connecting to {}", nats_url);

    let client = async_nats::connect(&nats_url).await?;

    let id = Uuid::new_v4();

    println!("Listening to subject {}", id);
    println!("Listening to subject all");
    let mut subscriber = client.subscribe(id.to_string()).await?;

    let client_clone = client.clone();
    let mut id_thread = async || {
        while let Some(message) = subscriber.next().await {
            println!("Subject {} received message {:?}", id, message);

            let subject = format!("{}/rsp", message.subject);
            if let Some(headers) = message.headers.clone() {
                let _ = client
                    .publish_with_headers(subject, headers, message.payload)
                    .await;
            } else {
                let _ = client_clone.publish(subject, message.payload).await;
            }
        }
    };

    let mut subscriber = client.subscribe("all").await?;
    let mut all_thread = async || {
        while let Some(message) = subscriber.next().await {
            println!("Subject all received message {:?}", message);
        }
    };

    let proclamation_thread = async || {
        loop {
            tokio::time::sleep(tokio::time::Duration::from_secs(5)).await;
            let id_string = id.to_string();
            let _ = client
                .publish(
                    "listener",
                    bytes::Bytes::copy_from_slice(id_string.as_bytes()),
                )
                .await;
        }
    };

    tokio::join!(id_thread(), all_thread(), proclamation_thread());

    Ok(())
}
