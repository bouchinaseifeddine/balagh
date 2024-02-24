import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/model/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Comments extends StatelessWidget {
  const Comments({super.key, required this.report});

  final Report report;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('comments')
          .where('reportId', isEqualTo: report.reportId)
          .snapshots(),
      builder: (ctx, chatSpanshots) {
        if (chatSpanshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!chatSpanshots.hasData || chatSpanshots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No comments found.'),
          );
        }

        if (chatSpanshots.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }

        final loadedData = chatSpanshots.data!.docs;
        return ListView.builder(
          itemCount: loadedData.length,
          itemBuilder: (context, index) {
            final commentData = loadedData[index].data();
            return buildComment(context, commentData);
          },
        );
      },
    );
  }

  Widget buildComment(BuildContext context, Map<String, dynamic> commentData) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 5, right: 5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(1, 3),
          ),
        ],
        color: kWhite,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: SizedBox(
        height: SizeConfig.defaultSize! * 9,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (commentData['userImage'] != '')
                CircleAvatar(
                    backgroundImage: NetworkImage(commentData['userImage'])),
              if (commentData['userImage'] == '')
                const CircleAvatar(
                    backgroundImage: AssetImage(
                        'assets/images/default-profile-picture.jpg')),
              SizedBox(width: SizeConfig.defaultSize! * 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      commentData['userName'] ?? '',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: kMidtBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                    ),
                    Text(
                      commentData['text'] ?? '',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: kDarkGrey,
                            fontSize: 16,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
