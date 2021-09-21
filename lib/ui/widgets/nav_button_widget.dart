import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/home/home_viemmodel.dart';

class NavButtonWidget extends StatelessWidget {
  final String text, url;
  final Icon icon;
  final bool isWebComponent;
  final HomeViewModel viewModel;
  const NavButtonWidget(
      {Key? key,
      required this.text,
      required this.url,
      required this.icon,
      required this.isWebComponent,
      required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isWebComponent) {
          viewModel.goToBrowser(url);
        } else {
          viewModel.navNonWebComponent();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          width: 160,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(0xD0, 0xD0, 0xD5, 1),
            border: Border.all(color: Colors.black, width: 3),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: icon,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
