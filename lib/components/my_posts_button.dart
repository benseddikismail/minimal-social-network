import 'package:flutter/material.dart';

class PostsButton extends StatelessWidget {
  
  final void Function()? onTap;

  const PostsButton({
    super.key,
    // required this.text,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12)
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(left: 20),
        child: Center(
          // child: Text(
          //   text,
          //   style: const TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 16
          //   )
          // ),
          child: Icon(
            Icons.post_add, 
            color: Theme.of(context).colorScheme.primary
          ),
        )
      ),
    );

  }

}
