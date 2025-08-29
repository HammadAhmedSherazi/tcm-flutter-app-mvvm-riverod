import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';


class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    
  void showInputDialog(BuildContext context) {
      TextEditingController textController =
          TextEditingController(text: BaseApiServices.baseURL);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const GenericTranslateWidget("Enter URL"),
            content: Consumer(
              builder: (context, ref, child) {
                return CustomTextFieldWidget(ref:ref,
                  controller: textController,
                );
              }
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                },
                child: const GenericTranslateWidget("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  if (textController.text.isNotEmpty) {
                    BaseApiServices.baseURL = textController.text;
                    BaseApiServices.imageURL =  BaseApiServices.baseURL.replaceAll('/graphql', '');
                  }
                  // Handle text input
                  Navigator.pop(context); // Close dialog
                  SharedPreferenceManager.sharedInstance
                      .storeUrL(textController.text);
                },
                child: const GenericTranslateWidget("Submit"),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: context.colors.primaryContainer,
      extendBodyBehindAppBar: true,
      appBar:PreferredSize(preferredSize: Size.fromHeight(200.h), child: Padding(padding: EdgeInsets.symmetric(
        horizontal: 20.r,
        vertical: 80.r
      ),child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
           
            padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 5.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1), // light shadow
            blurRadius: 6,
            offset: const Offset(0, 2), // shadow position: down
          ),
              ],
            ),
            child: const LanguageChangeWidget(),
          ),
        ],
      ),)),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: AppStyles.screenHorizontalPadding),
        child: Stack(
          // alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
           
            SizedBox(
              height: context.screenheight * 0.6,
              width: double.infinity,
              child: const RowAnimation(),
            ),
             
            Container(
              height: context.screenheight,
              width: context.screenwidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  end:
                      Alignment.topCenter, // Equivalent to 0deg (top to bottom)
                  begin: Alignment.bottomCenter,
                  colors: [
                    // Fully opaque white

                    Colors.white,
                    Colors.white
                        .withValues(alpha: 0.0), // Fully transparent white
                  ],
                  stops: [
                    0.4787.h,
                    1.0
                  ], // Position the gradient stop to match 66.48%
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                410.ph,
                Center(
                    child: SvgPicture.asset(
                  Assets.appLogo,
                  width: 141.r,
                  height: 59.r,
                )),
                12.ph,
                GenericTranslateWidget(
                  "Travel Community Marketplace",
                  style: context.textStyle.displayMedium!
                      .copyWith(fontSize: 16.sp),
                ),
                32.ph,
                Row(
                  children: [
                    Expanded(
                        child: Divider(
                      thickness: 1,
                      color: Colors.black.withValues(alpha: 0.5),
                    )),
                    23.pw,
                    GenericTranslateWidget(
                      'Sign up and Log in with',
                      style: context.textStyle.bodyMedium,
                    ),
                    23.pw,
                    Expanded(
                        child: Divider(
                      thickness: 1,
                      color: Colors.black.withValues(alpha: 0.5),
                    )),
                  ],
                ),
                22.ph,
                if (Platform.isIOS) ...[
                 Consumer(builder:(_,WidgetRef ref,__){
                  final authProvider = ref.watch(authRepoProvider);
                  return  CustomSocialButtonWidget(
                      title: "Continue with Apple",
                      icon: Assets.appleIcon,
                      isLoad: authProvider.apiAppleSignInResponse.status ==
                            Status.loading,
                      onTap: () {
                       ref.read(authRepoProvider).appleSignIn();
                      });
                 } ),
                  10.ph
                ],
                Consumer(
                  builder: (_, WidgetRef ref, __) {
                    final authProvider = ref.watch(authRepoProvider);
                    return CustomSocialButtonWidget(
                        title: "Continue with Google",
                        icon: Assets.googleIcon,
                        isLoad: authProvider.apiGoogleSignInResponse.status ==
                            Status.loading,
                        onTap: () {
                          ref.read(authRepoProvider).signInWithGoogle();

                          // ref.read(currentLocationProvider).checkLocationPermission();

                          // AppRouter.pushAndRemoveUntil(const NavigationView());
                        });
                  },
                ),
                // 10.ph,
                // CustomSocialButtonWidget(
                //     title: "Continue with Facebook",
                //     icon: Assets.facebookIcon,
                //     onTap: () {
                //       AppRouter.push(const NavigationView());
                //     }),
                const Spacer(),
                TextButton(
                    onPressed: () {
                      showInputDialog(context);
                    },
                    child:  GenericTranslateWidget("Change IP", style: context.textStyle.displayMedium,)),
                Consumer(
                  builder: (context, ref, child) {
                    return RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            style: context.textStyle.bodyMedium!,
                            children: [
                              TextSpan(
                                  text:
                                      Helper.getCachedTranslation(ref: ref, text: "By continuing, you agree to Travel Community Market place ")),
                              TextSpan(
                                  text: Helper.getCachedTranslation(ref: ref, text: "Terms of Service") ,
                                  style: context.textStyle.displayMedium),
                            TextSpan(text: Helper.getCachedTranslation(ref: ref, text: " and acknowledge you've read ") ),
                              TextSpan(
                                  text: Helper.getCachedTranslation(ref: ref, text: "our Privacy Policy. Notice at collection") ,
                                  style: context.textStyle.displayMedium),
                            ]));
                  }
                ),
                20.ph
              ],
            )
            ,
            ],
        ),
      ),
    );
  }
}
