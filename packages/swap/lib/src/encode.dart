import 'dart:async';
import 'dart:typed_data';

import 'package:swap/src/rfw/rfw.dart';
import 'package:swap/src/widgets/widgets.dart';

/// Encodes the given [root] widget into a [BlobNode].
FutureOr<Uint8List> encodeWidget(Widget root) async {
  final context = root.createRenderObject();
  final rootNode = await context.encode();

  print(rootNode);

  final library = RemoteWidgetLibrary([], [
    WidgetDeclaration('root', null, rootNode),
  ]);

  return encodeLibraryBlob(library);
}
