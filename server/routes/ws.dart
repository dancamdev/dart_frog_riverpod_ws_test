// ignore_for_file: unnecessary_statements, avoid_print, cascade_invocations

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:riverpod/riverpod.dart';
import 'package:web_socket_test/counter/provider.dart';


Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    print('Client connected!');

    final container = context.read<ProviderContainer>();

    container.listen(counterProvider, (_, next) {
      print('counter updated: $next');
      channel.sink.add('$next');
    });

    channel.stream.listen(
      (event) {
        print(event);
        if (event == 'increment') {
          // ignore: avoid_dynamic_calls
          container.read(counterProvider.notifier).state++;
        }
      },
      onDone: () {
        print('Client disconnected!');
      },
    );
  });

  return handler(context);
}
