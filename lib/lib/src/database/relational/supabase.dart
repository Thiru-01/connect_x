import 'package:connect_x/lib/src/connect_x_base.dart';
import 'package:connect_x/lib/src/exceptions/condition_exceptions.dart';
import 'package:supabase/supabase.dart';

class ConnectXSupabase extends ConnectX implements DatabaseConnector {
  static final ConnectXSupabase _instance = ConnectXSupabase._internal();
  late SupabaseClient _client;
  factory ConnectXSupabase() {
    return _instance;
  }

  ConnectXSupabase._internal();

  static Future<void> initialization() async {
    await _instance.initializeConnector();
  }

  @override
  Future<PostgrestBuilder> delete<PostgrestBuilder>(
      DeleteCondition condition) async {
    if (condition.tablename != null) {
      if (condition.matchCondition != null) {
        await _client
            .from(condition.tablename!)
            .delete()
            .match(condition.matchCondition!.toMap());
      }
      throw MatchConditoionNullException();
    }
    throw TableNameNullException();
  }

  @override
  Future<PostgrestBuilder> get<PostgrestBuilder>(GetCondition condition) async {
    if (condition.tableName != null) {
      if (condition.orderBy != null) {
        return await _client.from(condition.tableName!).select().order(
            condition.orderBy!.columnName,
            ascending: condition.orderBy!.isAscending);
      }
      return await _client.from(condition.tableName!).select();
    }
    throw TableNameNullException();
  }

  @override
  Stream<T> listern<T>(GetCondition condition, List<String>? primaryKey) {
    if (condition.tableName != null) {
      if (condition.orderBy != null) {
        return _client
            .from(condition.tableName!)
            .stream(primaryKey: primaryKey ?? [])
            .order(condition.orderBy!.columnName,
                ascending: condition.orderBy!.isAscending)
            .cast<T>();
      }
      return _client
          .from(condition.tableName!)
          .stream(primaryKey: primaryKey ?? [])
          .cast<T>();
    }
    throw TableNameNullException();
  }

  @override
  Future<void> set(SetCondition condition) async {
    if (condition.tableName != null) {
      await _client.from(condition.tableName!).insert(condition.content.data);
    }
    throw TableNameNullException();
  }

  @override
  Future<PostgrestBuilder> update<PostgrestBuilder>(
      UpdateCondition condition) async {
    if (condition.tableName != null) {
      if (condition.matchCondition != null) {
        return await _client
            .from(condition.tableName!)
            .update(condition.newContent.data)
            .match(condition.matchCondition!.toMap());
      }
      return await _client
          .from(condition.tableName!)
          .update(condition.newContent.data);
    }
    throw TableNameNullException();
  }
}
