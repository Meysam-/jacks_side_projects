use geo::Geometry;
use nu_protocol::{CustomValue, ShellError, Span, Value, ast};
use serde::{Deserialize, Serialize};
use wkt::ToWkt;

#[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
pub struct GeometryCustomValue {
    pub geometry: Geometry,
}

impl GeometryCustomValue {
    pub fn into_value(self, span: Span) -> Value {
        Value::custom(Box::new(self), span)
    }

    pub fn try_from_value(value: &Value) -> Result<Self, ShellError> {
        let span = value.span();
        match value {
            Value::Custom { val, .. } => {
                if let Some(cool) = val.as_any().downcast_ref::<Self>() {
                    Ok(cool.clone())
                } else {
                    Err(ShellError::CantConvert {
                        to_type: "cool".into(),
                        from_type: "non-cool".into(),
                        span,
                        help: None,
                    })
                }
            }
            x => Err(ShellError::CantConvert {
                to_type: "cool".into(),
                from_type: x.get_type().to_string(),
                span,
                help: None,
            }),
        }
    }
}

#[typetag::serde]
impl CustomValue for GeometryCustomValue {
    fn clone_value(&self, span: Span) -> Value {
        Value::custom(Box::new(self.clone()), span)
    }

    fn type_name(&self) -> String {
        self.typetag_name().to_string()
    }

    fn to_base_value(&self, span: Span) -> Result<Value, ShellError> {
        Ok(Value::string(self.geometry.to_wkt().to_string(), span))
    }

    fn operation(
        &self,
        _lhs_span: Span,
        operator: ast::Operator,
        op_span: Span,
        right: &Value,
    ) -> Result<Value, ShellError> {
        Err(ShellError::OperatorUnsupportedType {
            op: operator,
            unsupported: right.get_type(),
            op_span,
            unsupported_span: right.span(),
            help: None,
        })
    }

    fn as_any(&self) -> &dyn std::any::Any {
        self
    }

    fn as_mut_any(&mut self) -> &mut dyn std::any::Any {
        self
    }
}
