import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/features/admin/accounts/account_card.dart';
import 'package:balagh/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AccountsView extends StatelessWidget {
  const AccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchAccounts(),
      builder: (context, AsyncSnapshot<List<appUser>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: kMidtBlue,
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No Accounts found.'));
        } else {
          final accounts = snapshot.data!;
          return ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              return AccountCard(account: accounts[index]);
            },
          );
        }
      },
    );
  }

  Future<List<appUser>> fetchAccounts() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('role', isNotEqualTo: 'admin')
              .get();
      return snapshot.docs.map((doc) {
        return appUser(
            id: doc.id,
            address: doc['address'],
            email: doc['email'],
            role: doc['role'],
            imageUrl: doc['image_url'],
            userName: doc['username']);
      }).toList();
    } catch (e) {
      print('Error fetching user accounts: $e');
      return [];
    }
  }
}
