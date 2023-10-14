import 'package:flutter_test/flutter_test.dart';
import 'package:connect_x/connect_x.dart';
import 'package:connect_x/connect_x_platform_interface.dart';
import 'package:connect_x/connect_x_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockConnect_xPlatform
    with MockPlatformInterfaceMixin
    implements Connect_xPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final Connect_xPlatform initialPlatform = Connect_xPlatform.instance;

  test('$MethodChannelConnect_x is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelConnect_x>());
  });

  test('getPlatformVersion', () async {
    Connect_x connect_xPlugin = Connect_x();
    MockConnect_xPlatform fakePlatform = MockConnect_xPlatform();
    Connect_xPlatform.instance = fakePlatform;

    expect(await connect_xPlugin.getPlatformVersion(), '42');
  });
}
