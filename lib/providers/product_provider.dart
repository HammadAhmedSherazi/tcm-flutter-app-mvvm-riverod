import '../export_all.dart';

class ProductProvider with ChangeNotifier {
  final ProductRemoteRepo productRepo = ProductRemoteRepo();
  final MapsRepository mapRepo = MapsRepository();
  ApiResponse _categoryApiResponse = ApiResponse.undertermined();
  ApiResponse _createAdApiResponse = ApiResponse.undertermined();
  ApiResponse _checkoutApiResponse = ApiResponse.undertermined();
  ApiResponse _addToCartApiResponse = ApiResponse.undertermined();
  ApiResponse _getCartItemsApiResponse = ApiResponse.undertermined();
  ApiResponse _clearCartItemsApiResponse = ApiResponse.undertermined();
  ApiResponse _deleteItemsApiResponse = ApiResponse.undertermined();

  ApiResponse _mainCategoryApiResponse = ApiResponse.undertermined();
  ApiResponse _deleteAdApiResponse = ApiResponse.undertermined();
  ApiResponse _homeProductsApiResponse = ApiResponse.undertermined();
  ApiResponse<MarketPlaceDataModel?> _marketPlaceProductsApiResponse =
      ApiResponse.undertermined();
  ApiResponse<MarketPlaceDataModel?> _venderProductsApiResponse =
      ApiResponse.undertermined();

  ApiResponse _similarProductsApiResponse = ApiResponse.undertermined();
  ApiResponse _myAdApiResponse = ApiResponse.undertermined();
  ApiResponse<ProductDetailDataModel?> _productDetailApiResponse =
      ApiResponse.undertermined();
  ApiResponse _notifyApiResponse = ApiResponse.undertermined();
  ApiResponse _notifyListApiResponse = ApiResponse.undertermined();
  ApiResponse _seeAllAdsApiResponse = ApiResponse.undertermined();
  ApiResponse _favouriteProductApiResponse = ApiResponse.undertermined();
  ApiResponse _getTopStoresApiResponse = ApiResponse.undertermined();
  ApiResponse _getStoreProductDetailApiResponse = ApiResponse.undertermined();
  ApiResponse _orderCheckOutApiResponse = ApiResponse.undertermined();
  ApiResponse _buyNowApiResponse = ApiResponse.undertermined();
  ApiResponse _orderApiResponse = ApiResponse.undertermined();
  ApiResponse _orderAdApiResponse = ApiResponse.undertermined();
  ApiResponse _adBuyNowApiResponse = ApiResponse.undertermined();
  ApiResponse _productReviewApiResponse = ApiResponse.undertermined();
  ApiResponse _createProductReviewApiResponse = ApiResponse.undertermined();
  ApiResponse _getRefundRequestApiResponse = ApiResponse.undertermined();

  String? categoryCurson,
      adProuctCursor,
      notifyListCursor,
      seeAllAdCursor,
      favouriteListCursor,
      orderHistoryCursor,
      orderAdHistoryCursor,
      reviewCursor,refundRequestCursor;
  int? lastId;
  int? notifyId;
  CategoryDataModel? selectedCategory, lastSelectedCategory;
  int minLength = 0;
  ProductDetailDataModel? adReview;
  String status = "Active";
  List<CategoryDataModel> allCategories = [];
  List<CategoryDataModel> brandList = [];
  List<RefundRequestDataModel> refundRequestList = [];

  List<CategoryDataModel> mainCategories = [];
  List<CheckoutListItemModel> checkOutList = [];
  List<int> selectItemsId = [];
  List<ProductDataModel> preOwnedProducts = [];
  List<ProductDataModel> similarProducts = [];

  List<ProductDataModel> seeAllProducts = [];
  List<ProductDataModel> searchProducts = [];

  List<ProductDataModel> discountedProducts = [];
  List<ProductDataModel> storeProducts = [];
  List<ProductDataModel> dealProducts = [];
  List<ProductDataModel> favouriteProducts = [];

  List<TopVenderDataModel> topStores = [];
  List<OrderDataModel> orderHistory = [];
  List<AdOrderDataModel> adOrderHistory = [];

  List<ProductDetailDataModel> myAdProducts = [];
  List<AdDataModel> myNotfiyList = [];

  List<StoreOrderDataModel> orders = [];

  List<ProductReviewsDataModel> productReviews = [];

  bool isFavourite = false;
  int selectedCategoryPageCount = 0;
  UserDataModel? userData;

  LocationData? deliveryLocation;

  List<ProductDataModel> loadingProduct = List.generate(
    5,
    (index) => ProductDataModel(
        id: 4,
        productName: 'Bold, vibrant 100% cotton beach towels.',
        productImage: 'https://i.ibb.co/2WLKNNS/image3.png',
        productPrice: 15.99,
        categoryId: -1,
        status: "",
        checkIn: "",
        checkOut: ""),
  );

  void favouriteToggeleNearbyItem(int index) {
    // Ensure the index is valid
  }

  Future getAllCategories({required int limit, int? id, String? cursor}) async {
    lastId = id;
    try {
      if (lastId == null) {
        selectedCategory = null;
        selectedCategoryPageCount = 0;
      }
      // if (lastId != null &&
      //     allCategories.isNotEmpty &&
      //     selectedCategory == null) {

      //   selectedCategory =
      //       allCategories.firstWhere((element) => element.id == lastId,orElse: () => null,);
      // }
      if (lastId != null && lastSelectedCategory == null) {
        selectedCategoryPageCount++;
      }
      if (cursor == null) {
        _categoryApiResponse = ApiResponse.loading();

        selectItemsId.clear();
        allCategories.clear();
      } else {
        _categoryApiResponse = ApiResponse.loadingMore();
      }

      notifyListeners();
      final response = await productRepo.sendRequest(
          input: {"limit": limit, "parent_id": id, "cursor": cursor},
          query: GraphQLQueries.allCategoriesQuery);
      if (response != null) {
        List temp = response['data']['allCategory']['data'] ?? [];
        categoryCurson = response['data']['allCategory']['nextCursor'];
        if (temp.isNotEmpty) {
          if (cursor == null) {
            allCategories = List.from(
                temp.map((e) => CategoryDataModel.fromJson(e, id == null)));
          } else {
            allCategories.addAll(List.from(
                temp.map((e) => CategoryDataModel.fromJson(e, id == null))));
          }
        }
        _categoryApiResponse = ApiResponse.completed(response);
      } else {
        _categoryApiResponse =
            cursor == null ? ApiResponse.error() : ApiResponse.undertermined();
      }
      notifyListeners();
    } catch (e) {
      _categoryApiResponse =
          cursor == null ? ApiResponse.error() : ApiResponse.undertermined();
      notifyListeners();
    }
  }

  Future getMainCategories({required int? limit}) async {
    try {
      _mainCategoryApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await productRepo.sendRequest(
          input: {"limit": null, "parent_id": null},
          query: GraphQLQueries.mainCategoriesQuery);
      if (response != null) {
        List temp = response['data']['listCategory'] ?? [];

        if (temp.isNotEmpty) {
          mainCategories =
              List.from(temp.map((e) => CategoryDataModel.fromJson(e, true)));
        }
        _mainCategoryApiResponse = ApiResponse.completed(response);
      } else {
        _mainCategoryApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _mainCategoryApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future createAd(Map<String, dynamic> input, List<File> productImages,
      List<File> buyingReceipts) async {
    try {
      _createAdApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await productRepo.createAdRepo(
          input: input,
          query: GraphQLQueries.createAdQuery,
          productImageFile: productImages,
          buyingReceipts: buyingReceipts);
      if (response != null) {
        Helper.showMessage(response['data']['createAd']['message'] ?? "");
        AppRouter.pushAndRemoveUntil(const ProductAdLiveNowView());
        if (response['data']['createAd']['data'] != null) {
          adReview = ProductDetailDataModel.fromJson(
              response['data']['createAd']['data'], false);
        }

        _createAdApiResponse = ApiResponse.completed(response);
      } else {
        _createAdApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _createAdApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future updateAd(Map<String, dynamic> input, List<File>? productImages,
      List<File>? buyingReceipts, int index) async {
    try {
      _createAdApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await productRepo.updateAdRepo(
          input: input,
          query: GraphQLQueries.updateAdQuery,
          productImageFile: productImages,
          buyingReceipts: buyingReceipts);
      if (response != null) {
        if (response['data']['updateAd']['data'] != null) {
          final data = ProductDetailDataModel.fromJson(
              response['data']['updateAd']['data'], false);
          if (myAdProducts.isNotEmpty) {
            myAdProducts[index] = data;
          }
        }
        Helper.showMessage(response['data']['updateAd']['message'] ?? "");
        AppRouter.back();

        _createAdApiResponse = ApiResponse.completed(response);
      } else {
        _createAdApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _createAdApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future deleteAd({required int id, required int? index}) async {
    try {
      _deleteAdApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await productRepo.customRepo(
          input: {"deleteAdId": id}, query: GraphQLQueries.deleteAdQuery);
      if (response != null) {
        Helper.showMessage(response['data']['deleteAd']['message'] ?? "");
        if (index != null) {
          if (myAdProducts.isNotEmpty) {
            myAdProducts.removeAt(index);
          }
          AppRouter.back();

          if (minLength > 0) {
            if (adProuctCursor != null) {
              getMyAdProducts(
                  limit: 5, cursor: adProuctCursor, myStatus: status);
            }
          }
        } else {
          AppRouter.pushAndRemoveUntil(const NavigationView());
        }

        _deleteAdApiResponse = ApiResponse.completed(response);
      } else {
        _deleteAdApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _deleteAdApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future deleteNotifyAd({required int id, required int? index}) async {
    try {
      _deleteAdApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await productRepo.customRepo(
          input: {"deleteAdNotifyId": id},
          query: GraphQLQueries.deleteNotifyQuery);
      if (response != null) {
        Helper.showMessage(response['data']['deleteAdNotify']['message'] ?? "");
        if (index != null) {
          if (myNotfiyList.isNotEmpty) {
            myNotfiyList.removeAt(index);
          }
          AppRouter.back();

          if (minLength > 0) {
            if (adProuctCursor != null) {
              getNotifyCategoryList(limit: 5, cursor: notifyListCursor);
            }
          }
        } else {
          AppRouter.pushAndRemoveUntil(const NavigationView());
        }

        _deleteAdApiResponse = ApiResponse.completed(response);
      } else {
        _deleteAdApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _deleteAdApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future getHomeProducts(
      {required int limit, required double lat, required double long}) async {
    try {
      _homeProductsApiResponse = ApiResponse.loading();
      if (preOwnedProducts.isNotEmpty) {
        preOwnedProducts.clear();
      }
      if (dealProducts.isNotEmpty) {
        dealProducts.clear();
      }
      if (discountedProducts.isNotEmpty) {
        discountedProducts.clear();
      }
      if (storeProducts.isNotEmpty) {
        storeProducts.clear();
      }
      notifyListeners();
      final response = await productRepo.sendRequest(
          input: {"lat": lat, "limit": limit, "lon": long},
          query: GraphQLQueries.homeProductsQuery);
      if (response != null) {
        final data = response['data']['getAdStoreItems'];
        List temp = data['pre_owned'] ?? [];
        if (temp.isNotEmpty) {
          preOwnedProducts =
              List.from(temp.map((e) => ProductDataModel.fromJson(e, false)));
        }
        List temp2 = data['dis_pre_owned'] ?? [];
        if (temp2.isNotEmpty) {
          discountedProducts =
              List.from(temp2.map((e) => ProductDataModel.fromJson(e, false)));
        }
        List temp3 = data['vanish_deals'] ?? [];
        if (temp3.isNotEmpty) {
          dealProducts =
              List.from(temp3.map((e) => ProductDataModel.fromJson(e, false)));
        }
        List temp4 = data['store'] ?? [];
        if (temp4.isNotEmpty) {
          storeProducts =
              List.from(temp4.map((e) => ProductDataModel.fromJson(e, true)));
        }
        _homeProductsApiResponse = ApiResponse.completed(response);
      } else {
        _homeProductsApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _homeProductsApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future getSimilarProducts(
      {required int limit,
      required double lat,
      required double long,
      required int id,
      required int adId}) async {
    try {
      // lastId = id;
      _similarProductsApiResponse = ApiResponse.loading();
      if (similarProducts.isNotEmpty) {
        similarProducts.clear();
      }
      notifyListeners();
      final response = await productRepo.sendRequest(input: {
        "lat": lat,
        "limit": limit,
        "lon": long,
        "category_id": id,
        "ads_id": adId
      }, query: GraphQLQueries.similarProductsQuery);
      if (response != null) {
        List temp = response['data']['getSimilarAd'] ?? [];
        if (temp.isNotEmpty) {
          similarProducts =
              List.from(temp.map((e) => ProductDataModel.fromJson(e, false)));
        }

        _similarProductsApiResponse = ApiResponse.completed(response);
      } else {
        _similarProductsApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _similarProductsApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future getSimilarVenderProducts(
      {required int limit,
      required double lat,
      required double long,
      required int id,
      required int productId}) async {
    try {
      // lastId = id;
      _similarProductsApiResponse = ApiResponse.loading();
      if (similarProducts.isNotEmpty) {
        similarProducts.clear();
      }
      notifyListeners();
      final response = await productRepo.sendRequest(input: {
        "category_id": id,
        "lat": lat,
        "limit": limit,
        "lon": long,
        "product_id": productId
      }, query: GraphQLQueries.getSimilarVenderProductQuery);
      if (response != null) {
        List temp = response['data']['getSimilarProduct'] ?? [];
        if (temp.isNotEmpty) {
          similarProducts =
              List.from(temp.map((e) => ProductDataModel.fromJson(e, true)));
        }

        _similarProductsApiResponse = ApiResponse.completed(response);
      } else {
        _similarProductsApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _similarProductsApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future getMyAdProducts(
      {required int limit,
      required String? cursor,
      required String myStatus}) async {
    status = myStatus;
    try {
      if (cursor == null) {
        _myAdApiResponse = ApiResponse.loading();
        adProuctCursor = null;
        myAdProducts.clear();
      } else {
        _myAdApiResponse = ApiResponse.loadingMore();
      }

      notifyListeners();
      final response = await productRepo.sendRequest(
          input: {"limit": limit, "cursor": cursor, "status": status},
          query: GraphQLQueries.allADQuery);
      if (response != null) {
        List temp = response['data']['allAd']['data'] ?? [];
        adProuctCursor = response['data']['allAd']['nextCursor'];
        if (temp.isNotEmpty) {
          if (cursor == null) {
            myAdProducts = List.from(
                temp.map((e) => ProductDetailDataModel.fromJson(e, false)));
          } else {
            myAdProducts.addAll(
                temp.map((e) => ProductDetailDataModel.fromJson(e, false)));
          }
        }
        minLength = (myAdProducts.length * 0.65).toInt();

        _myAdApiResponse = ApiResponse.completed(response);
      } else {
        _myAdApiResponse =
            cursor == null ? ApiResponse.error() : ApiResponse.undertermined();
      }
      notifyListeners();
    } catch (e) {
      _myAdApiResponse =
          cursor == null ? ApiResponse.error() : ApiResponse.undertermined();
      notifyListeners();
    }
  }

  Future getProductDetails({required int id}) async {
    try {
      _productDetailApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await productRepo.customRepo(
          input: {"getAdDetailId": id},
          query: GraphQLQueries.productDetailsQuery);
      if (response != null) {
        final data = response['data']['getAdDetail'];
        if (data != null) {
          _productDetailApiResponse = ApiResponse.completed(
              ProductDetailDataModel.fromJson(data, false));
          isFavourite = _productDetailApiResponse.data!.isFavourite!;
        } else {
          _productDetailApiResponse = ApiResponse.error();
        }
      } else {
        _productDetailApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _productDetailApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future getStoreProductDetails({required int id}) async {
    try {
      _getStoreProductDetailApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await productRepo.customRepo(
          input: {"productDetailId": id},
          query: GraphQLQueries.getStoreProductDetailQuery);
      if (response != null) {
        final data = response['data']['productDetail'];
        if (data != null) {
          _getStoreProductDetailApiResponse =
              ApiResponse.completed(StoreProductDetailDataModel.fromJson(data));
        } else {
          _getStoreProductDetailApiResponse = ApiResponse.error();
        }
      } else {
        _getStoreProductDetailApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _getStoreProductDetailApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future notifyCategorySet(
      {required List<int> categoriesId,
      required double radius,
      required LocationData location}) async {
    try {
      _notifyApiResponse = ApiResponse.loading();
      notifyListeners();
      Map<String, dynamic> data = location.toJson();
      data["categories_id"] = categoriesId;
      data["radius"] = radius;

      final response = await productRepo.sendRequest(
          input: data, query: GraphQLQueries.notifyCategoryQuery);
      if (response != null) {
        _notifyApiResponse = ApiResponse.completed(response);
        Helper.showMessage(response['data']['createAdNotify']['message'] ?? "");
        selectItemsId.clear();
        AppRouter.push(const SetNotificationView());
      } else {
        Helper.showMessage("Something went wrong!");
        _notifyApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      Helper.showMessage("Something went wrong!");
      _notifyApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future updateNotifyCategorySet(
      {required List<int> categoriesId,
      required double radius,
      required LocationData location}) async {
    try {
      _notifyApiResponse = ApiResponse.loading();
      notifyListeners();
      Map<String, dynamic> data = location.toJson();
      data["categories_id"] = categoriesId;
      data["radius"] = radius;
      data["id"] = notifyId;

      final response = await productRepo.sendRequest(
          input: data, query: GraphQLQueries.updateNotifyQuery);
      if (response != null) {
        _notifyApiResponse = ApiResponse.completed(response);
        Helper.showMessage(response['data']['updateAdNotify']['message'] ?? "");
        selectItemsId.clear();
        AppRouter.customback(times: selectedCategoryPageCount + 2);
      } else {
        Helper.showMessage("Something went wrong!");
        _notifyApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      Helper.showMessage("Something went wrong!");
      _notifyApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future getNotifyCategoryList(
      {required int limit, required String? cursor}) async {
    notifyId = null;
    try {
      _notifyListApiResponse =
          cursor == null ? ApiResponse.loading() : ApiResponse.loadingMore();
      if (myNotfiyList.isNotEmpty && cursor == null) {
        notifyListCursor = null;
        myNotfiyList.clear();
      }
      notifyListeners();
      final response = await productRepo.sendRequest(
          input: {"limit": limit, "cursor": cursor},
          query: GraphQLQueries.getNotifyCategoryQuery);
      if (response != null) {
        List temp = response['data']['allAdNotify']['data'];
        notifyListCursor = response['data']['allAdNotify']['nextCursor'];
        if (temp.isNotEmpty) {
          if (cursor == null) {
            myNotfiyList = List.from(temp.map((e) => AdDataModel.fromJson(e)));
          } else {
            myNotfiyList.addAll(temp.map((e) => AdDataModel.fromJson(e)));
          }
        }

        _notifyListApiResponse = ApiResponse.completed(response);
        notifyListeners();
      } else {
        _notifyListApiResponse =
            cursor == null ? ApiResponse.error() : ApiResponse.undertermined();
      }
      // minLength = (myNotfiyList.length * 0.65).toInt();
      notifyListeners();
    } catch (e) {
      _notifyListApiResponse =
          cursor == null ? ApiResponse.error() : ApiResponse.undertermined();
      notifyListeners();
    }
  }

  Future getFavouriteProductList(
      {required int limit, required String? cursor}) async {
    try {
      _favouriteProductApiResponse =
          cursor == null ? ApiResponse.loading() : ApiResponse.loadingMore();
      if (favouriteProducts.isNotEmpty && cursor == null) {
        favouriteListCursor = null;
        favouriteProducts.clear();
      }
      notifyListeners();
      final response = await productRepo.sendRequest(
          input: {"limit": limit, "cursor": cursor},
          query: GraphQLQueries.getfavouriteListQuery);
      if (response != null) {
        List temp = response['data']['getAllWishlists']['data'];
        favouriteListCursor = response['data']['getAllWishlists']['nextCursor'];
        if (temp.isNotEmpty) {
          if (cursor == null) {
            favouriteProducts = List.from(
                temp.map((e) => ProductDataModel.fromJson(e['ad'], false)));
          } else {
            favouriteProducts.addAll(
                temp.map((e) => ProductDataModel.fromJson(e['ad'], false)));
          }
        }

        _favouriteProductApiResponse = ApiResponse.completed(response);
        notifyListeners();
      } else {
        _favouriteProductApiResponse =
            cursor == null ? ApiResponse.error() : ApiResponse.undertermined();
      }
      minLength = (favouriteProducts.length * 0.65).toInt();
      notifyListeners();
    } catch (e) {
      _favouriteProductApiResponse =
          cursor == null ? ApiResponse.error() : ApiResponse.undertermined();
      notifyListeners();
    }
  }

  Future getMarketPlaceProducts(
      {required int limit, required double lat, required double long}) async {
    try {
      _marketPlaceProductsApiResponse = ApiResponse.loading();

      notifyListeners();
      final response = await productRepo.sendRequest(input: {
        "lat": lat,
        "limit": limit,
        "lon": long,
      }, query: GraphQLQueries.marketProductQuery);
      if (response != null) {
        final data = response['data']['getMarketPlaceItems'];
        final model = MarketPlaceDataModel.fromJson(data, false);
        _marketPlaceProductsApiResponse = ApiResponse.completed(model);
      } else {
        _marketPlaceProductsApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _marketPlaceProductsApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future getVenderProducts(
      {required int limit, required double lat, required double long}) async {
    try {
      _venderProductsApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await productRepo.sendRequest(input: {
        "lat": lat,
        "limit": limit,
        "lon": long,
      }, query: GraphQLQueries.getVenderProductsQuery);
      if (response != null) {
        final data = response['data']['getStoreItems'];
        final model = MarketPlaceDataModel.fromJson(data, true);
        _venderProductsApiResponse = ApiResponse.completed(model);
      } else {
        _venderProductsApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _venderProductsApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future getTopStore({required int limit}) async {
    try {
      _getTopStoresApiResponse = ApiResponse.loading();

      notifyListeners();
      final response = await productRepo.sendRequest(
          input: {"limit": limit}, query: GraphQLQueries.getTopStoreQuery);
      if (response != null) {
        final data = response['data']['topStores'];
        final List temp = data['store'];

        topStores = List.from(temp.map((e) => TopVenderDataModel.fromJson(e)));
        _getTopStoresApiResponse = ApiResponse.completed(data);
      } else {
        _getTopStoresApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _getTopStoresApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future checkFavourite(bool chk, int id, int? index) async {
    isFavourite = !chk;
    if (favouriteProducts.isNotEmpty && index != null) {
      favouriteProducts.removeAt(index);
      if (favouriteProducts.length < minLength) {
        getFavouriteProductList(limit: 5, cursor: favouriteListCursor);
      }
    }
    notifyListeners();
    try {
      final result = await productRepo.customRepo(
          input: {"adsId": id},
          query: chk
              ? GraphQLQueries.removeFavouriteQuery
              : GraphQLQueries.checkFavouriteQuery);
      if (result != null) {}
    } catch (e) {
      throw Exception(e);
    }
  }

  Future getCheckOutList() async {
    try {
      _checkoutApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await productRepo.sendRequest(
          input: {"limit": 5, "cursor": null},
          query: GraphQLQueries.getCheckOutListQuery);
      if (response != null) {
        List temp = response['data']['getAdStoreItems']['pre_owned'] ?? [];
        if (temp.isNotEmpty) {
          checkOutList =
              List.from(temp.map((e) => ProductDataModel.fromJson(e, false)));
        }
        _checkoutApiResponse = ApiResponse.completed(response);
      } else {
        _checkoutApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _checkoutApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future getSeeAllAds(
      {required int limit,
      required double lat,
      required double long,
      required String? cursor,
      required int? categoryId,
      required String? searchText,
      required bool? under10,
      required bool? vanish,
      required String type}) async {
    try {
      _seeAllAdsApiResponse =
          cursor == null ? ApiResponse.loading() : ApiResponse.loadingMore();
      if (cursor == null) {
        seeAllAdCursor = null;
        if (seeAllProducts.isNotEmpty) {
          seeAllProducts.clear();
        }
      }
      notifyListeners();
      final response = await productRepo.sendRequest(input: {
        "category_id": categoryId,
        "cursor": cursor,
        "lat": lat,
        "limit": limit,
        "lon": long,
        "title": searchText,
        "type": type,
        "under10": under10,
        "vanish": vanish
      }, query: GraphQLQueries.seeAllAdQuery);
      if (response != null) {
        _seeAllAdsApiResponse = ApiResponse.completed(response);
        List temp = response['data']['allProducts']['data'];
        seeAllAdCursor = response['data']['allProducts']['nextCursor'];

        if (cursor == null) {
          seeAllProducts = List.from(
              temp.map((e) => ProductDataModel.fromJson(e, type == "Store")));
        } else {
          seeAllProducts.addAll(List.from(
              temp.map((e) => ProductDataModel.fromJson(e, type == "Store"))));
        }
        notifyListeners();
      } else {
        _seeAllAdsApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _seeAllAdsApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future addToCard(
      {required ProductDataModel product,
      required int quantity,
      required int index,
      required List<ProductDataModel> list,
      required String categoryKey}) async {
    try {
      _addToCartApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await productRepo.sendRequest(
          input: {"product_id": product.id!, "quantity": quantity},
          query: GraphQLQueries.addCardQuery);
      if (response != null &&
          response['data']['addToCart']['statusCode'] == 201) {
        final int qty = product.quantity!;
        if (index > -1) {
          if (qty > 0) {
            list[index].quantity = qty - quantity;
          }

          if (quantity == qty) {
            list.removeAt(index);
          }
          if (categoryKey != "") {
            venderProductsApiResponse.data?.mapData
                ?.update(categoryKey, (_) => list);
          }
        }
        _addToCartApiResponse = ApiResponse.completed(response);
        notifyListeners();
        getCartsItem();

        final msg = response['data']['addToCart']['message'];
        Helper.showMessage(msg);
        AppRouter.back();
      }
    } catch (e) {
      _addToCartApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future getCartsItem() async {
    try {
      _getCartItemsApiResponse = ApiResponse.loading();
      if (checkOutList.isNotEmpty) {
        checkOutList.clear();
      }
      if (orders.isNotEmpty) {
        orders.clear();
      }

      notifyListeners();
      final response = await productRepo.sendRequest(
          input: {"title": null}, query: GraphQLQueries.getCheckOutListQuery);
      if (response != null) {
        List temp = response['data']['getAllCartItems'];
        checkOutList.clear();
        checkOutList =
            List.from(temp.map((e) => CheckoutListItemModel.from(e)));

        _getCartItemsApiResponse = ApiResponse.completed(response);
      } else {
        _getCartItemsApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _getCartItemsApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future removeCardItem({required List<int> id}) async {
    try {
      _deleteItemsApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await productRepo.customRepo(
          input: {"removeCartItemId": id},
          query: GraphQLQueries.deleteCartQuery);
      if (response != null) {
        _deleteItemsApiResponse = ApiResponse.completed(response);
        notifyListeners();
        AppRouter.back();

        getCartsItem();
        final data = response['data']['removeCartItem'];
        Helper.showMessage(data['message']);
      } else {
        _deleteItemsApiResponse = ApiResponse.error();
        notifyListeners();
      }
    } catch (e) {
      _deleteItemsApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future clearCart() async {
    try {
      _clearCartItemsApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await productRepo
          .customRepo(input: {}, query: GraphQLQueries.clearCart);
      if (response != null) {
        _clearCartItemsApiResponse = ApiResponse.completed(response);

        clearCheckOutList();
        Helper.showMessage(response['data']['clearCart']['message']);
        AppRouter.back();
      } else {
        _clearCartItemsApiResponse = ApiResponse.loading();
        notifyListeners();
      }
    } catch (e) {
      _clearCartItemsApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future checkOut(
      {required String paymentMethodId,
      required Map<String, dynamic> shippingAddress,
      required List<Map<String, dynamic>> storesOrders,
      required Map<String, dynamic> contactInfo,
      required bool saveCard,
      required num productAmount,
      required num deliveryChargers}) async {
    try {
      _orderCheckOutApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await productRepo.sendRequest(input: {
        "payment_method_id": paymentMethodId,
        "save_card": saveCard,
        "shipping_address": shippingAddress,
        "contact_information": contactInfo,
        "store_orders": storesOrders
      }, query: GraphQLQueries.checkOutQuery);
      if (response != null) {
        AppRouter.customback(times: 2);
        AppRouter.push(OrderConfirmationView(
          product: null,
          isVender: true,
          productAmounts: productAmount,
          totalAmount: productAmount + deliveryChargers,
          deliveryCharger: deliveryChargers,
        ));
        _orderCheckOutApiResponse = ApiResponse.completed(response);
      } else {
        _orderCheckOutApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _orderCheckOutApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future buyNow(
      {required String paymentMethodId,
      required Map<String, dynamic> shippingAddress,
      required Map<String, dynamic> contactInfo,
      required int productId,
      required bool saveCard,
      required num productAmount,
      required int quantity,
      required num deliveryChargers}) async {
    try {
      _buyNowApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await productRepo.sendRequest(input: {
        "payment_method_id": paymentMethodId,
        "save_card": saveCard,
        "shipping_address": shippingAddress,
        "product_id": productId,
        "contact_information": contactInfo,
        "quantity": quantity,
      }, query: GraphQLQueries.buyNowQuery);
      if (response != null) {
        AppRouter.customback(times: 2);
        AppRouter.push(OrderConfirmationView(
          product: null,
          isVender: true,
          productAmounts: productAmount,
          totalAmount: productAmount + deliveryChargers,
          deliveryCharger: deliveryChargers,
        ));
        _buyNowApiResponse = ApiResponse.completed(response);
      } else {
        _buyNowApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _buyNowApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future getStoreOrder(
      {required String? cursor,
      required int limit,
      required String? status}) async {
    try {
      if (cursor != null) {
        _orderApiResponse = ApiResponse.loadingMore();
      } else {
        if (orderHistory.isNotEmpty) {
          orderHistory.clear();
        }
        _orderApiResponse = ApiResponse.loading();
        orderHistoryCursor = null;
      }
      notifyListeners();
      final response = await productRepo.sendRequest(
          input: {"cursor": cursor, "limit": limit, "status": status},
          query: GraphQLQueries.storeOrderHistoryQuery);
      if (response != null) {
        final data = response['data']['allOrders'];
        List temp = data['data'];
        orderHistoryCursor = data['nextCursor'];
        if (temp.isNotEmpty) {
          if (cursor != null) {
            orderHistory =
                List.from(temp.map((e) => OrderDataModel.fromJson(e)));
          } else {
            orderHistory
                .addAll(List.from(temp.map((e) => OrderDataModel.fromJson(e))));
          }
        }
        _orderApiResponse = cursor == null
            ? ApiResponse.completed(data)
            : ApiResponse.undertermined();
      } else {
        _orderApiResponse =
            cursor == null ? ApiResponse.error() : ApiResponse.undertermined();
      }
      notifyListeners();
    } catch (e) {
      _orderApiResponse =
          cursor == null ? ApiResponse.error() : ApiResponse.undertermined();
      notifyListeners();
    }
  }

  Future getAdOrder(
      {required String? cursor,
      required int limit,
      required String? status}) async {
    try {
      if (cursor != null) {
        _orderAdApiResponse = ApiResponse.loadingMore();
      } else {
        if (adOrderHistory.isNotEmpty) {
          adOrderHistory.clear();
        }
        _orderAdApiResponse = ApiResponse.loading();
        orderAdHistoryCursor = null;
      }
      notifyListeners();
      final response = await productRepo.sendRequest(
          input: {"cursor": cursor, "limit": limit, "status": status},
          query: GraphQLQueries.adOrderQuery);
      if (response != null) {
        final data = response['data']['allAdsOrder'];
        List temp = data['data'];
        orderAdHistoryCursor = data['nextCursor'];
        if (temp.isNotEmpty) {
          if (cursor != null) {
            adOrderHistory =
                List.from(temp.map((e) => AdOrderDataModel.fromJson(e)));
          } else {
            adOrderHistory.addAll(
                List.from(temp.map((e) => AdOrderDataModel.fromJson(e))));
          }
        }
        _orderAdApiResponse = cursor == null
            ? ApiResponse.completed(data)
            : ApiResponse.undertermined();
      } else {
        _orderAdApiResponse =
            cursor == null ? ApiResponse.error() : ApiResponse.undertermined();
      }
      notifyListeners();
    } catch (e) {
      _orderAdApiResponse =
          cursor == null ? ApiResponse.error() : ApiResponse.undertermined();
      notifyListeners();
    }
  }

  Future adBuyNow(
      {required String paymentMethodId,
      required ProductDetailDataModel product,
      required Map<String, dynamic> contactInfo,
      required int adId,
      required bool saveCard,
      required num amount}) async {
    _adBuyNowApiResponse = ApiResponse.loading();
    notifyListeners();
    try {
      final response = await productRepo.sendRequest(input: {
        "ads_id": adId,
        "payment_method_id": paymentMethodId,
        "save_card": saveCard,
        "contact_information": contactInfo,
      }, query: GraphQLQueries.adBuyNowQuery);
      if (response != null) {
        AppRouter.customback(times: 2);
        AppRouter.push(OrderConfirmationView(
          product: product,
          isVender: false,
          productAmounts: amount,
          totalAmount: amount + product.applicationFee!,
          deliveryCharger: product.applicationFee ?? 0.0,
        ));
        _adBuyNowApiResponse = ApiResponse.completed(response);
      } else {
        _adBuyNowApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _adBuyNowApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future getProductReview(
      {required Map<String, dynamic> input, required String? cursor}) async {
    input['cursor'] = cursor;
    try {
      if (cursor == null) {
        _productReviewApiResponse = ApiResponse.loading();
        reviewCursor = null;
        productReviews.clear();
      } else {
        _productReviewApiResponse = ApiResponse.loadingMore();
      }

      notifyListeners();
      final response = await productRepo.sendRequest(
          input: input, query: GraphQLQueries.getProductReviewQuery);
      if (response != null) {
        final data = response['data']['getProductReviews'];
        reviewCursor = data['nextCursor'];
        List temp = data['data'];
        if (temp.isNotEmpty) {
          if (cursor == null) {
            productReviews =
                List.from(temp.map((e) => ProductReviewsDataModel.fromJson(e)));
          } else {
            productReviews.addAll(List.from(
                temp.map((e) => ProductReviewsDataModel.fromJson(e))));
          }
        }
        _productReviewApiResponse = ApiResponse.completed(response);
      } else {
        _productReviewApiResponse =
            cursor == null ? ApiResponse.error() : ApiResponse.undertermined();
      }
      notifyListeners();
    } catch (e) {
      _productReviewApiResponse =
          cursor == null ? ApiResponse.error() : ApiResponse.undertermined();
      notifyListeners();
    }
  }

  Future createProductReview(
      {required int productId,
      required String review,
      required int storeOrderId,
      required List<File>? images,
      required double rating}) async {
    try {
      notifyListeners();
      final response = await productRepo.createProductReviewRepo(
          input: {
            // "images": images != null ? List.filled(images.length, null) : null,
            "product_id": productId,
            "rating": rating,
            "review": review,
            "store_order_id": storeOrderId
          },
          query: GraphQLQueries.createProductReviewQuery,
          images: images,
          imageString: 'images');
      if (response != null) {
        _createProductReviewApiResponse = ApiResponse.completed(response);
        Helper.showMessage(
            response['data']['createProductReview']['message'] ?? "");
        AppRouter.back();
        getProductReview(
            input: {"filter": "to_review", "limit": 10}, cursor: null);
      } else {
        _createProductReviewApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _createProductReviewApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future updateProductReview({
    required int id,
    required int productId,
    required String review,
    required List<File>? images,
    required List<String>? oldImages,
  }) async {
    try {
      notifyListeners();
      final response = await productRepo.createProductReviewRepo(
          input: {
            "id": id,
            "images": oldImages,
            // "new_images":images != null ? List.filled(images.length, null) : null,
            "review": review
          },
          query: GraphQLQueries.updateProductReviewQuery,
          images: images,
          imageString: 'new_images');
      if (response != null) {
        _createProductReviewApiResponse = ApiResponse.completed(response);
        Helper.showMessage(
            response['data']['updateProductReview']['message'] ?? "");
        AppRouter.back();
        getProductReview(
            input: {"filter": "my_review", "limit": 10}, cursor: null);
      } else {
        _createProductReviewApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _createProductReviewApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future cancelOrder({required int storeId, required String reason, required String status}) async {
    try {
      _createProductReviewApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await productRepo.sendRequest(
          input: {"id": storeId, "reason": reason},
          query: GraphQLQueries.cancelOrderQuery);
      if (response != null) {
        _createProductReviewApiResponse = ApiResponse.completed(response);
        AppRouter.back();
        Helper.showMessage(response['data']['cancelOrder']['message'] ?? "");
        getStoreOrder(cursor: null, limit: 10, status: status);
      } else {
        _createProductReviewApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _createProductReviewApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future refundRequest(
      {required int orderItemId,
      required String? reason,
      required List<File> images,
      required String reasonCode,
      required String status
      }) async {
    try {
      _createProductReviewApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await productRepo.createRefundRepo(input: {
        "order_item_id": orderItemId,
        "reason": reason,
        // "images": List.filled(images.length, null),
        "reason_code": reasonCode
      }, images: images, query: GraphQLQueries.createRefundQuery);
      if (response != null) {
        _createProductReviewApiResponse = ApiResponse.completed(response);
         AppRouter.back();
        Helper.showMessage(response['data']['createRefundRequest']['message'] ?? "");
        getStoreOrder(cursor: null, limit: 10, status: status);
      } else {
        _createProductReviewApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _createProductReviewApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future getRefundRequest({required int limit, required String? cursor})async{
    try {
      if(cursor == null) {
        _getRefundRequestApiResponse = ApiResponse.loading();
        refundRequestList.clear();
        refundRequestCursor = null;
      } else {
        _getRefundRequestApiResponse = ApiResponse.loadingMore();
      }
      notifyListeners();
      final response = await productRepo.sendRequest(
          input: {"limit": limit, "cursor": cursor},
          query: GraphQLQueries.getRefundRequestQuery);
    if(response != null){
      final data = response['data']['allRefundRequests'];
      refundRequestCursor = data['nextCursor'];
      List temp = data['data'];
      if(temp.isNotEmpty){
        if(cursor == null){
          refundRequestList = List.from(temp.map((e) => RefundRequestDataModel.fromJson(e)));
        } else {
          refundRequestList.addAll(temp.map((e) => RefundRequestDataModel.fromJson(e)));
        }
        _getRefundRequestApiResponse = ApiResponse.completed(response);
      } }
      else {
        _getRefundRequestApiResponse = ApiResponse.error();

  
    
      }
       notifyListeners();
    } catch (e) {
      _getRefundRequestApiResponse = ApiResponse.error();
      notifyListeners();
    }
      
      
    
  }

  void checkList(int index) {
    if (selectItemsId.contains(index)) {
      selectItemsId.remove(index);
    } else {
      selectItemsId.add(index);
    }

    // final CategoryDataModel category = fruits[index];

    // fruits[index] = CategoryDataModel(
    //     id: category.id,
    //     title: category.title,
    //     imageUrl: category.imageUrl,
    //     isSelected: !category.isSelected);
    notifyListeners();
  }

  void clearCheckOutList() {
    checkOutList.clear();
    notifyListeners();
  }

  void removeItem(index) {
    if (!(index < 0) && checkOutList.isNotEmpty) {
      checkOutList.removeAt(index);
      notifyListeners();
    }
  }

  void toggleCheckCart(int index) {
    checkOutList[index].isSelect = !checkOutList[index].isSelect;
    notifyListeners();
  }

  void checkAllCarts(bool check) {
    for (var item in checkOutList) {
      item.isSelect = check;
    }
    notifyListeners();
  }

  void setApiResponse() {
    _homeProductsApiResponse = ApiResponse.undertermined();
    _categoryApiResponse = ApiResponse.undertermined();
    _createAdApiResponse = ApiResponse.undertermined();
    _mainCategoryApiResponse = ApiResponse.undertermined();
    _deleteAdApiResponse = ApiResponse.undertermined();
    _homeProductsApiResponse = ApiResponse.undertermined();
    _similarProductsApiResponse = ApiResponse.undertermined();
    _myAdApiResponse = ApiResponse.undertermined();
    _productDetailApiResponse = ApiResponse.undertermined();
    _notifyApiResponse = ApiResponse.undertermined();
    _notifyListApiResponse = ApiResponse.undertermined();
    _seeAllAdsApiResponse = ApiResponse.undertermined();
    _marketPlaceProductsApiResponse = ApiResponse.undertermined();
    _addToCartApiResponse = ApiResponse.undertermined();
    _getCartItemsApiResponse = ApiResponse.undertermined();
    _venderProductsApiResponse = ApiResponse.undertermined();
    _getTopStoresApiResponse = ApiResponse.undertermined();
    _getStoreProductDetailApiResponse = ApiResponse.undertermined();
    _orderCheckOutApiResponse = ApiResponse.undertermined();
    _buyNowApiResponse = ApiResponse.undertermined();
    _orderApiResponse = ApiResponse.undertermined();
    _adBuyNowApiResponse = ApiResponse.undertermined();
    _orderAdApiResponse = ApiResponse.undertermined();
    _productReviewApiResponse = ApiResponse.undertermined();
    _createProductReviewApiResponse = ApiResponse.undertermined();
    _getRefundRequestApiResponse = ApiResponse.undertermined();

    notifyListeners();
  }

  void setAddCardResponse() {
    _deleteItemsApiResponse = ApiResponse.undertermined();
    notifyListeners();
  }

  void setSeeAllProductResponse() {
    _seeAllAdsApiResponse = ApiResponse.undertermined();
    notifyListeners();
  }

  void unsetCategory() {
    selectedCategory = null;
    lastSelectedCategory = null;
    selectedCategoryPageCount = 0;
    _seeAllAdsApiResponse = ApiResponse.undertermined();
    notifyListeners();
  }

  void setCategory(CategoryDataModel category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setLastCategory(CategoryDataModel category) {
    lastSelectedCategory = category;
    notifyListeners();
  }

  void setNotfiyId(int id) {
    notifyId = id;
  }

  void addQuantity(int index) {
    checkOutList[index].quantity += 1;
    productRepo.sendRequest(
        input: {"product_id": checkOutList[index].product.id!, "quantity": 1},
        query: GraphQLQueries.addCardQuery);
    notifyListeners();
  }

  void removeQuantity(int index) {
    checkOutList[index].quantity -= 1;
    productRepo.sendRequest(
        input: {"product_id": checkOutList[index].product.id!, "quantity": -1},
        query: GraphQLQueries.addCardQuery);
    notifyListeners();
  }

  void setOrderList(List<StoreOrderDataModel> selectOrderList) {
    orders = List.from(selectOrderList);
    notifyListeners();
  }

  void selectDeliveryOption(int cardIndex, String type) {
    orders[cardIndex].shippingType = type;
    notifyListeners();
  }

  void selectDeliveryLocation(double lat, double lon) async {
    final LocationData? place = await mapRepo.getLocationDetail(lat, lon);
    final LocationData? loc = await mapRepo.getAdditionalLocationDetail(place!);
    deliveryLocation = loc;
    notifyListeners();
  }

  void unSetLocation() {
    deliveryLocation = null;
    notifyListeners();
  }

  void onDispose() {
    allCategories = [];
    brandList = [];

  
    checkOutList = [];
    selectItemsId = [];
    preOwnedProducts = [];
    similarProducts = [];
    seeAllProducts = [];
    searchProducts = [];

    discountedProducts = [];
    storeProducts = [];
    dealProducts = [];
    favouriteProducts = [];
    topStores = [];
    orderHistory = [];
    adOrderHistory = [];

    myAdProducts = [];
    myNotfiyList = [];

    orders = [];
    productReviews = [];
    refundRequestList = [];
    setApiResponse();
  }

  ApiResponse get categoryApiResponse => _categoryApiResponse;
  ApiResponse get mainCategoryApiResponse => _mainCategoryApiResponse;
  ApiResponse get createAdApiResponse => _createAdApiResponse;
  ApiResponse get deleteAdApiResponse => _deleteAdApiResponse;
  ApiResponse get homeProductsApiResponse => _homeProductsApiResponse;
  ApiResponse<MarketPlaceDataModel?> get marketPlaceProductsApiResponse =>
      _marketPlaceProductsApiResponse;
  ApiResponse<MarketPlaceDataModel?> get venderProductsApiResponse =>
      _venderProductsApiResponse;

  ApiResponse get similarProductsApiResponse => _similarProductsApiResponse;
  ApiResponse get adApiResponse => _myAdApiResponse;
  ApiResponse get productDetailApiResponse => _productDetailApiResponse;
  ApiResponse get notifyApiResponse => _notifyApiResponse;
  ApiResponse get notifyListApiResponse => _notifyListApiResponse;
  ApiResponse get seeAllAdsApiResponse => _seeAllAdsApiResponse;
  ApiResponse get favouriteProductApiResponse => _favouriteProductApiResponse;
  ApiResponse get checkoutApiResponse => _checkoutApiResponse;
  ApiResponse get addToCartApiResponse => _addToCartApiResponse;
  ApiResponse get getCartItemsApiResponse => _getCartItemsApiResponse;
  ApiResponse get clearCartItemsApiResponse => _clearCartItemsApiResponse;
  ApiResponse get deleteItemsApiResponse => _deleteItemsApiResponse;
  ApiResponse get getTopStoresApiResponse => _getTopStoresApiResponse;
  ApiResponse get orderCheckOutApiResponse => _orderCheckOutApiResponse;
  ApiResponse get buyNowApiResponse => _buyNowApiResponse;
  ApiResponse get adBuyNowApiResponse => _adBuyNowApiResponse;
  ApiResponse get getStoreProductDetailApiResponse =>
      _getStoreProductDetailApiResponse;
  ApiResponse get orderApiResponse => _orderApiResponse;
  ApiResponse get orderAdApiResponse => _orderAdApiResponse;
  ApiResponse get productReviewApiResponse => _productReviewApiResponse;
  ApiResponse get createProductReviewApiResponse =>
      _createProductReviewApiResponse;
  ApiResponse get getRefundRequestApiResponse =>
      _getRefundRequestApiResponse;
}

final productDataProvider = ChangeNotifierProvider.autoDispose<ProductProvider>(
  (ref) {
    ref.keepAlive();
    return ProductProvider();
  },
);
