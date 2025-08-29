// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:skeletonizer/skeletonizer.dart';

// class ShimmerWidget extends StatelessWidget {
//   final double width;
//   final double height;
//   final ShapeBorder shapeBorder;
//   final bool isDefaultShape;
//   final double? borderRadius;

//   const ShimmerWidget.rectangular({
//     super.key,
//     this.width = double.infinity,
//     required this.height,
//     this.isDefaultShape = false,
//     this.shapeBorder = const RoundedRectangleBorder(),
//     this.borderRadius,
//   });

//   const ShimmerWidget.circular({
//     super.key,
//     required this.width,
//     required this.height,
//     this.isDefaultShape = true,
//     this.borderRadius,
//   }) : shapeBorder = const CircleBorder();

//   @override
//   Widget build(BuildContext context) => Skeletonizer(
//         enabled: true,
//         child: Container(
//           width: width,
//           height: height,
//           decoration: isDefaultShape
//               ? ShapeDecoration(
//                   color: Colors.grey,
//                   shape: shapeBorder,
//                 )
//               : BoxDecoration(
//                   borderRadius: BorderRadius.circular(
//                     borderRadius ?? 5.r,
//                   ),
//                   color: Colors.grey,
//                 ),
//         ),
//       );
// }
