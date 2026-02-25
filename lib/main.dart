import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/services/history_service.dart';
import 'core/services/local_profile_service.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/sign_in_page.dart';
import 'features/auth/presentation/pages/sign_up_page.dart';
import 'features/text_extraction/domain/entities/extraction_item.dart';
import 'features/text_extraction/presentation/pages/main_navigation_page.dart';
import 'firebase_options.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();
  Hive.registerAdapter(ExtractionItemAdapter());
  await HistoryService.openBox();
  await LocalProfileService.openBox();

  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>()..add(const AuthCheckRequested()),
      child: MaterialApp(
        title: 'TextSnap',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthGate(),
        routes: {
          '/signin': (context) => const SignInPage(),
          '/signup': (context) => const SignUpPage(),
          '/home': (context) => const MainNavigationPage(),
        },
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) {
        return current is AuthInitial || current is Authenticated || current is Unauthenticated;
      },
      builder: (context, state) {
        if (state is AuthInitial) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state is Authenticated) {
          return const MainNavigationPage();
        }

        return const SignInPage();
      },
    );
  }
}
