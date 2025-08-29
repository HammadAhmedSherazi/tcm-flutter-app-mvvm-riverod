


import 'package:flutter_html/flutter_html.dart';

import '../export_all.dart';

class CustomHTMLViewer extends StatelessWidget {
  final String? data;
  const CustomHTMLViewer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: data ?? "<p><p>",
      onLinkTap: (url, attributes, element) {
        if (url != null) {
          launchUrl(Uri.parse(url));
        }
      },
      style: {
        "*": Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(14.sp),
          textAlign: TextAlign.justify,
        ),
      },
    );
  }
}
