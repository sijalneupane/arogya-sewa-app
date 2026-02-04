import 'package:shared_core/shared_core_injection_container.dart';
import 'package:get_it/get_it.dart';
final sl = GetIt.instance;

Future<void> initDI() async {
await registerSharedCoreDependencies(sl); 
await sl.allReady();
}