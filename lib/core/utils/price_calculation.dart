import 'package:flutter/material.dart';

class PriceCalculation {

  const PriceCalculation(_);

  static double? originalPriceForm({
    required double price,
    required double discountPercentage,

  }){
    if(discountPercentage <= 0) return null;
    return price/(1-discountPercentage)/100;
  }

  static int discountPercentageForm({
    required double price,
    required double? originalPrice,

  }){
    if(originalPrice == null || originalPrice <= price) return 0;
    return ((originalPrice-price)/originalPrice*100).round();
  }

  static double savingsFor({
    required double price,
    required double? originalPrice,
    required int quantity,

  }){
    if(originalPrice == null || originalPrice <= price) return 0;
    return (originalPrice-price)*quantity;
  }
  

}