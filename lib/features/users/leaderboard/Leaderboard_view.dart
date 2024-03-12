import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/shared/get_user_data.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LeaderboardView extends StatefulWidget {
  const LeaderboardView({super.key});

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  appUser? user;

  Future<void> fetchData() async {
    try {
      final userAuthenticated = FirebaseAuth.instance.currentUser!;
      user = await getUserData(userAuthenticated.uid);
      setState(() {});
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'user')
          .orderBy('score', descending: true)
          .limit(10)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final users = snapshot.data!.docs;
        final topUsers = users.sublist(0, 3);
        final otherUsers = users.sublist(3);

        return Column(
          children: [
            _buildTopThree(context, topUsers),
            Container(
              margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    kDarkBlue,
                    kDeepBlue,
                    kMidtBlue,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              height: 60,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'You have earned',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: kWhite,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Row(
                      children: [
                        Text(
                          user!.score.toString(),
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: kWhite,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(width: SizeConfig.defaultSize),
                        const Icon(
                          Icons.auto_awesome_outlined,
                          color: kWhite,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: otherUsers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: kLightBlue,
                        foregroundColor: kWhite,
                        child: Text(
                          (index + 4).toString(),
                        ),
                      ),
                      title: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(color: kLightBlue, width: 1.5),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(children: [
                          if (otherUsers[index]['image_url'] != '')
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(users[0]['image_url']),
                              radius: 20,
                            ),
                          if (otherUsers[index]['image_url'] == '')
                            const CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/images/default-profile-picture.jpg'),
                              radius: 20,
                            ),
                          SizedBox(width: SizeConfig.defaultSize),
                          Expanded(child: Text(otherUsers[index]['username'])),
                          Row(
                            children: [
                              Text(
                                otherUsers[index]['score'].toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: kMidtBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              SizedBox(width: SizeConfig.defaultSize),
                              const Icon(
                                Icons.auto_awesome_outlined,
                                color: kMidtBlue,
                              ),
                            ],
                          ),
                        ]),
                      ));
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopThree(context, users) {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/crown-star-svgrepo-com.svg',
                    width: 50,
                    height: 50,
                  ),
                  if (users[0]['image_url'] != '')
                    CircleAvatar(
                      backgroundImage: NetworkImage(users[0]['image_url']),
                      radius: 50,
                    ),
                  if (users[0]['image_url'] == '')
                    const CircleAvatar(
                      backgroundImage: AssetImage(
                          'assets/images/default-profile-picture.jpg'),
                      radius: 50,
                    ),
                  SizedBox(height: SizeConfig.defaultSize),
                  Text(
                    users[0]['username'],
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: kGold,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    users[0]['score'].toString(),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: kGold,
                          fontWeight: FontWeight.bold,
                        ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 120,
            right: 20,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    '3',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: kGold,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (users[2]['image_url'] != '')
                    CircleAvatar(
                      backgroundImage: NetworkImage(users[2]['image_url']),
                      radius: 40,
                    ),
                  if (users[2]['image_url'] == '')
                    const CircleAvatar(
                      backgroundImage: AssetImage(
                          'assets/images/default-profile-picture.jpg'),
                      radius: 40,
                    ),
                  SizedBox(height: SizeConfig.defaultSize),
                  Text(
                    users[2]['username'],
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: kGold,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    users[2]['score'].toString(),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: kGold,
                          fontWeight: FontWeight.bold,
                        ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: 20,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    '2',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: kGold,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (users[1]['image_url'] != '')
                    CircleAvatar(
                      backgroundImage: NetworkImage(users[1]['image_url']),
                      radius: 40,
                    ),
                  if (users[1]['image_url'] == '')
                    const CircleAvatar(
                      backgroundImage: AssetImage(
                          'assets/images/default-profile-picture.jpg'),
                      radius: 40,
                    ),
                  SizedBox(height: SizeConfig.defaultSize),
                  Text(
                    users[1]['username'],
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: kGold,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    users[1]['score'].toString(),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: kGold,
                          fontWeight: FontWeight.bold,
                        ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
