import 'package:e_commerce_app_flutter/components/top_rounded_container.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/screens/product_details/components/product_description.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../size_config.dart';

class ProductActionsSection extends StatefulWidget {
  final Product product;

  const ProductActionsSection({
    Key key,
    @required this.product,
  }) : super(key: key);
  @override
  _ProductActionsSectionState createState() => _ProductActionsSectionState();
}

class _ProductActionsSectionState extends State<ProductActionsSection> {
  bool productFavStatus = false;
  bool initProductFavStatus = false;

  @override
  void initState() {
    UserDatabaseHelper().isProductFavourite(widget.product.id).then((value) {
      setState(() {
        productFavStatus = initProductFavStatus = value;
      });
    });
    super.initState();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    if (productFavStatus != initProductFavStatus) {
      await UserDatabaseHelper()
          .switchProductFavouriteStatus(widget.product.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            TopRoundedContainer(
              child: ProductDescription(product: widget.product),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: buildFavouriteButton(),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildFavouriteButton() {
    return InkWell(
      onTap: () async {
        setState(() {
          productFavStatus ^= true;
        });
      },
      child: Container(
        padding: EdgeInsets.all(getProportionateScreenWidth(8)),
        width: getProportionateScreenWidth(64),
        decoration: BoxDecoration(
          color: productFavStatus ? Color(0xFFFFE6E6) : Color(0xFFF5F6F9),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Padding(
          padding: EdgeInsets.all(getProportionateScreenWidth(8)),
          child: SvgPicture.asset(
            "assets/icons/Heart Icon_2.svg",
            color: productFavStatus ? Color(0xFFFF4848) : Color(0xFFD8DEE4),
          ),
        ),
      ),
    );
  }
}
