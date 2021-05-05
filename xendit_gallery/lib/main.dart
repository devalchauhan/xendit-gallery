import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:xendit_gallery/constants/colors.dart';
import 'package:xendit_gallery/features/image_detail/presentation/cubit/image_detail_cubit.dart';
import 'package:xendit_gallery/router.dart';
import 'features/image_list/presentation/cubit/image_list_cubit.dart';
import 'injenction_container.dart' as di;
import 'injenction_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => sl<ImageListCubit>()),
      BlocProvider(create: (context) => sl<ImageDetailCubit>()),
    ],
    child: Xendit(
      router: AppRouter(),
    ),
  ));
}

class Xendit extends StatelessWidget {
  final AppRouter router;
  @override
  const Xendit({Key key, this.router}) : super(key: key);
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: kPrimaryColor,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router.generateRoute,
    );
  }
}
