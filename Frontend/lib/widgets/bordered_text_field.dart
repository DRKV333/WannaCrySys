import 'package:flutter/material.dart';

class BorderedTextField extends StatefulWidget {
  final String _hintText;
  final TextEditingController _controller;
  final TextInputType _inputType;
  late final bool _passwordText;
  final Function? validateFun;

  BorderedTextField(this._controller, this._hintText, this._inputType,
      {Key? key, bool passwordText = false, this.validateFun})
      : super(key: key) {
    _passwordText = passwordText;
  }

  @override
  State<BorderedTextField> createState() => _BorderedTextFieldState();
}

class _BorderedTextFieldState extends State<BorderedTextField> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = widget._passwordText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: TextFormField(
        keyboardType: widget._inputType,
        controller: widget._controller,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            hintText: widget._hintText,
            border: const OutlineInputBorder(),
            suffixIcon: widget._passwordText
                ? IconButton(
                    onPressed: () => setState(() {
                          obscureText = !obscureText;
                        }),
                    icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility))
                : null),
        obscureText: obscureText,
        validator: (value) {
          return widget.validateFun != null ? widget.validateFun!(value) : null;
        },
      ),
    );
  }

  @override
  void dispose() {
    widget._controller.dispose();
    super.dispose();
  }
}
