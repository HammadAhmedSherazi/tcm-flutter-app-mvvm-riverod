import 'package:tcm/data/network/http_client.dart';
import '../data/enums/graphql_queries.dart';
import '../export_all.dart';

abstract class NotepadRemoteRepoSource {
  getNotesRepo({required String? cursor, required int limit, required String? searchText}) async {}
  removeNoteRepo({required List <int> ids}) async {}
  addNoteRepo({required String title, required String description}) async {}
  updateNoteRepo(
      {required String title,
      required String description,
      required int id}) async {}
  removeAllNotesRepo() async {}
}

class NotepadRemoteRepo extends NotepadRemoteRepoSource {
  @override
  getNotesRepo({required String? cursor, required int limit, required String? searchText}) async {
    try {
      final result = await HttpClient.instance.post({
        'query': GraphQLQueries.getNotesQuery,
        'variables': {
          "input": {"cursor": cursor, "limit": limit, "title": searchText}, 
        }
      });
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  addNoteRepo({required String title, required String description}) async {
    try {
      final result = await HttpClient.instance.post({
        'query': GraphQLQueries.createNoteQuery,
        'variables': {
          "input": {"description": description, "title": title}
        }
      });
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  updateNoteRepo(
      {required String title,
      required String description,
      required int id}) async {
    try {
      final result = await HttpClient.instance.post({
        'query': GraphQLQueries.updateNoteQuery,
        'variables': {
          "input": {"description": description, "title": title, 'id': id}
        }
      });
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  removeNoteRepo({required List <int> ids}) async {
    try {
      final result = await HttpClient.instance.post({
        'query': GraphQLQueries.deleteNoteQuery,
        'variables': {"deleteNoteId": ids}
      });
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }
}
