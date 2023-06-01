import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/utils/utils.dart';
import 'package:crud_app/widgets/round_button.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool loading = false;
  final firestore = FirebaseFirestore.instance.collection('users');
  final addDataController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    addDataController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Post Data'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: addDataController,
                maxLines: 3,
                decoration: InputDecoration(
                    hintText: 'What is in your mind?',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2))),
              ),
              SizedBox(
                height: 15,
              ),
              RoundButton(
                  title: 'Add',
                  isLoading: loading,
                  onTap: () async {
                    final id = DateTime.now().millisecondsSinceEpoch.toString();
                    setState(() {
                      loading = true;
                    });
                    try {
                      await firestore.doc(id).set({
                        'id': id,
                        'title': addDataController.text.toString(),
                      }).then((value) {
                        setState(() {
                          loading = false;
                        });
                        Utils().messageToast('Post Added');
                      });
                    } catch (e) {
                      Utils().messageToast(e.toString());
                      setState(() {
                        loading = false;
                      });
                    }
                  })
            ],
          ),
        ));
  }
}
