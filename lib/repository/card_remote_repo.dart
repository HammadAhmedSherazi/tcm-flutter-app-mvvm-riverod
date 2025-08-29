import 'package:tcm/data/network/http_client.dart';
import '../export_all.dart';

abstract class CardRemoteRepoSource {
  getCardRepo() async {}
  removeCardRepo({required String id}) async {}
  addCardRepo({required String id}) async {}
  addBankRepo({required String id}) async {}
  getWalletDetailRepo() async {}
  getTransactionRepo({required int limit, required String? cursor, required String type}) async {}
  withDrawalRepo() async {}
}

class CardRemoteRepo extends CardRemoteRepoSource {
  @override
  getCardRepo() async {
    try {
      final result =
          await HttpClient.instance.post({'query': GraphQLQueries.myCardQuery});
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  removeCardRepo({required String id}) async {
    try {
      final result = await HttpClient.instance.post({
        'query': GraphQLQueries.removeCardQuery,
        'variables': {"removeCardId": id},
      });
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  addCardRepo({required String id}) async {
    try {
      final result = await HttpClient.instance.post({
        'query': GraphQLQueries.saveCardQuery,
        'variables': {"paymentMethodId": id},
      });
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  addBankRepo({required String id}) async {
    try {
      final result = await HttpClient.instance.post({
        'query': GraphQLQueries.attachBankQuery,
        'variables': {"bankToken": id},
      });
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  getWalletDetailRepo() async {
    try {
      final result = await HttpClient.instance.post({
        'query': GraphQLQueries.walletDetailQuery,
      });
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  getTransactionRepo({required int limit, required String? cursor, required String type}) async {
    try {
      final result = await HttpClient.instance.post({
        'query': GraphQLQueries.transactionQuery,
        'variables': {
          "input": {"cursor": cursor, "limit": limit, "type" : type }
        }
      });
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  withDrawalRepo()async {
     try {
      final result = await HttpClient.instance.post({
        'query': GraphQLQueries.payoutQuery,
        
      });
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }
}
