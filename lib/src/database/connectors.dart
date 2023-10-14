import 'package:connect_x/src/exceptions/initilizatin_exceptions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase/supabase.dart';

abstract interface class BackendConnector {
  Future<T> get<T>(GetCondition condition);
  Future<void> set(SetCondition condition);
  Future<T> delete<T>(DeleteCondition condition);
  Future<T> update<T>(UpdateCondition condition);
}

abstract interface class BackendListerner {
  Stream<T> listern<T>(GetCondition condition, List<String>? primaryKey);
}

/* 
* Have content of the inserting the data in the backend
* @param content: Hold the data to be inserted
* @param path: In case of document type backend, It uses path, instead of id.
* @param condition: Used for conditing in the relation database
* 
* For document based backend it will use path, if releation backend means it will use
* condition
*/
class GetCondition {
  final String? path;
  final String? tableName;
  final String? condition;
  final OrderCondition? orderBy;
  GetCondition({this.path, this.tableName, this.condition, this.orderBy});
}

class SetCondition {
  final InsertionData content;
  final String? path;
  final String? tableName;
  final String? condition;
  SetCondition(
      {required this.content, this.tableName, this.path, this.condition});
}

class UpdateCondition {
  final InsertionData newContent;
  final String? path;
  final String? tableName;
  final String? condition;
  final MatchCondition? matchCondition;
  UpdateCondition(
      {required this.newContent,
      this.path,
      this.tableName,
      this.condition,
      this.matchCondition});
}

class DeleteCondition {
  final String? path;
  final String? condition;
  final String? tablename;
  final MatchCondition? matchCondition;
  DeleteCondition(
      {this.path, this.condition, this.tablename, this.matchCondition});
}

class OrderCondition {
  final String columnName;
  final bool isAscending;
  /*
   * @param columnName: Used for specifying the column name in the table to prerform ordering
   * @param isAscending: Return the data in ascending order. by default it is in assecending as true 
  */
  OrderCondition({required this.columnName, this.isAscending = true});
}

class MatchCondition {
  final String columnName;
  final String value;
  MatchCondition({required this.columnName, required this.value});

  Map<dynamic, dynamic> toMap() {
    return {columnName: value};
  }
}

class InsertionData {
  final Map<dynamic, dynamic> data;
  InsertionData({required this.data});
}

// For relation database
abstract interface class DatabaseConnector
    implements BackendConnector, BackendListerner {}

// For document based database
abstract interface class DocumentConnector
    implements BackendConnector, BackendListerner {}

class ConnectX {
  final FirebaseAuthCredentials? _firebaseAuthCredentials;
  final SupabadeAuthCredentials? _supabadeAuthCredentials;
  //Clients initialization
  SupabaseClient? supabaseClient;
  //Databse inititlization
  DatabaseConnector? databaseConnector;
  ConnectX(
      {FirebaseAuthCredentials? firebaseAuthCredentials,
      SupabadeAuthCredentials? supabadeAuthCredentials})
      : _supabadeAuthCredentials = supabadeAuthCredentials,
        _firebaseAuthCredentials = firebaseAuthCredentials;
  Future<void> initializeConnector() async {
    if (_firebaseAuthCredentials != null && _supabadeAuthCredentials != null) {
      throw BothInitializationFoundException();
    }

    if (_firebaseAuthCredentials != null) {
      await _firebaseInitialization();
      return;
    }

    if (_supabadeAuthCredentials != null) {
      await _supabaseInitialization();
      return;
    }
  }

  Future<void> _firebaseInitialization() async {}

  Future<void> _supabaseInitialization() async {
    supabaseClient = SupabaseClient(_supabadeAuthCredentials!.supabaseUrl,
        _supabadeAuthCredentials!.supabasekey);
  }
}

class FirebaseAuthCredentials {
  final FirebaseOptions firebaseOptions;
  FirebaseAuthCredentials({required this.firebaseOptions});
}

class SupabadeAuthCredentials {
  final String supabaseUrl;
  final String supabasekey;
  SupabadeAuthCredentials(
      {required this.supabaseUrl, required this.supabasekey});
}
