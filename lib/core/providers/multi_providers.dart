import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importing providers from the weather module and the connection module.
import '../../modules/weather/presentation/providers/home_provider.dart';
import '../../modules/weather/presentation/providers/searchbar_provider.dart';
import '../../modules/weather/presentation/providers/settings_provider.dart';
import '../connection/connection.dart';

// A widget that wraps its child with multiple ChangeNotifierProviders.
class MultiProviders extends StatelessWidget {
  const MultiProviders({required this.child, Key? key}) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // List of ChangeNotifierProviders to be used in the widget tree.
      providers: [
        ChangeNotifierProvider(
            create: (_) => ConnectionNotifier()), // Provides connection status.
        ChangeNotifierProvider(
            create: (_) => HomeProvider()), // Provides home-related state.
        ChangeNotifierProvider(
            create: (_) =>
                SettingsProvider()), // Provides settings-related state.
        ChangeNotifierProvider(
            create: (_) =>
                SearchBarProvider()), // Provides search bar-related state.
      ],
      child: child, // The child widget wrapped by the MultiProvider.
    );
  }
}
