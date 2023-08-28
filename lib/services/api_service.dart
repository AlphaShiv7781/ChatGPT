import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:chat_gpt/constants/apiConsts.dart';

import '../models/chatModel.dart';
import '../models/model.dart';

class ApiServices {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(Uri.parse("$BASE_URL/models"),
          headers: {'Authorization': 'Bearer $ModelApiKey'});

      Map jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['error'] != null) {
        print("jsonResponse['error']['message']");
        throw HttpException(jsonResponse['error']['message']);
      }
      print("jsonResponse $jsonResponse");
      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
        // print("temp ${value["id"]}");
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      print("error $error");
      rethrow;
    }
  }

  //send message
  static Future<List<ChatModel>> sendMessage(
      String message, String modelId) async {
    try {
      var response = await http.post(
        Uri.parse("$BASE_URL/chat/completions"),
        headers: {
          'Authorization': 'Bearer $ReqApiKey',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": modelId,
            "messages": [
              {"role": "user", "content": message},
            ],
            "temperature": 0.7
          },
        ),
      );

      Map jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['error'] != null) {
        print("jsonResponse['error'] $jsonResponse['error']['message']");
        throw HttpException(jsonResponse['error']['message']);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        // print("jsonResponse[choices]text ${jsonResponse["choices"][0]["message"]["content"]}");

        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
              msg: jsonResponse["choices"][index]["message"]["content"],
              chatIndex: 1),
        );
      }
      return chatList;
    } catch (error) {
      print("error $error");
      rethrow;
    }
  }
}
