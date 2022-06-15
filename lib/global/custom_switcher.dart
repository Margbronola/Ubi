import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomSwitcher extends StatefulWidget {
  CustomSwitcher({Key? key, required this.isEnabled, required this.callback}): super(key: key);
  bool isEnabled;
  final ValueChanged<bool> callback;

  @override
  State<CustomSwitcher> createState() => _CustomSwitcherState();
}

class _CustomSwitcherState extends State<CustomSwitcher> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 45,
      child: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              widget.isEnabled = !widget.isEnabled;
            });
            widget.callback(widget.isEnabled);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                // left: 10,
                // right: 10,
                bottom: 0,
                child: Center(
                  child: AnimatedContainer(
                    width: 50,
                    duration: const Duration(
                      milliseconds: 500,
                    ),
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              // AnimatedPositioned(
              //   left: !widget.isEnabled ? 35 : 10,
              //   right: !widget.isEnabled ? 10 : 35,
              //   top: 0,
              //   duration: const Duration(
              //     milliseconds: 300,
              //   ),
              //   bottom: 0,
              //   child: FittedBox(
              //       child: AnimatedSwitcher(
              //     duration: Duration(milliseconds: 500),
              //     child: Text(
              //       widget.isEnabled ? "On" : "Off",
              //       style: const TextStyle(
              //         color: Colors.white,
              //       ),
              //     ),
              //   )),
              // ),

              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                top: 0,
                bottom: 0,
                left: widget.isEnabled ? 30 : 1,
                right: widget.isEnabled ? 1 : 30,
                child: Center(
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.isEnabled ? const Color.fromARGB(255, 232, 149, 40) : Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
