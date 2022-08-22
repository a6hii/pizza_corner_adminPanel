import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_corner_admin_panel/blocs/blocs.dart';
import 'package:pizza_corner_admin_panel/models/models.dart';
import 'package:pizza_corner_admin_panel/repositories/repo.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final RestaurantRepository _restaurantRepository;
  final CategoryBloc _categoryBloc;
  StreamSubscription? _restaurantSubscription;
  StreamSubscription? _categorySubscription;

  ProductBloc({
    required RestaurantRepository restaurantRepository,
    required CategoryBloc categoryBloc,
  })  : _restaurantRepository = restaurantRepository,
        _categoryBloc = categoryBloc,
        super(
          ProductLoading(),
        ) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
    on<FilterProducts>(_onFilterProducts);

    on<SortProducts>(_onSortProducts);

    _categorySubscription = _categoryBloc.stream.listen((state) {
      if (state is CategoryLoaded && state.selectedCategory != null) {
        add(
          UpdateProducts(
            category: (state.selectedCategory!),
          ),
        );
      } else {}
    });
    _restaurantSubscription =
        _restaurantRepository.getRestaurant().listen((restaurant) {
      add(
        LoadProducts(products: restaurant.products!),
      );
      _restaurantRepository.addRestaurant(restaurant);
    });
  }

  void _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      ProductLoaded(
        products: event.products,
      ),
    );
  }

  void _onAddProduct(
    AddProduct event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductLoaded) {
      List<Product> newProducts = List.from((state as ProductLoaded).products)
        ..add(event.product);

      _restaurantRepository.editProducts(newProducts);

      emit(ProductLoaded(products: newProducts));
    }
  }

  void _onFilterProducts(
    FilterProducts event,
    Emitter<ProductState> emit,
  ) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    List<Product> filteredProducts = Product.products
        .where((product) => product.category == event.category.name)
        .toList();

    emit(ProductLoaded(products: filteredProducts));
  }

  void _onSortProducts(
    SortProducts event,
    Emitter<ProductState> emit,
  ) async {
    final state = this.state as ProductLoaded;
    emit(ProductLoading());
    await Future<void>.delayed(const Duration(seconds: 1));

    int newIndex =
        (event.newIndex > event.oldIndex) ? event.newIndex - 1 : event.newIndex;

    try {
      Product selectedProduct = state.products[event.oldIndex];

      List<Product> sortedProducts = List.from(state.products)
        ..remove(selectedProduct)
        ..insert(newIndex, selectedProduct);

      emit(
        ProductLoaded(products: sortedProducts),
      );
    } catch (_) {}
  }

  @override
  Future<void> close() async {
    _categorySubscription?.cancel();
    _restaurantSubscription?.cancel();
    super.close();
  }
}
