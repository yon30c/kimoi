import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kimoi/src/UI/screens/home/home.dart';

final estadoProvider = StateProvider((ref) => 0);

final generoProvider = StateProvider((ref) => '0');

final estrenoProvider = StateProvider((ref) => 0);

final tipoProvider = StateProvider((ref) => '');
final labelProvider = StateProvider((ref) => '');

final idiomaProvider = StateProvider((ref) => 0);

final genreProvider = StateProvider<GenresTab?>((ref) => null);
