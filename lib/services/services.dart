import 'package:chat_gpt/widgets/drop_down.dart';
import 'package:flutter/material.dart';
import '../constants/constant.dart';
import 'package:chat_gpt/widgets/text_widget.dart';
class Services{

  static Future<void> shoModalSheet(BuildContext context )async{

    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20),),
      ),
      backgroundColor: scaffoldBackground,
      context: context,
      builder: (context) {
        return const Padding(
          padding: EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child:
                TextWidget(
                    label: "Chosen Model:",
                    fontSize: 16
                ),
              ),
              Flexible(
                flex: 2,
                child: ModelsDropDownWidget(),),
            ],
          ),
        );
      },
    );
  }
}