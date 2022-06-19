import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone_app/utils/colors.dart';
import 'package:instagram_clone_app/utils/utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final TextEditingController _searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'search for user',
          ),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowUsers = true;
            });
          },
        ),
      ),
      body: isShowUsers ? FutureBuilder(
        future: FirebaseFirestore.instance.collection(userCollectionName)
            .where('username', isGreaterThanOrEqualTo: _searchController.text).get(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          snapshot.data!.docs[index]['photoUrl']
                      ),
                      radius: 18,
                    ),
                    title: Text(
                        snapshot.data!.docs[index]['username'],
                        style: GoogleFonts.poppins()
                    ),
                  );
              });
        },
      ) : FutureBuilder(
        future: FirebaseFirestore.instance.collection(postCollectionName).get(),
          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('no posts', style: GoogleFonts.poppins()),
              );
            }
            return StaggeredGridView.countBuilder(
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => Image.network(
                    snapshot.data!.docs[index]['postUrl'],
                  fit: BoxFit.cover,
                ),
                staggeredTileBuilder: (index) => StaggeredTile.count(
                    (index % 7 == 0) ? 2 : 1,
                    (index % 7 == 0) ? 2 : 1
                ),
            );
          }
      ),
    );
  }
}
