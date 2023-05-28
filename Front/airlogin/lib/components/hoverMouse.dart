import 'package:flutter/material.dart';

class HoverColorButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final Color defaultColor;
  final Color hoverColor;
  final Color defaultTextColor;
  final Color hoverTextColor;
  final Color defaultIconColor;
  final Color hoverIconColor;
  final double buttonWidth;
  final double buttonHeight;
  final VoidCallback onPressed;

  HoverColorButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.defaultColor,
    required this.hoverColor,
    required this.defaultTextColor,
    required this.hoverTextColor,
    required this.defaultIconColor,
    required this.hoverIconColor,
    required this.buttonWidth,
    required this.buttonHeight,
    required this.onPressed,
  }) : super(key: key);

  @override
  _HoverColorButtonState createState() => _HoverColorButtonState();
}

class _HoverColorButtonState extends State<HoverColorButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (PointerEvent event) => setState(() => _isHovered = true),
      onExit: (PointerEvent event) => setState(() => _isHovered = false),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              color:
                  _isHovered ? widget.hoverIconColor : widget.defaultIconColor,
            ),
            SizedBox(width: 8.0),
            Text(
              widget.text,
              style: TextStyle(
                color: _isHovered
                    ? widget.hoverTextColor
                    : widget.defaultTextColor,
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          primary: _isHovered ? widget.hoverColor : widget.defaultColor,
          minimumSize: Size(widget.buttonWidth, widget.buttonHeight),
        ),
      ),
    );
  }
}
