import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone_app/models/user.dart';
import 'package:instagram_clone_app/providers/user_provider.dart';
import 'package:instagram_clone_app/resources/firestore_methods.dart';
import 'package:instagram_clone_app/screens/home/comment_screen.dart';
import 'package:instagram_clone_app/utils/colors.dart';
import 'package:instagram_clone_app/utils/utils.dart';
import 'package:instagram_clone_app/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  const PostCard({
    Key? key,
    required this.snap
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  bool isLikeAnimating = false;
  int commentLength = 0;
  String commentLenStr = 'view all 0 comment';
  String likeStr = '0 like';

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(postCollectionName).doc(widget.snap['postId'])
          .collection(postCollectionCommentName).get();
      commentLength = querySnapshot.docs.length;
      if (commentLength > 1) {
        commentLenStr = 'view all $commentLength comments';
      } else if (commentLength > 0) {
        commentLenStr = 'view all $commentLength comment';
      } else {
        commentLenStr = 'view all 0 comment';
      }
    } catch(err) {
      showSnackBar(context, err.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    if (widget.snap['likes'].length > 1) {
      likeStr = '${widget.snap['likes'].length.toString()} likes';
    } else if (widget.snap['likes'].length > 0) {
      likeStr = '${widget.snap['likes'].length.toString()} like';
    } else {
      likeStr = '0 like';
    }

    final UserModel user = Provider.of<UserProvider>(context).getUser;


    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          // HEADER SECTION
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.snap['profileImage']),
                  radius: 16,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            widget.snap['username'],
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold
                            ),
                        ),

                      ],
                    ),
                  ),
                ),
                widget.snap['uid'] == user.uid ? IconButton(
                  onPressed: () {
                    showDialog(context: context, builder: (context) => Dialog(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shrinkWrap: true,
                        children: [
                          'Delete'
                        ].map((e) => InkWell(
                            onTap: () async {
                              FirestoreMethods().deletePost(widget.snap['postId']);
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              child: Text(e),
                            ),
                          ),
                        ).toList(),
                      ),
                    ));
                  },
                  icon: const Icon(Icons.more_vert),
                ) : Container()
              ],
            ),
          ),
          // IMAGE SECTION
          GestureDetector(
            onDoubleTap: () async {
              setState(() {
                isLikeAnimating = true;
              });
              await FirestoreMethods().likePosts(
                  widget.snap['postId'],
                  user.uid,
                  widget.snap['likes']
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.33,
                      width: double.infinity,
                      child: Image.network(widget.snap['postUrl'], fit: BoxFit.cover),
                    )
                ),
                Positioned(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isLikeAnimating ? 1 : 0,
                      child: LikeAnimation(
                        isAnimating: isLikeAnimating,
                        duration: const Duration(milliseconds: 400),
                        onEnd: () {
                          setState(() {
                              isLikeAnimating = false;
                          });
                        },
                          child: const FaIcon(
                            FontAwesomeIcons.solidHeart,
                            color: Colors.white,
                            size: 120,
                          ),
                      ),
                    )
                )
              ],
            ),
          ),
          // LIKE , COMMENT SECTION
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                    onPressed: () async {
                      await FirestoreMethods().likePosts(
                          widget.snap['postId'],
                          user.uid,
                          widget.snap['likes']
                      );
                    },
                    icon: widget.snap['likes'].contains(user.uid) ? const FaIcon(
                      FontAwesomeIcons.solidHeart,
                      color: Colors.red,
                    ) : const FaIcon(FontAwesomeIcons.heart)
                ),
              ),
              IconButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentScreen(snap: widget.snap))
                  ),
                  icon: const FaIcon(FontAwesomeIcons.comment)
              ),
              IconButton(
                  onPressed: () {},
                  icon: const FaIcon(FontAwesomeIcons.paperPlane)
              ),
              Expanded(
                child: Align(
                   alignment: Alignment.bottomRight,
                  child: IconButton(
                      onPressed: () {},
                      icon: const FaIcon(FontAwesomeIcons.bookmark)
                  ),
                ),
              )
            ],
          ),
          // DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.w800
                    ),
                  child: Text(
                      likeStr,
                      style: Theme.of(context).textTheme.bodyText2
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: widget.snap['username'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold
                          )
                          //style: const TextStyle(fontWeight: FontWeight.bold)
                        ),
                        TextSpan(
                            text: ' ${widget.snap['description']}',
                          style: GoogleFonts.poppins()
                        )
                      ]
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentScreen(snap: widget.snap))
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      commentLenStr,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: secondaryColor
                      ),
                    ),
                  ),
                ),
                Text(
                  DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: secondaryColor
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
