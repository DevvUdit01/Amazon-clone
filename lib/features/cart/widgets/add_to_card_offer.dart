import 'package:amazon_clone_flutter/common/widgets/stars.dart';
import 'package:flutter/material.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../models/product.dart';

class AddToCartOffer extends StatefulWidget {
  const AddToCartOffer({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<AddToCartOffer> createState() => _AddToCartOfferState();
}

String? price;

class _AddToCartOfferState extends State<AddToCartOffer> {
  String? price;
  double averageRating = 0;

  @override
  void initState() {
    super.initState();

    if (widget.product.price != null) {
      price = formatPrice(widget.product.price!);
    }

    if (widget.product.rating != null && widget.product.rating!.isNotEmpty) {
      double totalRating = 0;
      for (int i = 0; i < widget.product.rating!.length; i++) {
        totalRating += widget.product.rating![i].rating;
      }
      averageRating = totalRating / widget.product.rating!.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = (widget.product.images.isNotEmpty)
        ? widget.product.images[0]
        : 'https://via.placeholder.com/130';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                navigateToProductDetails(
                  context: context,
                  product: widget.product,
                  deliveryDate: getDeliveryDate(),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      imageUrl,
                      height: 130,
                      width: 130,
                    ),
                  ),
                  Text(
                    widget.product.name,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: GlobalVariables.selectedNavBarColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      Stars(
                        rating: averageRating,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.product.rating?.length.toString() ?? '0',
                        style: TextStyle(
                          color: GlobalVariables.selectedNavBarColor,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    price != null ? '₹$price.00' : 'No Price',
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xffB12704),
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                addToCart(context, widget.product);
              },
              style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.zero),
                minimumSize: MaterialStatePropertyAll(Size(100, 35)),
                maximumSize: MaterialStatePropertyAll(Size(100, 35)),
                fixedSize: MaterialStatePropertyAll(Size(100, 35)),
                backgroundColor:
                    MaterialStatePropertyAll(GlobalVariables.yellowColor),
              ),
              child: const Text(
                'Add to Cart',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.normal),
              ),
            )
          ],
        ),
      ),
    );
  }
}
