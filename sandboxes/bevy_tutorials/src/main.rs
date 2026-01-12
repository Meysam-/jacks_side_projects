use bevy::{
    color::palettes::css::{DARK_SLATE_GREY, GREEN, PURPLE, WHITE},
    prelude::*,
};

#[derive(Component)]
struct Moveable {
    speed: f32,
}

fn setup(
    mut commands: Commands,
    mut meshes: ResMut<Assets<Mesh>>,
    mut materials: ResMut<Assets<ColorMaterial>>,
) {
    commands.spawn(Camera2d);

    commands.spawn((
        Mesh2d(meshes.add(Circle::new(50.0))),
        MeshMaterial2d(materials.add(Color::from(DARK_SLATE_GREY))),
        Transform::from_xyz(
            -500.0,
            0.0,
            0.0,
        ),
        Moveable{speed: 50.0},
    ));
}

fn change_clear_color(input: Res<ButtonInput<KeyCode>>, mut clear_color: ResMut<ClearColor>) {
    if input.just_pressed(KeyCode::Space) {
        if clear_color.0 == PURPLE.into() {
            clear_color.0 = GREEN.into();
        } else {
            clear_color.0 = PURPLE.into();
        }
    }
}

fn move_circle(query: Query<(&mut Transform, &Moveable)>, timer: Res<Time>) {
    for (mut transform, moveable) in query {
        let direction = transform.local_x();
        transform.translation += direction * moveable.speed * timer.delta_secs();
    }
}

fn main() {
    App::new()
        .insert_resource(ClearColor(Color::from(WHITE)))
        .add_plugins(DefaultPlugins)
        .add_systems(Startup, setup)
        .add_systems(Update, (change_clear_color, move_circle))
        .run();
}
