import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:weather_show/color_schemes.dart';
import 'package:weather_show/src/bloc/db_bloc/fav_db_cubit.dart';
import 'package:weather_show/src/bloc/index_cubit.dart';
import 'package:weather_show/src/bloc/search_detail_bloc/search_detail_cubit.dart';
import 'package:weather_show/src/bloc/search_weather_bloc/search_weather_cubit.dart';
import 'package:weather_show/src/repository/search_weather_repo.dart';
import 'package:weather_show/src/service/auth_service.dart';
import 'package:weather_show/src/service/http/dio_http_service.dart';
import 'package:weather_show/src/service/messaging_service/messaging_service.dart';
import 'package:weather_show/src/service/messaging_service/push_message.dart';
import 'package:weather_show/src/service/storage/fav_city_storage.dart';
import 'package:weather_show/src/service/storage/firebase_storage_service.dart';
import 'package:weather_show/src/utilities/route_manager.dart';

import 'firebase_options.dart';
import 'src/bloc/weather_bloc/weather_cubit.dart';
import 'src/repository/favorite_db_repository.dart';
import 'src/repository/http_weather_repository.dart';
import 'src/views/weather_app_view.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  await messagingService.setupFlutterNotifications();
}
final scaffoldMessenger = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  registerSingleTon();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await messagingService.setupFlutterNotifications();
  }

  FirebaseUIAuth.configureProviders([EmailAuthProvider()]);
  final httpService = DioHttpService();
  runApp(
    MyWeatherApp(
      weatherRepository: HttpWeatherRepository(httpService),
      searchRepository: SearchWeatherRepository(httpService),
      dbRepository: FavoriteDBRepository(),
    ),
  );
}

class MyWeatherApp extends StatelessWidget {
  const MyWeatherApp({super.key, required this.weatherRepository, required this.searchRepository, required this.dbRepository});

  final HttpWeatherRepository weatherRepository;
  final SearchWeatherRepository searchRepository;
  final FavoriteDBRepository dbRepository;

  // String get initialRoute {
  //   final auth = FirebaseAuth.instance;
  //
  //   if (auth.currentUser == null) {
  //     return '/';
  //   }
  //
  //   if (!auth.currentUser!.emailVerified && auth.currentUser!.email != null) {
  //     return '/verify-email';
  //   }
  //
  //   return '/profile';
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => WeatherCubit(weatherRepository)),
        BlocProvider(create: (context) => SearchDetailCubit(weatherRepository)),
        BlocProvider(create: (context) => SearchWeatherCubit(searchRepository)),
        BlocProvider(create: (context) => FavDbCubit(dbRepository)),
        BlocProvider(create: (context) => IndexCubit()),
      ],
      child: MaterialApp(
        title: 'Weather',
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: scaffoldMessenger,
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
            fontFamily: 'Open Sans',
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 17),
            )),
        darkTheme:
            ThemeData(useMaterial3: true, colorScheme: darkColorScheme, fontFamily: 'Open Sans'),
        initialRoute: '/',
        onGenerateRoute: RouteManger.generateRoute,
        // home: const WeatherApp(),
      ),
    );
  }
}

void registerSingleTon() {
  // Messaging
  GetIt.I.registerLazySingleton<MessagingService>(() => MessagingService());
  // Firebase Storage
  GetIt.I.registerLazySingleton<FirebaseStorageService>(() => FirebaseStorageService());
  // Auth
  GetIt.I.registerLazySingleton<AuthService>(() => AuthService());
  // Push
  GetIt.I.registerLazySingleton<PushMessage>(() => PushMessage());
}

MessagingService get messagingService => GetIt.I.get<MessagingService>();

FirebaseStorageService get firebaseStoreService => GetIt.I.get<FirebaseStorageService>();

AuthService get authService => GetIt.I.get<AuthService>();

PushMessage get pushMessage => GetIt.I.get<PushMessage>();
