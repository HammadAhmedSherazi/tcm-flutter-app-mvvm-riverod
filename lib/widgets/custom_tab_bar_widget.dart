import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';


// class GradientTabBar extends StatefulWidget {
//   const GradientTabBar({super.key});

//   @override
//   GradientTabBarState createState() => GradientTabBarState();
// }

// class GradientTabBarState extends State<GradientTabBar>
//     with SingleTickerProviderStateMixin {
//   late TabController tabController;

//   @override
//   void initState() {
//     super.initState();
//     tabController = TabController(length: 3, vsync: this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const GenericTranslateWidget( "Gradient TabBar"),
//         bottom: TabBar(
//           controller: tabController,
//           indicator: GradientTabIndicator(), // Custom Gradient Indicator
//           labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           unselectedLabelStyle: const TextStyle(fontSize: 16),
//           unselectedLabelColor: Colors.grey, // Gray text for unselected
//           tabs: const [
//             GradientTextTab(text: "All"),
//             GradientTextTab(text: "Seller"),
//             GradientTextTab(text: "Buyer"),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: tabController,
//         children: const [
//           Center(child: GenericTranslateWidget( "All")),
//           Center(child: GenericTranslateWidget( "Seller")),
//           Center(child: GenericTranslateWidget( "Buyer")),
//         ],
//       ),
//     );
//   }
// }

// // Custom Gradient Indicator
// class GradientTabIndicator extends Decoration {
//   @override
//   BoxPainter createBoxPainter([VoidCallback? onChanged]) {
//     return _GradientPainter();
//   }
// }

// class _GradientPainter extends BoxPainter {
//   @override
//   void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
//     final Paint paint = Paint()
//       ..shader = const LinearGradient(
//         colors: [
//           Color(0xFF006CD4), // #006CD4
//           Color(0xFF0675D5), // #0675D5
//           Color(0xFF168FD6), // #168FD6
//           Color(0xFF1E9CD7), // #1E9CD7
//         ],
//       ).createShader(Rect.fromLTWH(
//           offset.dx, configuration.size!.height - 2, configuration.size!.width, 2))
//       ..strokeWidth = 1
//       ..style = PaintingStyle.stroke;

//     final double x1 = offset.dx;
//     final double x2 = x1 + configuration.size!.width;
//     final double y = offset.dy + configuration.size!.height - 2;

//     canvas.drawLine(Offset(x1, y), Offset(x2, y), paint);
//   }
// }

// // Custom Gradient Text for Selected Tab
// class GradientTextTab extends StatelessWidget {
//   final String text;

//   const GradientTextTab({required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return ShaderMask(
//       shaderCallback: (bounds) => const LinearGradient(
//         colors: [
//           Color(0xFF006CD4), // #006CD4
//           Color(0xFF0675D5), // #0675D5
//           Color(0xFF168FD6), // #168FD6
//           Color(0xFF1E9CD7), // #1E9CD7
//         ],
//       ).createShader(bounds),
//       child: GenericTranslateWidget( text, style: const TextStyle(color: Colors.white)),
//     );
//   }
// }

class CustomTabBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final TabController? controller;
  final List<Widget> tabs;
  const CustomTabBarWidget({super.key, this.controller, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      padding: EdgeInsets.zero,
    
      // Remove extra padding
      labelPadding: EdgeInsets.symmetric(
          vertical: 5.r, horizontal: 5.r), // Adjust padding
      indicator: const UnderlineTabIndicator(
        // Simple underline indicator
        
        borderSide: BorderSide(width: 1, color: Color(0xFF168FD6)),
      ),
      
      labelColor: Colors.transparent,
      // Blue color for selected tab
      unselectedLabelColor: Colors.transparent, // Gray color for unselected tabs
      labelStyle: context.textStyle.bodyMedium!.copyWith(
          fontSize: 18.sp,
          foreground: Paint()
            ..shader = AppColors.primaryGradinet
                .createShader(const Rect.fromLTWH(0, 0, 200, 70))),
      unselectedLabelStyle:
          context.textStyle.bodyMedium!.copyWith(fontSize: 18.sp, color: const Color.fromRGBO(0, 0, 0, 0.5)),
      tabs: tabs,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
