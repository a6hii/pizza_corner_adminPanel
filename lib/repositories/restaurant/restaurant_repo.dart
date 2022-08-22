import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:pizza_corner_admin_panel/models/models.dart';
import 'package:pizza_corner_admin_panel/repositories/repo.dart';

class RestaurantRepository extends BaseRestaurantRepository {
  final FirebaseFirestore _firebaseFirestore;

  RestaurantRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addRestaurant(Restaurant restaurant) async {
    await _firebaseFirestore
        .collection('restaurants')
        .add(restaurant.toDocument());
  }

  @override
  Future<void> editRestaurantSettings(Restaurant restaurant) async {
    await _firebaseFirestore
        .collection('restaurants')
        .doc('iOHePfcDzqS9iwpzas7K')
        .update(restaurant.toDocument());
  }

  @override
  Future<void> editRestaurantOpeningHours(
    List<OpeningHours> openingHours,
  ) async {
    await _firebaseFirestore
        .collection('restaurants')
        .doc('iOHePfcDzqS9iwpzas7K')
        .update({
      'openingHours': openingHours.map(
        (openingHour) {
          return openingHour.toDocument();
        },
      ).toList(),
    });
  }

  @override
  Future<void> editProducts(List<Product> products) async {
    await _firebaseFirestore
        .collection('restaurants')
        .doc('iOHePfcDzqS9iwpzas7K')
        .update({
      'products': products.map(
        (product) {
          return product.toDocument();
        },
      ).toList(),
    });
  }

  @override
  Stream<Restaurant> getRestaurant() {
    return _firebaseFirestore
        .collection('restaurants')
        .doc('iOHePfcDzqS9iwpzas7K')
        .snapshots()
        .map((snapshot) {
      return Restaurant.fromSnapshot(snapshot);
    });
  }
}
