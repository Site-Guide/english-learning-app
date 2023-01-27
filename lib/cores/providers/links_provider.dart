

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final linksProvider = Provider<FirebaseDynamicLinks>((ref)=> FirebaseDynamicLinks.instance);