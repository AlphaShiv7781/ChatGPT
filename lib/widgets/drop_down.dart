import 'package:chat_gpt/constants/constant.dart';
import 'package:chat_gpt/models/model.dart';
import 'package:chat_gpt/providers/model_provider.dart';
import 'package:chat_gpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ModelsDropDownWidget extends StatefulWidget {
  const ModelsDropDownWidget({Key? key}) : super(key: key);

  @override
  State<ModelsDropDownWidget> createState() => _ModelsDropDownWidgetState();
}

class _ModelsDropDownWidgetState extends State<ModelsDropDownWidget> {

  String ?currentModels;
  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context,listen:false);
    currentModels = modelsProvider.getCurrentModel;
    return FutureBuilder<List<ModelsModel>>(

        future: modelsProvider.getAllModel(),
        builder: (context, snapshot){

          if(snapshot.hasError){
            return Center(
              child: TextWidget(label: snapshot.error.toString()),
            );
          }
          return snapshot.data == null || snapshot.data!.isEmpty ? const SizedBox.shrink():
          FittedBox(
            child: DropdownButton(
                 dropdownColor: scaffoldBackground,
                  items:  List<DropdownMenuItem<String>>.generate(
                    snapshot.data!.length,
               (index) => DropdownMenuItem(
                value: snapshot.data![index].id,
                child: TextWidget(
                label: snapshot.data![index].id,
                 fontSize: 15,
               ),),),
                value: currentModels,
                onChanged: (value){
                  setState(() {
                    currentModels = value.toString();
                  });
                  modelsProvider.setCurrentModel(value.toString());
                }),
          );
        }
    ) ;
  }
}
