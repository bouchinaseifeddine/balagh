import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/data/roles.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AccountCard extends StatefulWidget {
  const AccountCard({super.key, required this.account});

  final appUser account;

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  String? role;
  @override
  void initState() {
    super.initState();
    role = widget.account.role;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: kWhite,
          border: Border.all(color: kDarkGrey.withOpacity(0.4), width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: SizedBox(
          height: SizeConfig.defaultSize! * 9,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: widget.account.imageUrl != ''
                      ? Image.network(
                          widget.account.imageUrl,
                          fit: BoxFit.fill,
                          height: double.infinity,
                          width: (SizeConfig.screenWidth! - 80) / 5,
                        )
                      : Image.asset(
                          'assets/images/default-profile-picture.jpg',
                          fit: BoxFit.fill,
                          height: double.infinity,
                          width: (SizeConfig.screenWidth! - 80) / 5,
                        ),
                ),
                SizedBox(width: SizeConfig.defaultSize),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.account.userName,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: kMidtBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(height: SizeConfig.defaultSize),
                        Text(
                          widget.account.email,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: kDarkGrey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]),
                ),
                DropdownButton(
                  value: role,
                  items: [
                    for (final role in roles)
                      DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      )
                  ],
                  onChanged: (value) async {
                    final accountRef = FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.account.id);
                    await accountRef.update({'role': value});
                    setState(() {
                      role = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
