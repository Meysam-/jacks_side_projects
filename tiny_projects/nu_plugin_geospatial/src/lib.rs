mod geometry;

pub mod from_wkb;
pub mod from_wkt;
pub mod into_wkb;
pub mod into_wkt;

use crate::from_wkb::FromWkb;
use crate::from_wkt::FromWkt;
use crate::into_wkb::IntoWkb;
use crate::into_wkt::IntoWkt;
use nu_plugin::{Plugin, PluginCommand};

pub struct GeoSpatialPlugin;

impl Plugin for GeoSpatialPlugin {
    fn version(&self) -> String {
        env!("CARGO_PKG_VERSION").into()
    }

    fn commands(&self) -> Vec<Box<dyn PluginCommand<Plugin = Self>>> {
        vec![
            Box::new(FromWkb),
            Box::new(FromWkt),
            Box::new(IntoWkb),
            Box::new(IntoWkt),
        ]
    }
}
