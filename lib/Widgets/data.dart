import 'package:flutter/material.dart';

class Data {
  final String imageUrl;

  final String text;

  const Data({required this.text, required this.imageUrl});
}

final List<Data> data = [
  Data(
    text: 'Nike',
    imageUrl: 'assets/images/Nike Air Website Pic.png',
  ),
  Data(
    text: 'Yeezy',
    imageUrl: 'assets/images/Yeezy Website Pic.png',
  ),
  Data(
    text: 'Adidas',
    imageUrl: 'assets/images/Adidas Website Pic.png',
  ),
  Data(
    text: 'New Balance',
    imageUrl: 'assets/images/New Balance Website Pic.png',
  ),
  Data(
    text: 'Vans',
    imageUrl: 'assets/images/Vans Website Pic.png',
  ),
  Data(
    text: 'Converse',
    imageUrl: 'assets/images/Converse Website Pic.png',
  ),
  Data(
    text: 'Reebok',
    imageUrl: 'assets/images/Reebok Website Pic.png',
  ),
  Data(
    text: 'Asics',
    imageUrl: 'assets/images/Asics Website Pic.png',
  ),
  Data(
    text: 'Jordan',
    imageUrl: 'assets/images/Air Jordan Website Pic.png',
  ),
];
