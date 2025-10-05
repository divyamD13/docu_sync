import 'package:docu_sync/constants/colors.dart';
import 'package:docu_sync/models/document_model.dart';
import 'package:docu_sync/repository/auth_repository.dart';
import 'package:docu_sync/repository/document_repository.dart';
import 'package:docu_sync/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import the caching package

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(BuildContext context, WidgetRef ref) async {
    String token = ref.read(userProvider)!.token;
    final navigator = Routemaster.of(context);
    final snackbar = ScaffoldMessenger.of(context);

    final errorModel = await ref.read(documentRepositoryProvider).createDocument(token);

    if (errorModel.data != null) {
      navigator.push('/document/${errorModel.data.id}');
    } else {
      snackbar.showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    }
  }

  void navigateToDocument(BuildContext context, String documentId) {
    Routemaster.of(context).push('/document/$documentId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextField(
                    decoration:  InputDecoration(
                      hintText: 'Search your docs',
                      hintStyle: TextStyle(color: AppColors.text),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      prefixIcon: Icon(Icons.search, color:AppColors.text),
                      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (query) {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.darkSurface,
                    foregroundImage: user.profilePic.isNotEmpty
                        ? NetworkImage(user.profilePic)
                        : null,
                    child: (user.profilePic.isEmpty)
                        ? Text(
                            user.name.isNotEmpty ? user.name[0].toUpperCase() : '',
                            style: const TextStyle(color: Colors.white, fontSize: 24),
                          )
                        : null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.folder_open),
              title: const Text('My Documents'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                print('Navigating to My Documents');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                signOut(ref); // Handle user sign out
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => createDocument(context, ref),
        label: const Text('Create Document'),
        icon: const Icon(Icons.add),
      ),
      body: FutureBuilder(
  future: ref.watch(documentRepositoryProvider).getDocuments(
        ref.watch(userProvider)!.token,
      ),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CustomLoadingIndicator();
    }

    // ✅ Check for errors or null data
    if (!snapshot.hasData || snapshot.data?.data == null) {
      return const Center(
        child: Text(
          'No documents found or failed to fetch data.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final docs = snapshot.data!.data; // Safe now

    if (docs.isEmpty) {
      return const Center(
        child: Text(
          'No documents yet. Tap "Create Document" to start.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Center(
      child: Container(
        width: 600,
        margin: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            DocumentModel document = docs[index];
            return InkWell(
              onTap: () => navigateToDocument(context, document.id),
              child: SizedBox(
                height: 50,
                child: Card(
                  child: Center(
                    child: Text(
                      document.title,
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  },
),

    );
  }
}