import 'package:flutter/material.dart';
import 'package:xendit_gallery/features/image_browser/presentation/pages/image_browser.dart';
import 'package:xendit_gallery/features/image_detail/presentation/page/image_detail.dart';
import 'package:xendit_gallery/features/image_list/presentation/page/image_list.dart';

import 'constants/strings.dart';

class AppRouter {
  Route generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => ImageList());
      case IMAGE_DETAIL:
        return MaterialPageRoute(builder: (_) => ImageDetail());
      case IMAGE_BROWSER:
        final imagePath = routeSettings.arguments;
        return MaterialPageRoute(
            builder: (_) => ImageBrowser(
                  imagePath: imagePath,
                ));
      default:
        return null;
    }
  }
}
