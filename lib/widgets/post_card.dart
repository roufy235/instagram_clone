import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone_app/utils/colors.dart';

class PostCard extends StatelessWidget {
  const PostCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                const CircleAvatar(
                  backgroundImage: NetworkImage("http://s3.amazonaws.com/37assets/svn/765-default-avatar.png"),
                  radius: 16,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("username", style: TextStyle(fontWeight: FontWeight.bold)),

                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(context: context, builder: (context) => Dialog(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shrinkWrap: true,
                        children: [
                          'Delete'
                        ].map((e) => InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              child: Text(e),
                            ),
                          ),
                        ).toList(),
                      ),
                    ));
                  },
                  icon: Icon(Icons.more_vert),
                )
              ],
            ),
          ),
          // IMAGE SECTION
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.33,
            width: double.infinity,
            child: Image.network("https://picsum.photos/200", fit: BoxFit.cover),
          ),
          // LIKE , COMMENT SECTION
          Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const FaIcon(
                    FontAwesomeIcons.solidHeart,
                    color: Colors.red,
                  )
              ),
              IconButton(
                  onPressed: () {},
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
                  child: Text('1,000 likes', style: Theme.of(context).textTheme.bodyText2),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: primaryColor
                      ),
                      children: [
                        TextSpan(
                          text: 'username',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        ),
                        TextSpan(
                            text: ' This is some description to be replaced',
                        )
                      ]
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: const Text(
                        'view all 200 comments',
                      style: TextStyle(
                        fontSize: 16,
                        color: secondaryColor
                      ),
                    ),
                  ),
                ),
                Container(
                  child: const Text(
                    '3 days ago',
                    style: TextStyle(
                        fontSize: 14,
                        color: secondaryColor
                    ),
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
