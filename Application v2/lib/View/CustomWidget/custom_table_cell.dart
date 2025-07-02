import 'package:flutter/material.dart';
import 'package:mercury/View/Theme/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomTableCell extends StatelessWidget
{
  final String text;
  final double width;
  final double height;
  final bool isHeader;
  final Alignment alignment;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final double? fontsize;
  final TextStyle? textStyle;

  const CustomTableCell(
      this.text, {
        super.key,
        required this.width,
        required this.height,
        this.isHeader = false,
        this.alignment = Alignment.centerLeft,
        this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        this.backgroundColor,
        this.fontsize,
        this.textStyle,
      });

  @override
  Widget build(BuildContext context)
  {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    Color textColor = Colors.black87;
    if(isDark)
    {
      textColor = Colors.white.withAlpha(1000);
    }

    Color defaultBgColor = Colors.grey.shade500;
    if(isDark)
    {
      defaultBgColor = Color(0xFF131313);
    }

    final defaultTextStyle = TextStyle(
      fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
      color: textColor,
      fontSize: fontsize ?? 16,
    );

    return Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBgColor,
        border: Border.all(color: Colors.grey.shade700, width: 0.5),
      ),
      child: Text(
        text,
        style: textStyle ?? defaultTextStyle,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
