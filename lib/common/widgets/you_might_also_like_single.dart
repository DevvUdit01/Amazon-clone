import 'package:amazon_clone_flutter/common/widgets/stars.dart';
import 'package:flutter/material.dart';
import '../../constants/global_variables.dart';
import '../../constants/utils.dart';
import '../../models/product.dart';

class YouMightAlsoLikeSingle extends StatefulWidget {
  const YouMightAlsoLikeSingle({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<YouMightAlsoLikeSingle> createState() => _YouMightAlsoLikeSingleState();
}

String? price;

class _YouMightAlsoLikeSingleState extends State<YouMightAlsoLikeSingle> {
  @override
  void initState() {
    super.initState();
    price = formatPrice(widget.product.price);
  }

  @override
Widget build(BuildContext context) {
  double totalRating = 0;
  final ratings = widget.product.rating ?? [];

  for (int i = 0; i < ratings.length; i++) {
    totalRating += ratings[i].rating;
  }

  double averageRating = ratings.isNotEmpty ? totalRating / ratings.length : 0;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 6),
    padding: const EdgeInsets.symmetric(horizontal: 4),
    width: 130,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.network(
            widget.product.images.isNotEmpty
                ? widget.product.images[0]
                : 'https://via.placeholder.com/130', // fallback image
            height: 130,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
          ),
        ),
        Text(
          widget.product.name ?? 'Unnamed',
          maxLines: 2,
          style: TextStyle(
            fontSize: 16,
            color: GlobalVariables.selectedNavBarColor,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Stars(
          rating: averageRating,
          size: 18,
        ),
        Text(
          '${ratings.length} reviews',
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          '₹${price ?? 'N/A'}.00',
          maxLines: 2,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xffB12704),
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
}