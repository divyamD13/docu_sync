import 'dart:async';


import 'package:docu_sync/constants/colors.dart';
import 'package:docu_sync/models/document_model.dart';
import 'package:docu_sync/models/error_model.dart';
import 'package:docu_sync/repository/auth_repository.dart';
import 'package:docu_sync/repository/document_repository.dart';
import 'package:docu_sync/repository/socket_repository.dart';
import 'package:docu_sync/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/quill_delta.dart' show Delta;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;
  const DocumentScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

// class _DocumentScreenState extends ConsumerState<DocumentScreen> {
//   TextEditingController titleController = TextEditingController(text: 'Untitled Document');
//   quill.QuillController? _controller;
//   ErrorModel? errorModel;
//   SocketRepository socketRepository = SocketRepository();

//   @override
//   void initState() {
//     super.initState();
//     socketRepository.joinRoom(widget.id);
//     fetchDocumentData();

//     socketRepository.changeListener((data) {
//       _controller?.compose(
//         Delta.fromJson(data['delta']),
//         _controller?.selection ?? const TextSelection.collapsed(offset: 0),
//         quill.ChangeSource.remote,
//       );
//     });

//     Timer.periodic(const Duration(seconds: 2), (timer) {
//       socketRepository.autoSave(<String, dynamic>{
//         'delta': _controller!.document.toDelta(),
//         'room': widget.id,
//       });
//     });
//   }

//   void fetchDocumentData() async {
//     errorModel = await ref.read(documentRepositoryProvider).getDocumentById(
//           ref.read(userProvider)!.token,
//           widget.id,
//         );

//     if (errorModel!.data != null) {
//       titleController.text = (errorModel!.data as DocumentModel).title;
//       _controller = quill.QuillController(
//         document: errorModel!.data.content.isEmpty
//             ? quill.Document()
//             : quill.Document.fromDelta(
//                 Delta.fromJson(errorModel!.data.content),
//               ),
//         selection: const TextSelection.collapsed(offset: 0),
//       );
//       setState(() {});
//     }

//     _controller!.document.changes.listen((docChange) {
//   if (docChange.source == quill.ChangeSource.local) {
//     final map = {
//       'delta': docChange.change.toJson(), // Send Delta as JSON-safe format
//       'room': widget.id,
//     };
//     socketRepository.typing(map);
//   }
// });

//   }

//   @override
//   void dispose() {
//     super.dispose();
//     titleController.dispose();
//   }

//   void updateTitle(WidgetRef ref, String title) {
//     ref.read(documentRepositoryProvider).updateTitle(
//           token: ref.read(userProvider)!.token,
//           id: widget.id,
//           title: title,
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_controller == null) {
//       return const Scaffold(body: CustomLoadingIndicator());
//     }
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor:Colors.white,
//         elevation: 0,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 Clipboard.setData(ClipboardData(text: 'http://localhost:3000/#/document/${widget.id}')).then(
//                   (value) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text(
//                           'Link copied!',
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//               icon: const Icon(
//                 Icons.lock,
//                 size: 16,
//               ),
//               label: const Text('Share'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//               ),
//             ),
//           ),
//         ],
//         title: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 9.0),
//           child: Row(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   Routemaster.of(context).replace('/');
//                 },
//                 child: Image.asset(
//                   'assets/images/docs-logo.png',
//                   height: 40,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               SizedBox(
//                 width: 180,
//                 child: TextField(
//                   controller: titleController,
//                   decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: AppColors.primary,
//                       ),
//                     ),
//                     contentPadding: EdgeInsets.only(left: 10),
//                   ),
//                   onSubmitted: (value) => updateTitle(ref, value),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1),
//           child: Container(
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Colors.grey.shade800,
//                 width: 0.1,
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             const SizedBox(height: 10),
//             quill.QuillSimpleToolbar(
//   controller: _controller!,
//   config: const quill.QuillSimpleToolbarConfig(),
// ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: SizedBox(
//                 width: 750,
//                 child: Card(
//                   color:Colors.white,
//                   elevation: 5,
//                   child: Padding(
//                     padding: const EdgeInsets.all(30.0),
//                     child:  quill.QuillEditor.basic(
//     controller: _controller!,
//     config: const quill.QuillEditorConfig(),
//   ),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  TextEditingController titleController = TextEditingController(text: 'Untitled Document');
  quill.QuillController? _controller;
  ErrorModel? errorModel;
  final SocketRepository socketRepo = SocketRepository();
  Timer? _autoSaveDebounce;

  @override
  void initState() {
    super.initState();
    socketRepo.joinRoom(widget.id);
    fetchDocumentData();

    // Listen to remote changes
    socketRepo.changeListener((data) {
      if (_controller != null) {
        _controller!.compose(
          Delta.fromJson(data['delta']),
          _controller!.selection,
          quill.ChangeSource.remote,
        );
      }
    });
  }

  void fetchDocumentData() async {
    errorModel = await ref.read(documentRepositoryProvider).getDocumentById(
          ref.read(userProvider)!.token,
          widget.id,
        );

    if (errorModel!.data != null) {
      final docModel = errorModel!.data as DocumentModel;
      titleController.text = docModel.title;
      _controller = quill.QuillController(
        document: docModel.content.isEmpty
            ? quill.Document()
            : quill.Document.fromDelta(Delta.fromJson(docModel.content)),
        selection: const TextSelection.collapsed(offset: 0),
      );

      // Listen for local changes
      _controller!.document.changes.listen((docChange) {
        if (docChange.source == quill.ChangeSource.local) {
          final deltaMap = {
            'delta': docChange.change.toJson(),
            'room': widget.id,
          };
          // Emit typing updates
          socketRepo.typing(deltaMap);

          // Debounced auto-save
          _autoSaveDebounce?.cancel();
          _autoSaveDebounce = Timer(const Duration(seconds: 2), () {
            socketRepo.autoSave(deltaMap);
          });
        }
      });

      setState(() {});
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    _autoSaveDebounce?.cancel();
    super.dispose();
  }

  void updateTitle(WidgetRef ref, String title) {
    ref.read(documentRepositoryProvider).updateTitle(
          token: ref.read(userProvider)!.token,
          id: widget.id,
          title: title,
        );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(body: CustomLoadingIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Routemaster.of(context).replace('/'),
              child: Image.asset('assets/images/docs-logo.png', height: 40),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 180,
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(border: InputBorder.none),
                onSubmitted: (value) => updateTitle(ref, value),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: 'http://localhost:3000/#/document/${widget.id}'),
              ).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Link copied!')),
                );
              });
            },
            icon: const Icon(Icons.lock, size: 16),
            label: const Text('Share'),
          ),
        ],
      ),
      body: Column(
        children: [
          quill.QuillSimpleToolbar(controller: _controller!),
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: quill.QuillEditor.basic(
                  controller: _controller!,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
