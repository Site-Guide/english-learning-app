
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../cores/providers/client_provider.dart';

final userProvider = FutureProvider<models.Account>(
  (ref) => Account(ref.read(clientProvider)).get(),
);