import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/key_value.dart';
import 'storage_provider.dart';

final previewProvider = FutureProvider.family<MemoryImage, KeyValue>(
  (ref, entry) => ref
      .read(storageProvider)
      .getFilePreview(
        bucketId: entry.key,
        fileId: entry.value,
      )
      .then(
        (value) => MemoryImage(value),
      ),
);
