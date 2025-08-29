import 'package:flutter_stripe/flutter_stripe.dart';
import '../export_all.dart';
class CardRepoProvider extends ChangeNotifier {
  late final CardRemoteRepo repo;
  CardRepoProvider({required this.repo});
  ApiResponse _myCardApiResponse = ApiResponse.undertermined();
  ApiResponse _addCardApiResponse = ApiResponse.undertermined();
  ApiResponse _removeCardApiResponse = ApiResponse.undertermined();
  ApiResponse _addBankDetailApiResponse = ApiResponse.undertermined();
  ApiResponse _getTransactionApiResponse = ApiResponse.undertermined();
  ApiResponse _withDrawApiResponse = ApiResponse.undertermined();
  ApiResponse<WalletDetailModel?> _getWalletDetailApiResponse = ApiResponse.undertermined();

  List<CardDataModel> cards = [];
  List<TransactionDataModel> transactions = [];
  bool saveCard = false;

  CardDataModel? selectCard;
  String? transactionCursor;

  final String stripeSecretKey =
      'sk_test_51QnJntLl345fBfXMUcQbAS1jrzsl0Oqxb8ggVf7vrL1tbKM1jFEAoH83SFGTvGYjqQf85C0JsPJazj6Lx6YWOnHm00YJWgSMak';

  setCard(CardDataModel card) {
    selectCard = card;
    notifyListeners();
  }

  unsetCard() {
    selectCard = null;
    saveCard = false;
    notifyListeners();
  }

  void checkSaveCard() {
    saveCard = !saveCard;
    notifyListeners();
  }

  Future getCards() async {
    try {
      _myCardApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await repo.getCardRepo();
      if (response != null) {
        final data = response['data'];
        final temp = data['myCards'];
        _myCardApiResponse = ApiResponse.completed(data);
        cards = List.from(temp.map((e) => CardDataModel.fromJson(e)));
      } else {
        _myCardApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _myCardApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  // Future<void> attachPaymentMethod() async {
  //   try {
  //     // Confirm SetupIntent with PaymentMethod (e.g., Card)
  //     final setupIntent = await Stripe.instance.confirmSetupIntent(
  //       paymentIntentClientSecret: stripeSecretKey,
  //       params: const PaymentMethodParams.usBankAccount(
  //           paymentMethodData: PaymentMethodDataUsBank(
  //         accountNumber: '000123456789',
  //         routingNumber: '110000000',
  //         billingDetails: BillingDetails(
  //           name: "John Doe",
  //           email: "john@example.com",
  //         ),
  //         accountHolderType: BankAccountHolderType.Individual,
  //       )),
  //     );

  //     // If successful, you get a SetupIntent with attached payment method
  //     debugPrint("✅ SetupIntent confirmed: ${setupIntent.paymentMethodId}");
  //     // You can now save this PaymentMethod ID to use for future payments
  //   } on StripeException catch (e) {
  //     debugPrint("❌ Stripe error: ${e.error.localizedMessage}");
  //   } catch (e) {
  //     debugPrint("❌ Unexpected error: $e");
  //   }
  // }

  Future addCard(bool isCheckOut) async {
    try {
      _addCardApiResponse = ApiResponse.loading();
      notifyListeners();
      final data = await Stripe.instance.createPaymentMethod(
        params: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );

      final response = await repo.addCardRepo(id: data.id);
      if (response != null) {
        _addCardApiResponse = ApiResponse.completed(data);
        getCards();
        if (isCheckOut) {
          selectCard = CardDataModel(
              id: data.id,
              brand: data.card.brand ?? "",
              expMonth: data.card.expMonth.toString(),
              expYear: data.card.expYear.toString(),
              last4: data.card.last4 ?? "",
              fingerPrint: "");
          AppRouter.customback(times: 2);
        } else {
          AppRouter.back();
        }
      } else {
        _addCardApiResponse = ApiResponse.error();
      }

      notifyListeners();
    } catch (e) {
      Helper.showMessage("Something went wrong!");
      _addCardApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future removeCard({required String id, required int index}) async {
    try {
      _removeCardApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await repo.removeCardRepo(id: id);
      if (response != null) {
        AppRouter.back();
        _removeCardApiResponse = ApiResponse.completed(response);
        cards.removeAt(index);
        Helper.showMessage(response['data']['removeCard']['message'] ??
            "Successfully remove card");
      } else {
        _removeCardApiResponse = ApiResponse.error();
      }

      notifyListeners();
    } catch (e) {
      _removeCardApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future addBanKDetails(
      {required String name,
      required String accNum,
      required String rouNum,
      required BankAccountHolderType type,
      required String country,
      required String currency}) async {
    try {
      _addBankDetailApiResponse = ApiResponse.loading();
      notifyListeners();
      final tokenData = await Stripe.instance.createToken(
          CreateTokenParams.bankAccount(
              params: BankAccountTokenParams(
                  accountNumber: accNum,
                  country: country,
                  currency: currency,
                  routingNumber: rouNum,
                  accountHolderName: name,
                  accountHolderType: type)));

      final bankToken = tokenData.id;
      final response = await repo.addBankRepo(id: bankToken);
      if (response != null) {
        _addBankDetailApiResponse = ApiResponse.completed(response);
        final data = response['data']['attachBank'];
        Helper.showMessage(data['message'] ?? "Successfully add bank");
      
        getWalletDetails();
        getTransaction(cursor: null, limit: 10, type: "Withdraw");
        AppRouter.back();
      } else {
        _addBankDetailApiResponse = ApiResponse.error();
      }

      notifyListeners();
    } on StripeException catch (e) {
      Helper.showMessage("${e.error.localizedMessage}");
      _addBankDetailApiResponse = ApiResponse.error();
      notifyListeners();
    } catch (e) {
      _addBankDetailApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future getWalletDetails() async {
    try {
      _getWalletDetailApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await repo.getWalletDetailRepo();
      if (response != null) {
        _getWalletDetailApiResponse = ApiResponse.completed(WalletDetailModel.fromJson(response['data']['walletsDetails']));
      } else {
        _getWalletDetailApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _getWalletDetailApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future getTransaction({required String? cursor, required int limit, required String type}) async {
    try {
      if(cursor == null){
        _getTransactionApiResponse = ApiResponse.loading();
        transactionCursor = null;
        if(transactions.isNotEmpty){
          transactions.clear();
        }
      }
      else{
        _getTransactionApiResponse = ApiResponse.loadingMore();
      }
      
      notifyListeners();
      final response = await repo.getTransactionRepo(cursor:cursor ,limit:limit, type: type );
      if (response != null) {
        final data = response['data']['allTransaction'];
        List temp = data['data'];
        transactionCursor = data['nextCursor'];
        if(cursor == null){
          transactions = List.from(temp.map((e) => TransactionDataModel.fromJson(e)));
        }
        else{
          transactions.addAll(List.from(temp.map((e) => TransactionDataModel.fromJson(e))));
        }
        
        _getTransactionApiResponse = ApiResponse.completed(response);
      } else {
        _getTransactionApiResponse = cursor == null ? ApiResponse.error() : ApiResponse.undertermined();
      }
      notifyListeners();
    } catch (e) {
      _getTransactionApiResponse = cursor == null ? ApiResponse.error() : ApiResponse.undertermined();
      notifyListeners();
    }
  }

  Future payOut()async{
    try {
      _withDrawApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await repo.withDrawalRepo();
      if (response != null) {
        _withDrawApiResponse = ApiResponse.completed(response);
        Helper.showMessage(response['data']['payout']['message'] ?? "Successfully withdraw");
        getWalletDetails();
        getTransaction(cursor: null, limit: 10, type: "Withdraw");
  
      } else {
        _withDrawApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _withDrawApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  ApiResponse get myCardApiResponse => _myCardApiResponse;
  ApiResponse get addCardApiResponse => _addCardApiResponse;
  ApiResponse get removeCardApiResponse => _removeCardApiResponse;
  ApiResponse get addBankDetailApiResponse => _addBankDetailApiResponse;
  ApiResponse get getTransactionApiResponse => _getTransactionApiResponse;
  ApiResponse get withDrawApiResponse => _withDrawApiResponse;
  ApiResponse<WalletDetailModel?> get getWalletDetailApiResponse => _getWalletDetailApiResponse;
}

final cardProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    ref.keepAlive();
    return CardRepoProvider(repo: CardRemoteRepo());
  },
);
