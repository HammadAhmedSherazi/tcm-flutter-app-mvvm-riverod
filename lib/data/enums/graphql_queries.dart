class GraphQLQueries {
  //SIGN IN QUERY
  static const String signinQuery = '''
mutation SignIn(\$input: SignInInput!) {
  signIn(input: \$input) {
    access_token
    data {
      id
      first_name
      last_name
      email
      gender
      picture
      account_type
      is_notification
      is_active
      phone
    }
    message
    refresh_token
    statusCode
  }
}
''';

//UPDATE PROFILE QUERY
  static const String updateProfileQuery = '''
mutation UpdateProfile(\$input: UpdateProfileInput!) {
  updateProfile(input: \$input) {
    message
    data {
      id
      first_name
      last_name
      email
      gender
      picture
      account_type
      is_notification
      is_active
      phone
    }
  }
}
''';

//LOGOUT QUERY
  static const String logoutQuery = '''
mutation Logout(\$fcmToken: String) {
  logout(fcm_token: \$fcmToken) {
    message
    statusCode
  }
}
''';

//TOKEN UPDATE QUERY
  static const String refreshTokenQuery = '''
mutation Refresh(\$refreshToken: String!) {
  refresh(refresh_token: \$refreshToken) {
    access_token
    refresh_token
    statusCode
  }
}
''';

//LOCATION SET QUERY
  static const String locationSetQuery = '''
mutation Refresh(\$refreshToken: String!) {
  refresh(refresh_token: \$refreshToken) {
    access_token
    refresh_token
    statusCode
  }
}
''';

//ALL CATEGORIES
  static const String allCategoriesQuery = '''
query AllCategory(\$input: AllCategoryInput!) {
  allCategory(input: \$input) {
    data {
      icon
      id
      name
      path
    }
    nextCursor
  }
}
''';

//SUB CATEGORIES
  static const String mainCategoriesQuery = '''
query ListCategory(\$input: ListCategoryInput!) {
  listCategory(input: \$input) {
    icon
    id
    name
    path
  }
  
}
''';

//CREATE AD POST QUERY
  static const String createAdQuery = '''
mutation CreateAd(\$input: CreateAdInput!, \$buyingReceipt: [Upload]!, \$images: [Upload]!) {
  createAd(input: \$input, buying_receipt: \$buyingReceipt, images: \$images) {
    message
    statusCode
    data
  }
}
''';

//DELETE AD POST QUERY
  static const String deleteAdQuery = '''
mutation DeleteAd(\$deleteAdId: Int!) {
  deleteAd(id: \$deleteAdId) {
    message
    statusCode
  }
}
''';

  static const String homeProductsQuery = '''
query GetAdStoreItems(\$input: AdStoreItemsInput!) {
  getAdStoreItems(input: \$input) {
    pre_owned {
      id
      title
      description
      price
      category_id
      images
      status 

    }
    dis_pre_owned {
      id
      title
      description
      price
      category_id
      images
      status

    }
    store {
      id
      title
      description
      price
      quantity
      thumbnail_image
      category {
        id
      }
      images

    }
    vanish_deals {
      id
      title
      description
      price
      check_in
      check_out
      category_id
      images
      status

    }
  }
}
''';

//ALL BANNER QUERY
  static const String allBannerQuery = '''
query GetAllConfigurations(\$type: [ConfigurationsType!]!) {
  getAllConfigurations(type: \$type) {
    banner {
      key
      meta
      id
    }
  }
}
''';

//SIMILAR PRODUCTS QUERY
  static const String similarProductsQuery = '''
query GetSimilarAd(\$input: SimilarAdInput!) {
  getSimilarAd(input: \$input) {
    id
    title
    description
    price
    category_id
    status
  }
}
''';

//STATIC ALL MY POSTED AD QUERY
  static String allADQuery = '''
query AllAd(\$input: AllAdInput!) {
  allAd(input: \$input) {
    nextCursor
    data {
      id
      title
      category_id
      description
      brands
      price
      condition
      unit
      check_in
      check_out
      buying_receipts
      images
      location
      status
      user {
        id
        first_name
        last_name
        picture
        is_active
      }
      category {
        id
        name
        icon
      }
      created_at
      updated_at
    }
  }
}
''';

//PRODUCT DETAILS QUERY
  static const String productDetailsQuery = '''
query GetAdDetail(\$getAdDetailId: Int!) {
  getAdDetail(id: \$getAdDetailId) {
    id
    application_fee
    title
    brands
    description
    price
    condition
    category_id
    unit
    check_in
    check_out
    buying_receipts
    images
    location
    status
    ads_chats {
      id
     }
    user {
      first_name
      last_name
      picture
      id
      is_active
    }
    category {
      icon
      id
      name
      path
    }
    wishlists
    created_at
    updated_at
  }
}
''';

//PRODUCT DETAILS QUERY
  static const String updateAdQuery = '''
mutation Mutation(\$input: UpdateAdInput!, \$newReceipt: [Upload]!, \$newImages: [Upload]!) {
  updateAd(input: \$input, new_receipt: \$newReceipt, new_images: \$newImages) {
    message
    statusCode
    data
  }
}
''';

//BRAND LIST QUERY
  static const String brandListQuery = '''
query ListBrand {
  listBrand {
    name
    id
  }
}
''';

//NOTIFY CATEGORY QUERY
  static const String notifyCategoryQuery = '''
mutation CreateAdNotify(\$input: CreateAdNotifyInput!) {
  createAdNotify(input: \$input) {
    message
    statusCode
    data
  }
}
''';

//NOTIFY CATEGORY QUERY
  static const String getNotifyCategoryQuery = '''
query AllAdNotify(\$input: AllAdNotifyInput!) {
  allAdNotify(input: \$input) {
    data {
      address_line
      id
      categories {
        id
        name
        icon
        parent_id
        path
        createdAt
        updatedAt
      }
      radius
      city
      country
      lat
      lon
    }
    nextCursor
  }
}
''';

//DELETE NOTIFY QUERY
  static const String deleteNotifyQuery = '''
mutation DeleteAdNotify(\$deleteAdNotifyId: Int!) {
  deleteAdNotify(id: \$deleteAdNotifyId) {
    message
    statusCode
  }
}
''';

//CHAT LIST QUERY
  static const String chatListQuery = '''
query AllAdsChats(\$input: AllAdsChatsInput!) {
  allAdsChats(input: \$input) {
    nextCursor
    data {
      last_message
      sender_id
      id
      ad {
        application_fee
        images
        id
        price
        status
        title
        description
        user {
      first_name
      last_name
      picture
      id
      is_active
    }
      }
      Sender {
        first_name
        last_name
        picture
        id
      }
      Receiver {
        first_name
        last_name
        picture
        id
      }
    }
  }
}
''';

//CHAT MESSAGE LIST QUERY
  static const String chatMessageListQuery = '''
query AllAdsMessages(\$input: AllAdsMessagesInput!) {
  allAdsMessages(input: \$input) {
    nextCursor
    data {
      is_media
      message
      sender_id
      id
      is_read
      created_at
    }
  }
}
''';

//CREATE CHAT QUERY
  static const String createChatQuery = '''
mutation CreateAdsChat(\$input: AdsChatInput!) {
  createAdsChat(input: \$input) {
    data {
      chat_id
      is_media
      message
      sender_id
      id
      is_read
      created_at
      message_id
    }
  }
}
''';

  static const String deleteAdChatQuery = '''
mutation DeleteAdsChat(\$deleteAdsChatId: Int!) {
    deleteAdsChat(id: \$deleteAdsChatId) {
      message
      statusCode
    }
}
''';

  static const String notificationQuery = '''
query AllNotifications(\$input: AllNotificationsInput!) {
  allNotifications(input: \$input) {
    data {
      sub_title
      created_at
      data
      id
    }
  }
}
''';

  static const String marketProductQuery = '''
query Query(\$input: MarketPlaceInput!) {
  getMarketPlaceItems(input: \$input)
}
''';

  static const String seeAllAdQuery = '''
query AllProduct(\$input: AllItemsInput!) {
  allProducts(input: \$input) {
    nextCursor
    data
  }
}
''';

  static const String getfavouriteListQuery = '''
query GetAllWishlists(\$input: AllWishlistInput!) {
  getAllWishlists(input: \$input) {
    nextCursor
    data {
      ad {
        images
        id
        price
        status
        title
        description
    }
    }
  }
}
''';

  static const String checkFavouriteQuery = '''
mutation CreateWishlist(\$adsId: Int!) {
  createWishlist(ads_id: \$adsId) {
    message
    statusCode
  }
}
''';
  static const String removeFavouriteQuery = '''
mutation RemoveWishlist(\$adsId: Int!) {
  removeWishlist(ads_id: \$adsId) {
    message
    statusCode
  }
}
''';

  static const String allPostQuery = '''
query AllPosts(\$input: AllPostInput!) {
  allPosts(input: \$input) {
    nextCursor
    data {
      comments_count
      content
      created_at
      updated_at
      id
      reactions
      images
      my_reaction

      user {
        first_name
        picture
        last_name
        id
        gender
        is_active
      }
      user_id
    }
  }
}
''';

  static const String createPostQuery = '''
mutation CreatePost(\$input: CreatePostInput!, \$images: [Upload]) {
  createPost(input: \$input, images: \$images) {
    message
    data {
      comments_count
      content
      created_at
      updated_at
      id
      images
      my_reaction
      reactions
      user {
        first_name
        picture
        last_name
        id
        gender
        is_active
      }
      user_id
    }
  }
}
''';

  static const String deletePostQuery = '''
mutation DeletePost(\$deletePostId: Int!) {
  deletePost(id: \$deletePostId) {
    message
    statusCode
  }
}
''';

  static const String updatePostQuery = '''
mutation UpdatePost(\$input: UpdatePostInput!, \$newImages: [Upload]) {
  updatePost(input: \$input, new_images: \$newImages) {
    message
    statusCode
    data {
      comments_count
      content
      created_at
      updated_at
      id
      images
      my_reaction
      reactions
      user {
        first_name
        picture
        last_name
        id
        gender
        is_active
      }
      user_id
    }
  }
}
''';

  static const String createCommentQuery = '''
mutation CreatePostComment(\$input: CreatePostCommentInput!) {
  createPostComment(input: \$input) {
    message
    statusCode
    data {
      id
      post_id
      user_id
      comment
      created_at
      updated_at
      user {
        first_name
        picture
        last_name
        id
        gender
        is_active
      }
    }
  }
}
''';

  static const String deleteCommentQuery = '''
mutation DeletePostComment(\$deletePostCommentId: Int!) {
  deletePostComment(id: \$deletePostCommentId) {
    message
    statusCode
  }
}
''';

  static const String reportPostQuery = '''
mutation ReportPost(\$reportPostId: Int!) {
  reportPost(id: \$reportPostId) {
    message
    statusCode
  }
}
''';

  static const String likePostQuery = '''
mutation LikePost(\$input: LikePostInput!) {
  likePost(input: \$input) {
    message
    statusCode
  }
}
''';

  static const String postCommentQuery = '''
query GetAllPostComments(\$input: AllPostCommentInput!) {
  getAllPostComments(input: \$input) {
    nextCursor
    data {
      id
      post_id
      user_id
      comment
      created_at
      updated_at
      user {
        first_name
        picture
        last_name
        id
        gender
        is_active
      }
    }
  }
}
''';

  static const String updateNotifyQuery = '''
mutation Mutation(\$input: UpdateAdNotifyInput!) {
  updateAdNotify(input: \$input) {
    message
    statusCode
    data
  }
}
''';

  static const String myCardQuery = '''
query MyCards {
  myCards {
    id
    brand
    last4
    exp_month
    exp_year
    fingerprint
  }
}
''';

  static const String addCardQuery = '''
mutation AddToCart(\$input: CartItemInput!) {
  addToCart(input: \$input) {
    message
    statusCode
    data {
      product {
      id
      title
      description
      price
      category {
        id
      }
      quantity
      images

    }
      id
      quantity
    }
  }
}
''';

  static const String deleteCartQuery = '''
mutation RemoveCartItem(\$removeCartItemId: [Int!]!) {
  removeCartItem(id: \$removeCartItemId) {
    message
    statusCode
  }
}
''';

  static const String clearCart = '''
mutation ClearCart {
  clearCart {
    message
    statusCode
  }
}
''';

  static const String getCheckOutListQuery = '''
query GetAllCartItems(\$input: AllCartInput!) {
  getAllCartItems(input: \$input) {
    product {
      id
      title
      description
      price
      quantity
      thumbnail_image
      discount_value
      off_type
      is_available
      is_stock
      store {
        id
        logo
        name
        delivery_options {
          type
          description
          price
        }
      }
      category {
        id
      }
      images

    }
    quantity
    total_items
    id
  }
}
''';

  static const String getVenderProductsQuery = '''
query Query(\$input: MarketPlaceInput!) {
  getStoreItems(input: \$input)
}
''';

  static const String getTopStoreQuery = '''
query TopStores(\$input: TopStoreInput!) {
  topStores(input: \$input) {
      store {
        id
        logo
        name
      }
  }
}
''';

  static const String getStoreProductDetailQuery = '''
query ProductDetail(\$productDetailId: Int!) {
  productDetail(id: \$productDetailId) {
    id
    title
    description
    store {
        id
        logo
        name
        delivery_options {
          type
          description
          price
        }
      }
    thumbnail_image
    images
    price
    off_type
    discount_value
    quantity
    category {
        id
        name
        icon
        parent_id
        path
        createdAt
        updatedAt
      }
    average_rating
    total_reviews
    
  }
}
''';

  static const String getSimilarVenderProductQuery = '''
query GetSimilarProduct(\$input: SimilarProductInput!) {
  getSimilarProduct(input: \$input) {
    id
    images
    thumbnail_image
    title
    price
    quantity
    description
  }
}
''';

static const String createOrderQuery = '''
mutation CreateOrder(\$input: CreateOrderInput!) {
  createOrder(input: \$input) {
    message
    statusCode
  }
}
''';

static const String checkOutQuery = '''
mutation Mutation(\$input: CheckoutCartInput!) {
  checkoutCart(input: \$input) {
    message
    statusCode
  }
}
''';

static const String buyNowQuery = '''
mutation BuyNowProduct(\$input: BuyNowProductInput!) {
  buyNowProduct(input: \$input) {
    message
    statusCode
  }
}
''';


static const String storeOrderHistoryQuery = '''
query AllOrders(\$input: AllOrderInput) {
  allOrders(input: \$input) {
 
    data {
      order_no
      id
      contact_information
      store_orders {
        
        id
        shipping_cost
        shipping_type

        store {
          name
          logo
          id
          delivery_options {
            type
            description
            price
          }
        }
       order_items {
          total_price
          quantity
          is_refunded
          price
          id
          product {
            id
            thumbnail_image
            title
           
          }
        }
        status
      }
      total_amount
      shipping_address
    }
    nextCursor
  }
}
''';
static const String adBuyNowQuery = '''
mutation BuyNowAds(\$input: CreateAdsOrderInput!) {
  buyNowAds(input: \$input) {
    message
    statusCode
    data
  }
}
''';

static const String adOrderQuery = '''
query AllAdsOrder(\$input: AdsOrderInput!) {
  allAdsOrder(input: \$input) {
    nextCursor
    data {
      contact_information
      ads_no
      total_amount
      status
      id
      ad {
        images
        price
        category {
          name
          icon
          id
        }
        buying_receipts
        user {
          email
          first_name
          gender
          id
          is_active
          is_notification
          is_verified
          last_name
          phone
          picture
          
        }
      }
    }
  }
}
''';

static const String removeCardQuery = '''
mutation RemoveCard(\$removeCardId: String!) {
  removeCard(id: \$removeCardId){
    message
    statusCode
  }
}
''';

static const String saveCardQuery = '''
mutation SavePaymentCard(\$paymentMethodId: String!) {
  savePaymentCard(payment_method_id: \$paymentMethodId) {
    message
    statusCode
  }
}
''';

static const String getNotesQuery = '''
query Query(\$input: AllNotesInput!) {
  getAllNote(input: \$input) {
    nextCursor
    data {
      created_at
      description
      id
      title
    }
  }
}
''';

static const String createNoteQuery = '''
mutation CreateNote(\$input: CreateNoteInput!) {
  createNote(input: \$input) {
    message
    statusCode
  }
}
''';

static const String updateNoteQuery = '''
mutation UpdateNote(\$input: UpdateNoteInput!) {
  updateNote(input: \$input) {
    message
    statusCode
  }
}
''';

static const String deleteNoteQuery = '''
mutation DeleteNote(\$deleteNoteId: [Int]!) {
  deleteNote(id: \$deleteNoteId) {
    message
    statusCode
  }
}
''';

static const String getProductReviewQuery = '''
query GetProductReviews(\$input: ProductReviewInput!) {
  getProductReviews(input: \$input) {
    nextCursor
    data {
      created_at
      store_order_id
      id
      rating
      review
      store_reply
      images
      product {
        average_rating
        id
        images
        price
        discount_value
        off_type
        thumbnail_image
        title
        store {
          name
          logo
          id
        }
      }
      customer {
          email
          first_name
          gender
          id
          is_active
          is_notification
          is_verified
          last_name
          phone
          picture
          
        }
    }
  }
}
''';

static const String createProductReviewQuery = '''
mutation CreateProductReview(\$input: CreateProductReviewInput!) {
  createProductReview(input: \$input) {
    message
    statusCode
  }
}
''';

static const String updateProductReviewQuery = '''
mutation UpdateProductReview(\$input: UpdateProductReviewInput!) {
  updateProductReview(input: \$input) {
    statusCode
    message
  }
}
''';

static const String attachBankQuery = '''
mutation AttachBank(\$bankToken: String) {
  attachBank(bank_token: \$bankToken) {
    message
    statusCode
  }
}
''';
static const String walletDetailQuery = '''
query WalletsDetails {
  walletsDetails {
    account_complete
    attach_bank
    balance {
      available
      locked
      refund
    }
  }
}
''';

static const String transactionQuery = '''
query AllTransaction(\$input: TransactionInput!) {
  allTransaction(input: \$input) {
    nextCursor
    data {
      id
      amount
      type
      status
      created_at
      
    }
  }
}
''';

static const String payoutQuery = '''
mutation Payouts {
  payouts {
    message
    statusCode
  }
}
''';

static const String cancelOrderQuery = '''
mutation Mutation(\$input: OrderCancelInput!) {
  cancelOrder(input: \$input) {
    message
    statusCode
  }
}
''';


static const String createRefundQuery = '''
mutation CreateRefundRequest(\$input: CreateRefundRequestInput!) {
  createRefundRequest(input: \$input) {
    message
    statusCode
  }
}
''';

static const String getRefundRequestQuery = '''
query AllRefundRequests(\$input: AllRefundRequestsInput) {
  allRefundRequests(input: \$input) {
    nextCursor
    data {
      status
      order_item_id
      images
      product {
        id
        title
        thumbnail_image
        description
      }
      reason
      reason_code
      refund_amount
    }
  }
}
''';
}
