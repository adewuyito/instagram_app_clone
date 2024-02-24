import 'package:flutter/material.dart';
import 'package:instagram_app_clone/features/image_upload/views/create_new_post_view.dart';
import 'package:intl/intl.dart';

class PostDate extends StatelessWidget {
  final DateTime postDateTime;
  const PostDate({
    super.key,
    required this.postDateTime,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('d MMMM, yyyy, hh:mm a');
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: formatter.format(postDateTime).toText,
    );
  }
}
 