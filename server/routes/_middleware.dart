import 'package:dart_frog/dart_frog.dart';
import 'package:web_socket_test/container.dart';

Handler middleware(Handler handler) => handler.use(container);
