

import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';

class NoRecordFoundScreen extends StatelessWidget {
  const NoRecordFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              AppRouter.back();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            )),
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.noRecordFound,
              width: 250.r,
            ),
            16.ph,
            GenericTranslateWidget( 
              'No record found',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
