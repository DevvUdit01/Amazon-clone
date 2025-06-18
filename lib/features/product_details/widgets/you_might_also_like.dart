import 'package:flutter/material.dart';

import '../../../common/widgets/you_might_also_like_single.dart';
import '../../../models/product.dart';
import '../screens/product_details_screen.dart';

class YouMightAlsoLike extends StatelessWidget {
  const YouMightAlsoLike({
    super.key,
    required this.categoryProductList,
    required this.deliveryDate,
  });

  final List<Product> categoryProductList;
  final String deliveryDate;

  @override
  Widget build(BuildContext context) {
    if (categoryProductList.isEmpty) {
      return const SizedBox(); // Nothing to show
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'You might also like',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoryProductList.length,
            itemBuilder: (context, index) {
              final productData = categoryProductList[index];

              // Skip rendering if productData is null (defensive)
              if (productData == null ||
                  productData.name.isEmpty ||
                  productData.images.isEmpty) {
                return const SizedBox.shrink();
              }

              return GestureDetector(
                onTap: () {
                  print('categoryProductList: ${categoryProductList?.length}');
print('categoryProductList[0]: ${categoryProductList?[0]}');

                  Navigator.pushNamed(
                    context,
                    ProductDetailsScreen.routeName,
                    arguments: {
                      'product': productData,
                      'deliveryDate': deliveryDate,
                    },
                  );
                },
                child: YouMightAlsoLikeSingle(product: productData),
              );
            },
          ),
        ),
      ],
    );
  }
}
