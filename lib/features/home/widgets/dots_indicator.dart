import 'package:carousel_slider/carousel_controller.dart' as cr;
import 'package:flutter/material.dart' hide CarouselController;

import '../../../constants/global_variables.dart';

class DotsIndicatorMap extends StatelessWidget {
  const DotsIndicatorMap({
    super.key,
    required this.controller,
    required this.current,
    required this.sliderImages,
  });

  final cr.CarouselSliderController controller;
  final int current;
  final List<Map<String, String>> sliderImages;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: sliderImages.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () => controller.animateToPage(entry.key),
          child: Container(
            width: 9.0,
            height: 9.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                shape: BoxShape.circle,
                color: current == entry.key
                    ? GlobalVariables.selectedNavBarColor
                    : Colors.white),
          ),
        );
      }).toList(),
    );
  }
}

class DotsIndicatorList extends StatelessWidget {
  const DotsIndicatorList({
    super.key,
    required this.controller,
    required this.current,
    required this.sliderImages,
  });

  final cr.CarouselSliderController controller;
  final int current;
  final List<String> sliderImages;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: sliderImages.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () => controller.animateToPage(entry.key),
          child: Container(
            width: 9.0,
            height: 9.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                shape: BoxShape.circle,
                color: current == entry.key
                    ? GlobalVariables.selectedNavBarColor
                    : Colors.white),
          ),
        );
      }).toList(),
    );
  }
}
