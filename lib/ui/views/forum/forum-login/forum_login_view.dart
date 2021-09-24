import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/forum/forum-login/forum_login_model.dart';
import 'package:stacked/stacked.dart';

class ForumLoginView extends StatelessWidget {
  const ForumLoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => ForumLoginModel(),
        builder: (context, model, child) => Scaffold());
  }
}
