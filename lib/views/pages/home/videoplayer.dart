import 'package:flutter/material.dart';

import '../../../widgets/circle_animation.dart';
import '../../../widgets/video_player_item.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({Key? key}) : super(key: key);

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ]),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(8),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.grey,
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    FocusManager.instance.primaryFocus?.unfocus();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView.builder(
        itemCount: 1,
        scrollDirection: Axis.vertical,
        controller: PageController(initialPage: 0, viewportFraction: 1),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              VideoPlayerItem(
                videoUrl:
                    'gs://appsnapchat-a5efe.appspot.com/images/y2meta.com - Ta Và Nàng-(1080p).mp4',
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 20, bottom: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'username',
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                                Text(
                                  'caption',
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                ),
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.music_note,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'Song Name',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 80,
                          margin: EdgeInsets.only(top: size.height / 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildProfile(
                                  'https://phunugioi.com/wp-content/uploads/2020/10/anh-dai-dien-avt-anime-1.jpg'),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.favorite,
                                      size: 25,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    '743',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: const Icon(
                                      Icons.comment_rounded,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    '26',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: const Icon(
                                      Icons.reply,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    '3',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                              CircleAnimation(
                                  child: buildMusicAlbum(
                                      'https://phunugioi.com/wp-content/uploads/2020/10/anh-dai-dien-avt-anime-1.jpg')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
