import 'package:amazon_clone_flutter/common/widgets/custom_app_bar.dart';
import 'package:amazon_clone_flutter/features/account/services/account_services.dart';
import 'package:amazon_clone_flutter/features/address/screens/address_screen_buy_now.dart';
import 'package:amazon_clone_flutter/providers/cart_offers_provider.dart';
import 'package:carousel_slider/carousel_slider.dart' as cr;
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:amazon_clone_flutter/common/widgets/custom_elevated_button.dart';
import 'package:amazon_clone_flutter/common/widgets/stars.dart';
import 'package:amazon_clone_flutter/features/home/widgets/custom_carousel_slider.dart';
import 'package:amazon_clone_flutter/features/product_details/services/product_details_services.dart';
import 'package:amazon_clone_flutter/providers/user_provider.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../models/product.dart';
import '../../home/services/home_services.dart';
import '../../home/widgets/dots_indicator.dart';
import '../widgets/customer_ratings.dart';
import '../widgets/divider_with_sizedbox.dart';
import '../widgets/product_features.dart';
import '../widgets/product_quality_icons.dart';
import '../widgets/you_might_also_like.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String routeName = '/product-details';

  //final Map<String, dynamic> arguments;
  final Product product;
  final String deliveryDate;

 const ProductDetailsScreen({
  super.key,
  required this.product,
  required this.deliveryDate,
});


  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();

  final AccountServices accountServices = AccountServices();

  final cr.CarouselSliderController controller = cr.CarouselSliderController();
  final HomeServices homeServices = HomeServices();
  List<Product>? categoryProductList;
  int currentIndex = 0;
  bool isOrdered = false;

  double averageRating = 0;
  double userRating = -1;

  String? price;
  String? emi;
  bool isFilled = false;

 getCategoryProducts() async {
  categoryProductList = await homeServices.fetchCategoryProducts(
    context: context,
    category: widget.product.category,               // ✅ FIXED
  );
  categoryProductList!.shuffle();
  setState(() {});
}


  addKeepShoppingForProduct() {
    accountServices.keepShoppingFor(
        context: context, product: widget.product);
    setState(() {});
  }

  getProductRating() async {
    userRating = await productDetailsServices.getRating(
        context: context, product: widget.product);
    if (context.mounted) {
      averageRating = await productDetailsServices.getAverageRating(
          context: context, product: widget.product);
    }
    setState(() {});
  }

 @override
void initState() {
  super.initState();
  getProductRating();
  addKeepShoppingForProduct();
  getCategoryProducts();
  price = formatPrice(widget.product.price ?? 0);         // ✅ FIXED
  emi = getEmi(widget.product);                      // ✅ FIXED
}


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    Product product = widget.product;
    String deliveryDate = widget.deliveryDate;

    final cartCategoryOffer =
        Provider.of<CartOfferProvider>(context, listen: false);

    bool isFavourite = false;

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    String productId = widget.product.id!;

if (productId == null) {
  print("❌ Product ID is null");
}


    for (int i = 0; i < userProvider.user.wishList.length; i++) {
      if (productId == userProvider.user.wishList[i]['product']['_id']) {
        isFavourite = true;
        break;
      }
    }

    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60), child: CustomAppBar()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    const SizedBox(height: 10),
                    CustomCarouselSliderList(
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        sliderImages: widget.product.images),
                    Positioned(
                        bottom: 10,
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: isFavourite == true
                                  ? InkWell(
                                      onTap: () {
                                        accountServices.deleteFromWishList(
                                            context: context,
                                            product:
                                                widget.product);
                                        setState(() {
                                          isFavourite = false;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        accountServices.addToWishList(
                                            context: context,
                                            product:
                                                widget.product);
                                        setState(() {
                                          isFavourite = true;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.favorite_border,
                                        color: Colors.grey,
                                        size: 30,
                                      ),
                                    ),
                            )))
                  ],
                ),
                const SizedBox(height: 10),
                DotsIndicatorList(
                    controller: controller,
                    current: currentIndex,
                    sliderImages: widget.product.images ?? [],

                    ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Visit the Store',
                      style:
                          TextStyle(color: GlobalVariables.selectedNavBarColor),
                    ),
                    Row(
                      children: [
                        Text(averageRating.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87)),
                        const SizedBox(width: 4),
                        Stars(rating: averageRating),
                        const SizedBox(width: 6),
                        Text(
  (widget.product.rating?.length ?? 0).toString(),

                          style: TextStyle(
                            color: GlobalVariables.selectedNavBarColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.product.name,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
            const DividerWithSizedBox(),
            priceEmi(),
            const DividerWithSizedBox(
              sB1Height: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      text: 'Total: ',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      children: [
                        TextSpan(
                          text: '₹$price',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        )
                      ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(
                      text: 'FREE delivery ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: GlobalVariables.selectedNavBarColor,
                      ),
                      children: [
                        TextSpan(
                          text: deliveryDate,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        )
                      ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    user.address == ''
                        ? const SizedBox()
                        : Expanded(
                            child: Text(
                              'Deliver to ${capitalizeFirstLetter(string: user.name)} - ${user.address}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: GlobalVariables.selectedNavBarColor),
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'In stock',
                  style: TextStyle(
                      color: GlobalVariables.greenColor, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomElevatedButton(
                    buttonText: 'Add to Cart',
                    onPressed: () {
                      productDetailsServices.addToCart(
                          context: context,
                          product: widget.product);
                      showSnackBar(context, 'Added to cart!');
                      setState(() {});
                      cartCategoryOffer.setCategory1(
                          widget.product.category.toString());
                    }),
                const SizedBox(
                  height: 10,
                ),
                CustomElevatedButton(
                  buttonText: 'Buy Now',
                  onPressed: () {
                    Navigator.pushNamed(context, AddressScreenBuyNow.routeName,
                        arguments: product);
                  },
                  color: GlobalVariables.secondaryColor,
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Secure transaction',
                      style: TextStyle(
                          color: GlobalVariables.selectedNavBarColor,
                          fontSize: 15),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Gift-wrap available.',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 14),
                InkWell(
                  onTap: () {
                    if (isFavourite == true) {
                      showSnackBar(
                          context, 'This product is already in your wish list');
                    } else {
                      accountServices.addToWishList(
                          context: context,
                          product: widget.product);
                      setState(() {
                        isFavourite = true;
                      });
                      showSnackBar(context, 'Added to wish list!');
                    }
                  },
                  child: Text(
                    'Add to Wish List',
                    style: TextStyle(
                        color: GlobalVariables.selectedNavBarColor,
                        fontSize: 15),
                  ),
                ),
              ],
            ),
            const DividerWithSizedBox(),
            const ProductQualityIcons(),
            const DividerWithSizedBox(
              sB1Height: 4,
              sB2Height: 6,
            ),
          ProductFeatures(product: product),
const DividerWithSizedBox(),
CustomerReviews(
  averageRating: averageRating ?? 0.0,
  product: product.copyWith(
    rating: product.rating ?? [], // safely handle null ratings
  ),
),
const DividerWithSizedBox(),
userRating == -1
    ? const SizedBox()
    : ratingFromUser(context, product),
YouMightAlsoLike(
  categoryProductList: categoryProductList ?? [],
  deliveryDate: deliveryDate ?? '',
),

          ]),
        ),
      ),
    );
  }

  Column ratingFromUser(BuildContext context, Product product) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Your star rating!',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      const SizedBox(height: 10),
      RatingBar.builder(
        itemSize: 28,
        initialRating: userRating?.toDouble() ?? 0.0,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: const EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: GlobalVariables.secondaryColor,
        ),
        onRatingUpdate: (rating) {
          productDetailsServices.rateProduct(
              context: context, product: product, rating: rating);
          setState(() {});
        },
      ),
      const DividerWithSizedBox(),
    ],
  );
}


  Column priceEmi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '₹',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              price ?? 'N/A',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        RichText(
          text: TextSpan(
            text: 'EMI ',
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
            children: [
              TextSpan(
                text: 'from ₹${emi ?? 'N/A'}. No Cost EMI available.',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: ' EMI options',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: GlobalVariables.selectedNavBarColor,
                ),
              ),
            ],
          ),
        ),
        const Text(
          'Inclusive of all texes',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
