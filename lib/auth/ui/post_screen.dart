import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/auth/login_screen.dart';
import 'package:crud_app/auth/ui/add_post_screen.dart';
import 'package:crud_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final fireauth = FirebaseFirestore.instance.collection('users');
  final updateDataController = TextEditingController();
  final searchDataController = TextEditingController();

  Future showMyDialog(String title, String id) async {
    return showDialog(
      context: context,
      builder: (context) {
        updateDataController.text = title;
        return AlertDialog(
          title: Text('Update'),
          content: TextField(
            controller: updateDataController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await fireauth.doc(id).update({
                    'title': updateDataController.text.toString(),
                  }).then((value) {
                    Utils().messageToast('Sucessfully Updated');
                  });
                } catch (e) {
                  Utils().messageToast(e.toString());
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Post Screen'),
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut().then((value) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  });
                } catch (e) {
                  Utils().messageToast(e.toString());
                }
              },
              icon: Icon(Icons.logout_outlined))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPostScreen()));
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: searchDataController,
              onChanged: ((value) {
                setState(() {});
              }),
              decoration: InputDecoration(
                  hintText: 'Search for data ...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: fireauth.snapshots(),
                builder: ((context,   snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Error');
                  } else {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: ((context, index) {
                            final title =
                                snapshot.data!.docs[index]['title'].toString();
                            final id =
                                snapshot.data!.docs[index]['id'].toString();

                            //search data is empty logic
                            if (searchDataController.text.toString().isEmpty) {
                              return ListTile(
                                title:
                                    Text(snapshot.data!.docs[index]['title']),
                                subtitle:
                                    Text(snapshot.data!.docs[index]['id']),
                                trailing: PopupMenuButton(
                                  icon: Icon(Icons.more_vert),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pop(context);
                                          showMyDialog(title, id);
                                        },
                                        leading: Icon(Icons.edit),
                                        title: Text('Edit'),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        fireauth.doc(id).delete();
                                      },
                                      child: ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text('Delete'),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            //search logic
                            if (title.toLowerCase().toString().contains(
                                searchDataController.text.toLowerCase())) {
                              return ListTile(
                                title:
                                    Text(snapshot.data!.docs[index]['title']),
                                subtitle:
                                    Text(snapshot.data!.docs[index]['id']),
                                trailing: PopupMenuButton(
                                  icon: Icon(Icons.more_vert),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pop(context);
                                          showMyDialog(title, id);
                                        },
                                        leading: Icon(Icons.edit),
                                        title: Text('Edit'),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        fireauth.doc(id).delete();
                                      },
                                      child: ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text('Delete'),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Container();
                            }
                          })),
                    );
                  }
                }))
          ],
        ),
      ),
    );
  }
}
