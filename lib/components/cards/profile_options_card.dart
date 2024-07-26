import 'package:flutter/material.dart';

class ProfileOption extends StatelessWidget {
  Widget child;
  void Function()? onTapped;
  Alignment alignment;
  ProfileOption({
    super.key, required this.child, required this.onTapped,this.alignment = Alignment.center
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapped,
      child: Ink(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: child
                    ),
                  )
                ],
              ),
            ],
          )
       ),
    );
  }
}