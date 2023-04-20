import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef Reader = T Function<T>(ProviderListenable<T> provider);
