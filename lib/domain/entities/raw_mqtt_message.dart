/// One raw message as it arrived off the wire — Flow Board's whole job is to
/// dump every one of these, unparsed, so unlike a typed data source this
/// doesn't decode/route by topic into typed streams.
typedef RawMqttMessage = ({String topic, String payload, DateTime receivedAt});
