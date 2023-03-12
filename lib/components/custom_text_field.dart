import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_factory_calendar_scheduler/consts/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.isTime,
  });

  final String label;
  final bool isTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        //TextFormField 여러개의 텍스트필드를 하나의 폼으로 제어할때 주로사용, TextField위젯은 텍스트필드가 독립된 형태일때 사용
        //16장 473page
        Expanded(
          flex: isTime ? 0 : 1,
          child: TextFormField(
            cursorColor: Colors.grey,
            maxLines: isTime ? 1 : null,
            expands: !isTime,
            keyboardType:
                isTime ? TextInputType.number : TextInputType.multiline,
            inputFormatters:
                isTime ? [FilteringTextInputFormatter.digitsOnly] : [],
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey[300],
              suffixText: isTime ? '시' : null,
            ),
          ),
        ),
      ],
    );
  }
}
