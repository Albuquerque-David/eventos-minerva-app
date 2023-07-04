import 'dart:async';

class UserDataBloc {
  final _streamController = StreamController<String>();

  Stream<String> get stream => _streamController.stream;

  void sendDataToStream(String data) {
    _streamController.add(data);
  }

  void dispose() {
    _streamController.close();
  }
}

final userDataBloc = UserDataBloc();