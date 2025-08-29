import '../export_all.dart';

class NotepadRepoProvider extends ChangeNotifier {
  late final NotepadRemoteRepo repo;

  NotepadRepoProvider({required this.repo});

  ApiResponse _getNoteApiResponse = ApiResponse.undertermined();
  ApiResponse _addNoteApiResponse = ApiResponse.undertermined();
  ApiResponse _deleteNoteApiResponse = ApiResponse.undertermined();

  String? cursor;
  bool allSelect = false;
  List<NoteDataModel> notes = [];
  // List<int> check = [];

  Future getNotes({required String? inputCursor, required int limit, required String? searchText}) async {
    try {
      if (cursor == null) {
        if (notes.isNotEmpty) {
          notes.clear();
        }
        _getNoteApiResponse = ApiResponse.loading();
      } else {
        _getNoteApiResponse = ApiResponse.loadingMore();
      }

      notifyListeners();
      final response = await repo.getNotesRepo(cursor: cursor, limit: limit,searchText: searchText);
      if (response != null) {
        allSelect = false;
        final data = response['data']['getAllNote'];
        cursor = data['nextCursor'];
        List temp = data['data'];
        if (inputCursor == null) {
          notes = List.from(temp.map((e) => NoteDataModel.fromJson(e)));
        } else {
          notes.addAll(List.from(temp.map((e) => NoteDataModel.fromJson(e))));
        }
        _getNoteApiResponse = ApiResponse.completed(response);

         
      } else {
        _getNoteApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _getNoteApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future addNote({required String title, required String description}) async {
    try {
      _addNoteApiResponse = ApiResponse.loading();
      notifyListeners();
      final response =
          await repo.addNoteRepo(title: title, description: description);
      if (response != null) {
        getNotes(inputCursor: null, limit: 10, searchText: null);
        _addNoteApiResponse = ApiResponse.completed(response);
        Helper.showMessage(response['data']['createNote']['message']);
        AppRouter.back();
      } else {
        _addNoteApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _addNoteApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future updateNote(
      {required String title,
      required String description,
      required int id}) async {
    try {
      _addNoteApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await repo.updateNoteRepo(
          title: title, description: description, id: id);
      if (response != null) {
        _addNoteApiResponse = ApiResponse.completed(response);
        Helper.showMessage(response['data']['updateNote']['message']);
        AppRouter.back();
        getNotes(inputCursor: null, limit: 10, searchText: null);
      } else {
        _addNoteApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _addNoteApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future deleteNote({required List<int> ids}) async {
    try {
      _deleteNoteApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await repo.removeNoteRepo(ids: ids);
      if (response != null) {
        
        _deleteNoteApiResponse = ApiResponse.completed(response);
        Helper.showMessage(response['data']['deleteNote']['message']);
        AppRouter.back();
        getNotes(inputCursor: null, limit: 10, searchText: null);
      } else {
        _deleteNoteApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _deleteNoteApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  
  void selectNote(int index) {
    final note = notes[index];

    notes[index].isSelect = !note.isSelect;

    allSelect = notes.every((note) => note.isSelect);

   

    notifyListeners();
    
  }

  void selectAll(){
    allSelect = !allSelect;
    
    if(allSelect){
     notes = List.from(notes.map((e)=> NoteDataModel(id: e.id, title: e.title, description: e.description, createdAt: e.createdAt, isSelect: true)));
    }
    else{
     notes = List.from(notes.map((e)=> NoteDataModel(id: e.id, title: e.title, description: e.description, createdAt: e.createdAt, isSelect: false)));

    }
   
    notifyListeners();
  }

  ApiResponse get getNoteApiResponse => _getNoteApiResponse;
  ApiResponse get addNoteApiResponse => _addNoteApiResponse;
  ApiResponse get deleteNoteApiResponse => _deleteNoteApiResponse;
}

final noteProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    ref.keepAlive();
    return NotepadRepoProvider(repo: NotepadRemoteRepo());
  },
);
