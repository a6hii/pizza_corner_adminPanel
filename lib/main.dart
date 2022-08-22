import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_corner_admin_panel/blocs/blocs.dart';
import 'package:pizza_corner_admin_panel/config/theme.dart';
import 'package:pizza_corner_admin_panel/firebase_options.dart';
import 'package:pizza_corner_admin_panel/models/category_model.dart';
import 'package:pizza_corner_admin_panel/models/models.dart';
import 'package:pizza_corner_admin_panel/models/product_model.dart';
import 'package:pizza_corner_admin_panel/repositories/repo.dart';

import 'screens/screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => RestaurantRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CategoryBloc()
              ..add(
                LoadCategories(
                  categories: Category.categories,
                ),
              ),
          ),
          BlocProvider(
            create: (context) => ProductBloc(
              restaurantRepository: context.read<RestaurantRepository>(),
              categoryBloc: BlocProvider.of<CategoryBloc>(context),
            )..add(
                LoadProducts(products: Product.products),
              ),
          ),
          BlocProvider(
            create: (context) => SettingsBloc(
              restaurantRepository: context.read<RestaurantRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Pizza corner admin panel',
          theme: theme(),
          initialRoute: '/menu',
          routes: {
            '/menu': (context) => const MenuScreen(),
            '/settings': (context) => const SettingsScreen(),
            // '/dash': (context) => const DashboardScreen(),
          },
        ),
      ),
    );
  }
}
