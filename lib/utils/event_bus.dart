import 'dart:async';

class EventBus {
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;
  EventBus._internal();
  
  final StreamController _foodAddedController = StreamController.broadcast();
  Stream get onFoodAdded => _foodAddedController.stream;
  
  void emitFoodAdded() {
    _foodAddedController.add(null);
  }
}