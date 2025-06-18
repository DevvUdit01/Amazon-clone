import 'package:amazon_clone_flutter/features/product_details/services/product_details_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constants/utils.dart';
import '../../features/product_details/screens/product_details_screen.dart';
import 'stars.dart';
import '../../constants/global_variables.dart';
import '../../models/product.dart';

class SingleListingProduct extends StatefulWidget {
  const SingleListingProduct({
    super.key,
    required this.product,
    required this.deliveryDate,
  });

  final Product? product;
  final String? deliveryDate;

  @override
  State<SingleListingProduct> createState() => _SingleListingProductState();
}

class _SingleListingProductState extends State<SingleListingProduct> {
  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();

  double averageRating = 0;
  String? price;

  @override
  void initState() {
    super.initState();

    if (widget.product?.price != null) {
      price = formatPrice(widget.product!.price);
    } else {
      price = 'N/A';
    }

    getAverageRating();
  }

  Future<void> getAverageRating() async {
    if (widget.product != null) {
      averageRating = await productDetailsServices.getAverageRating(
        context: context,
        product: widget.product!,
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    const productTextStyle = TextStyle(
      fontSize: 12,
      color: Colors.black54,
      fontWeight: FontWeight.normal,
    );

    final product = widget.product;
    final imageUrl = (product?.images != null && product!.images.isNotEmpty)
        ? product.images[0]
        : 'https://via.placeholder.com/150';

    return GestureDetector(
      onTap: () {
        if (product != null) {
          Navigator.pushNamed(
            context,
            ProductDetailsScreen.routeName,
            arguments: {
              'product': product,
              'deliveryDate': widget.deliveryDate ?? '',
            },
          );
        }
      },
      child: Container(
        height: 180,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Container(
              height: 180,
              width: 160,
              decoration: const BoxDecoration(color: Color(0xffF7F7F7)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      product?.name ?? 'Unnamed Product',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          averageRating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: GlobalVariables.selectedNavBarColor,
                          ),
                        ),
                        Stars(
                          rating: averageRating,
                          size: 20,
                        ),
                        Text(
                          '(${product?.rating?.length ?? 0})',
                          style: productTextStyle.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          '₹',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          price ?? 'N/A',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Get it by ',
                        style: productTextStyle,
                        children: [
                          TextSpan(
                            text: widget.deliveryDate ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff56595A),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Text(
                      'FREE Delivery by Amazon',
                      style: productTextStyle,
                    ),
                    const Text(
                      '7 days Replacement',
                      style: productTextStyle,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
