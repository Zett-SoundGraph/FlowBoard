// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flow_board_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FlowBoardState {

 DateTime get appStartedAt; List<RawMqttMessage> get entries; int get totalMessagesReceived; Map<String, DateTime> get deviceLastSeen;// Every FleetDevice.leaderStateField value that's actually meaningful in
// beta/flowhub/leader/update's payload (isPrinterConnected/
// isCayeConnected) — a malformed/unrelated message on that topic just
// leaves whatever was last known untouched.
 Map<String, bool> get leaderState;// Bumped every second by a Cubit-owned timer purely to force a rebuild
// for the uptime clock — uptime itself is derived fresh at render time
// from [appStartedAt], never stored here.
 int get clockTick;
/// Create a copy of FlowBoardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlowBoardStateCopyWith<FlowBoardState> get copyWith => _$FlowBoardStateCopyWithImpl<FlowBoardState>(this as FlowBoardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlowBoardState&&(identical(other.appStartedAt, appStartedAt) || other.appStartedAt == appStartedAt)&&const DeepCollectionEquality().equals(other.entries, entries)&&(identical(other.totalMessagesReceived, totalMessagesReceived) || other.totalMessagesReceived == totalMessagesReceived)&&const DeepCollectionEquality().equals(other.deviceLastSeen, deviceLastSeen)&&const DeepCollectionEquality().equals(other.leaderState, leaderState)&&(identical(other.clockTick, clockTick) || other.clockTick == clockTick));
}


@override
int get hashCode => Object.hash(runtimeType,appStartedAt,const DeepCollectionEquality().hash(entries),totalMessagesReceived,const DeepCollectionEquality().hash(deviceLastSeen),const DeepCollectionEquality().hash(leaderState),clockTick);

@override
String toString() {
  return 'FlowBoardState(appStartedAt: $appStartedAt, entries: $entries, totalMessagesReceived: $totalMessagesReceived, deviceLastSeen: $deviceLastSeen, leaderState: $leaderState, clockTick: $clockTick)';
}


}

/// @nodoc
abstract mixin class $FlowBoardStateCopyWith<$Res>  {
  factory $FlowBoardStateCopyWith(FlowBoardState value, $Res Function(FlowBoardState) _then) = _$FlowBoardStateCopyWithImpl;
@useResult
$Res call({
 DateTime appStartedAt, List<RawMqttMessage> entries, int totalMessagesReceived, Map<String, DateTime> deviceLastSeen, Map<String, bool> leaderState, int clockTick
});




}
/// @nodoc
class _$FlowBoardStateCopyWithImpl<$Res>
    implements $FlowBoardStateCopyWith<$Res> {
  _$FlowBoardStateCopyWithImpl(this._self, this._then);

  final FlowBoardState _self;
  final $Res Function(FlowBoardState) _then;

/// Create a copy of FlowBoardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appStartedAt = null,Object? entries = null,Object? totalMessagesReceived = null,Object? deviceLastSeen = null,Object? leaderState = null,Object? clockTick = null,}) {
  return _then(_self.copyWith(
appStartedAt: null == appStartedAt ? _self.appStartedAt : appStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<RawMqttMessage>,totalMessagesReceived: null == totalMessagesReceived ? _self.totalMessagesReceived : totalMessagesReceived // ignore: cast_nullable_to_non_nullable
as int,deviceLastSeen: null == deviceLastSeen ? _self.deviceLastSeen : deviceLastSeen // ignore: cast_nullable_to_non_nullable
as Map<String, DateTime>,leaderState: null == leaderState ? _self.leaderState : leaderState // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,clockTick: null == clockTick ? _self.clockTick : clockTick // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FlowBoardState].
extension FlowBoardStatePatterns on FlowBoardState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FlowBoardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FlowBoardState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FlowBoardState value)  $default,){
final _that = this;
switch (_that) {
case _FlowBoardState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FlowBoardState value)?  $default,){
final _that = this;
switch (_that) {
case _FlowBoardState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime appStartedAt,  List<RawMqttMessage> entries,  int totalMessagesReceived,  Map<String, DateTime> deviceLastSeen,  Map<String, bool> leaderState,  int clockTick)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FlowBoardState() when $default != null:
return $default(_that.appStartedAt,_that.entries,_that.totalMessagesReceived,_that.deviceLastSeen,_that.leaderState,_that.clockTick);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime appStartedAt,  List<RawMqttMessage> entries,  int totalMessagesReceived,  Map<String, DateTime> deviceLastSeen,  Map<String, bool> leaderState,  int clockTick)  $default,) {final _that = this;
switch (_that) {
case _FlowBoardState():
return $default(_that.appStartedAt,_that.entries,_that.totalMessagesReceived,_that.deviceLastSeen,_that.leaderState,_that.clockTick);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime appStartedAt,  List<RawMqttMessage> entries,  int totalMessagesReceived,  Map<String, DateTime> deviceLastSeen,  Map<String, bool> leaderState,  int clockTick)?  $default,) {final _that = this;
switch (_that) {
case _FlowBoardState() when $default != null:
return $default(_that.appStartedAt,_that.entries,_that.totalMessagesReceived,_that.deviceLastSeen,_that.leaderState,_that.clockTick);case _:
  return null;

}
}

}

/// @nodoc


class _FlowBoardState implements FlowBoardState {
  const _FlowBoardState({required this.appStartedAt, final  List<RawMqttMessage> entries = const <RawMqttMessage>[], this.totalMessagesReceived = 0, final  Map<String, DateTime> deviceLastSeen = const <String, DateTime>{}, final  Map<String, bool> leaderState = const <String, bool>{}, this.clockTick = 0}): _entries = entries,_deviceLastSeen = deviceLastSeen,_leaderState = leaderState;
  

@override final  DateTime appStartedAt;
 final  List<RawMqttMessage> _entries;
@override@JsonKey() List<RawMqttMessage> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

@override@JsonKey() final  int totalMessagesReceived;
 final  Map<String, DateTime> _deviceLastSeen;
@override@JsonKey() Map<String, DateTime> get deviceLastSeen {
  if (_deviceLastSeen is EqualUnmodifiableMapView) return _deviceLastSeen;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_deviceLastSeen);
}

// Every FleetDevice.leaderStateField value that's actually meaningful in
// beta/flowhub/leader/update's payload (isPrinterConnected/
// isCayeConnected) — a malformed/unrelated message on that topic just
// leaves whatever was last known untouched.
 final  Map<String, bool> _leaderState;
// Every FleetDevice.leaderStateField value that's actually meaningful in
// beta/flowhub/leader/update's payload (isPrinterConnected/
// isCayeConnected) — a malformed/unrelated message on that topic just
// leaves whatever was last known untouched.
@override@JsonKey() Map<String, bool> get leaderState {
  if (_leaderState is EqualUnmodifiableMapView) return _leaderState;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_leaderState);
}

// Bumped every second by a Cubit-owned timer purely to force a rebuild
// for the uptime clock — uptime itself is derived fresh at render time
// from [appStartedAt], never stored here.
@override@JsonKey() final  int clockTick;

/// Create a copy of FlowBoardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlowBoardStateCopyWith<_FlowBoardState> get copyWith => __$FlowBoardStateCopyWithImpl<_FlowBoardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlowBoardState&&(identical(other.appStartedAt, appStartedAt) || other.appStartedAt == appStartedAt)&&const DeepCollectionEquality().equals(other._entries, _entries)&&(identical(other.totalMessagesReceived, totalMessagesReceived) || other.totalMessagesReceived == totalMessagesReceived)&&const DeepCollectionEquality().equals(other._deviceLastSeen, _deviceLastSeen)&&const DeepCollectionEquality().equals(other._leaderState, _leaderState)&&(identical(other.clockTick, clockTick) || other.clockTick == clockTick));
}


@override
int get hashCode => Object.hash(runtimeType,appStartedAt,const DeepCollectionEquality().hash(_entries),totalMessagesReceived,const DeepCollectionEquality().hash(_deviceLastSeen),const DeepCollectionEquality().hash(_leaderState),clockTick);

@override
String toString() {
  return 'FlowBoardState(appStartedAt: $appStartedAt, entries: $entries, totalMessagesReceived: $totalMessagesReceived, deviceLastSeen: $deviceLastSeen, leaderState: $leaderState, clockTick: $clockTick)';
}


}

/// @nodoc
abstract mixin class _$FlowBoardStateCopyWith<$Res> implements $FlowBoardStateCopyWith<$Res> {
  factory _$FlowBoardStateCopyWith(_FlowBoardState value, $Res Function(_FlowBoardState) _then) = __$FlowBoardStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime appStartedAt, List<RawMqttMessage> entries, int totalMessagesReceived, Map<String, DateTime> deviceLastSeen, Map<String, bool> leaderState, int clockTick
});




}
/// @nodoc
class __$FlowBoardStateCopyWithImpl<$Res>
    implements _$FlowBoardStateCopyWith<$Res> {
  __$FlowBoardStateCopyWithImpl(this._self, this._then);

  final _FlowBoardState _self;
  final $Res Function(_FlowBoardState) _then;

/// Create a copy of FlowBoardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appStartedAt = null,Object? entries = null,Object? totalMessagesReceived = null,Object? deviceLastSeen = null,Object? leaderState = null,Object? clockTick = null,}) {
  return _then(_FlowBoardState(
appStartedAt: null == appStartedAt ? _self.appStartedAt : appStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<RawMqttMessage>,totalMessagesReceived: null == totalMessagesReceived ? _self.totalMessagesReceived : totalMessagesReceived // ignore: cast_nullable_to_non_nullable
as int,deviceLastSeen: null == deviceLastSeen ? _self._deviceLastSeen : deviceLastSeen // ignore: cast_nullable_to_non_nullable
as Map<String, DateTime>,leaderState: null == leaderState ? _self._leaderState : leaderState // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,clockTick: null == clockTick ? _self.clockTick : clockTick // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
