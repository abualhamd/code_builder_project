enum OrderStatus {
  processing(allowedStates: [picked]),
  picked(allowedStates: [onItsWay]),
  onItsWay(allowedStates: [delivered]),
  delivered(allowedStates: []);

  const OrderStatus({required List<OrderStatus> allowedStates});
}
