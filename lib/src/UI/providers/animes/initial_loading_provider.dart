
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../news/news_provider.dart';


final initialNewsLoadingProvider = Provider<bool>((ref) {

  // final step1 = ref.watch( japonNewsProvider ).isEmpty;
  // final step2 = ref.watch( mangaNewsProvider ).isEmpty;
  final step3 = ref.watch( recentNewsProvider ).isEmpty;
  final step4 = ref.watch( popularNewsProvider ).isEmpty;
  // final step5 = ref.watch( animeNewsProvider ).isEmpty;

  
  if(/*  step1 || step2 || */ step3 || step4 /* || step5 */ ) return true;

  return false; // terminamos de cargar
});