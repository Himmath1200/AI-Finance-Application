import 'package:flutter/material.dart';
import 'package:ai_finance_platform/utils/index.dart';

const _border = Color(0xFF1A3A6B);
const _focusBorder = Color(0xFF2979FF);
const _fill = Color(0xFF0D1E3C);
const _hintColor = Color(0xFF4A6080);
const _labelColor = Color(0xFF8BA3C9);
const _iconColor = Color(0xFF4A6080);
const _activeIconColor = Color(0xFF2979FF);

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final int? maxLines;
  final int? minLines;
  final ValueChanged<String>? onChanged;
  final bool readOnly;

  const CustomTextField({
    Key? key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.readOnly = false,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: _labelColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Focus(
          onFocusChange: (v) => setState(() => _focused = v),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: _obscureText,
            validator: widget.validator,
            maxLines: _obscureText ? 1 : widget.maxLines,
            minLines: widget.minLines,
            onChanged: widget.onChanged,
            readOnly: widget.readOnly,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            cursorColor: _focusBorder,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(color: _hintColor, fontSize: 14),
              filled: true,
              fillColor: _fill,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 16),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: _focused ? _activeIconColor : _iconColor,
                      size: 20,
                    )
                  : null,
              suffixIcon: widget.obscureText
                  ? GestureDetector(
                      onTap: () =>
                          setState(() => _obscureText = !_obscureText),
                      child: Icon(
                        _obscureText
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: _focused ? _activeIconColor : _iconColor,
                        size: 20,
                      ),
                    )
                  : (widget.suffixIcon != null
                      ? GestureDetector(
                          onTap: widget.onSuffixIconPressed,
                          child: Icon(widget.suffixIcon,
                              color: _iconColor, size: 20),
                        )
                      : null),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusMedium),
                borderSide: const BorderSide(color: _border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusMedium),
                borderSide:
                    const BorderSide(color: _focusBorder, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusMedium),
                borderSide:
                    const BorderSide(color: Color(0xFFCF6679), width: 1.2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusMedium),
                borderSide:
                    const BorderSide(color: Color(0xFFCF6679), width: 1.5),
              ),
              errorStyle: const TextStyle(
                  color: Color(0xFFCF6679), fontSize: 11),
            ),
          ),
        ),
      ],
    );
  }
}

/// Dark-styled dropdown
class CustomDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? hint;

  const CustomDropdown({
    Key? key,
    required this.label,
    this.value,
    required this.items,
    required this.onChanged,
    this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _labelColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
                value: value,
                hint: Text(hint ?? 'Select $label',
                    style: const TextStyle(color: _hintColor, fontSize: 14)),
                dropdownColor: const Color(0xFF0D1E3C),
                style: const TextStyle(color: Colors.white, fontSize: 15),
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: _iconColor),
                items: items
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
                onChanged: onChanged,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _fill,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusMedium),
                    borderSide: const BorderSide(color: _border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusMedium),
                    borderSide:
                        const BorderSide(color: _focusBorder, width: 1.5),
                  ),
                ),
        ),
      ],
    );
  }
}

/// Slider with dark label row
class CustomSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final String? displayValue;

  const CustomSlider({
    Key? key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.displayValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    color: _labelColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF1A3A6B)),
              ),
              child: Text(
                displayValue ?? value.toStringAsFixed(0),
                style: const TextStyle(
                  color: Color(0xFF82B1FF),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: const Color(0xFF2979FF),
            inactiveTrackColor: const Color(0xFF1A3A6B),
            thumbColor: const Color(0xFF2979FF),
            overlayColor: const Color(0xFF2979FF).withOpacity(0.12),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
