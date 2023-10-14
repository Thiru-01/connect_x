class TableNameNullException implements Exception {
  final String _status = "TAB-01";

  @override
  String toString() {
    return "For releation database table name is required, but recieved as empty. ERROR-CODE: $_status";
  }
}

class MatchConditoionNullException implements Exception {
  final String _status = "TAB-02";
  @override
  String toString() {
    return "For deletion process of relational database, the MatchCondition can't be empty. ERROR-CODE: $_status";
  }
}
