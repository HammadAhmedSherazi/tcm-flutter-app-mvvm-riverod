import '../export_all.dart';

import '../data/network/http_client.dart';
abstract class  ChatRemoteRepoSource {
  getChatListRepo({required Map<String, dynamic> input}){}
  getChatMessageListRepo({required Map<String, dynamic> input}){}
  createChatRepo({required Map<String, dynamic> input, required File ? file}){}
  getNotificaionsRepo({required Map<String, dynamic> input})async{}
  deleteChatRepo({required int chatId})async{}


}

class  ChatRemoteRepo extends ChatRemoteRepoSource {

  @override
  getChatListRepo({required Map<String, dynamic> input}){
    try {
      final result =  HttpClient.instance.post(
        {
          'query': GraphQLQueries.chatListQuery,
          'variables': {
            'input': input,
          },
        },
      );
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  getChatMessageListRepo({required Map<String, dynamic> input}) {
    try {
      final result =  HttpClient.instance.post(
        {
          'query': GraphQLQueries.chatMessageListQuery,
          'variables': {
            'input': input,
          },
        },
      );
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  createChatRepo({required Map<String, dynamic> input ,required File ? file}) {
     try {
       final result = file != null
          ? HttpClient.instance.post({
              'query': GraphQLQueries.createChatQuery,
              'variables': {
                'input': input,
              },
              'files': file
            }, isMultipartRequest: true,variableName: "variables.input.media")
          : HttpClient.instance.post(
              {
                'query': GraphQLQueries.createChatQuery,
                'variables': {
                  'input': input,
                },
              },
              
            );
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  getNotificaionsRepo({required Map<String, dynamic> input})async{
    try {
      final result =  HttpClient.instance.post(
        {
          'query': GraphQLQueries.notificationQuery,
          'variables': {
            'input': input,
          },
        },
      );
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  deleteChatRepo({required int chatId}) {
   try {
      final result =  HttpClient.instance.post(
        {
          'query': GraphQLQueries.deleteAdChatQuery,
          'variables': {
  "deleteAdsChatId": chatId
},
        },
      );
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }
  
}

