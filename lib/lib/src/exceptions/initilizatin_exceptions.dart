class BothInitializationFoundException implements Exception {
  final String _statusCode = "INZ-02";
  @override
  String toString() {
    return "Different types of backend services crendtial provided, ERROR-CODE $_statusCode";
  }
}

class DatabaseConnectorInitializationException implements Exception {
  final String _statusCode = "INZ-03";
  @override
  String toString() {
    return "Connector is not intitialized call -> initializeConnector() first. ERROR-CODE: $_statusCode";
  }
}
