import 'package:sqflite/sqflite.dart';
import 'package:ecomerceapp/core/constants/app_constants.dart';
import 'package:ecomerceapp/core/database/database_helper.dart';
import 'package:ecomerceapp/features/cart/data/models/cart_item_model.dart';

abstract class CartLocalDataSource {

  Future<List<CartItemModel>> getCartItems();
  Future<void> addToCart(CartItemModel item);
  Future<void> removeFromCart(int productId);
  Future<void> updateQuantity(int productId, int quantity);
  Future<void> clearCart();

}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  Future<Database> get database => DatabaseHelper.database;


  @override
  Future<List<CartItemModel>> getCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(AppConstants.cartTable);
    return List.generate(maps.length, (i) {
      return CartItemModel.fromJson(maps[i]);
    });
  }


  @override
  Future<void> addToCart(CartItemModel item) async {
    final db = await database;
    await db.insert(
      AppConstants.cartTable,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> removeFromCart(int productId) async {
    final db = await database;
    await db.delete(
      AppConstants.cartTable,
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  @override
  Future<void> updateQuantity(int productId, int quantity) async {
    final db = await database;
    await db.update(
      AppConstants.cartTable,
      {'quantity': quantity},
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  @override
  Future<void> clearCart() async {
    final db = await database;
    await db.delete(AppConstants.cartTable);
  }
}