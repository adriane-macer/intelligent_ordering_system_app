import 'package:intelligent_ordering_system/core/config/routes.dart';
import 'package:intelligent_ordering_system/core/models/category.dart';
import 'package:intelligent_ordering_system/core/shared/custom_colors.dart';
import 'package:intelligent_ordering_system/core/shared/custom_media.dart';
import 'package:intelligent_ordering_system/core/viewmodel/category_viewmodel.dart';
import 'package:intelligent_ordering_system/core/viewmodel/item_viewmodel.dart';
import 'package:intelligent_ordering_system/ui/widgets/carousel_banner.dart';
import 'package:intelligent_ordering_system/ui/widgets/checkout_card.dart';
import 'package:intelligent_ordering_system/ui/widgets/footer_button.dart';
import 'package:intelligent_ordering_system/ui/widgets/footer_summary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CheckOut extends StatefulWidget {
  CheckOut({Key key}) : super(key: key);
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut>
    with AutomaticKeepAliveClientMixin<CheckOut> {
  @override
  bool get wantKeepAlive => true;

  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      // getCheckOutItems
    }
  }

  @override
  Widget build(BuildContext context) {
    final ItemViewModel itemViewModel = Provider.of<ItemViewModel>(context);
    pr = new ProgressDialog(context);

    return Scaffold(
        body: Column(
          children: <Widget>[
            new CarouselBanner(),
            Expanded(
              child: ListView.builder(
                itemCount: itemViewModel.getCheckOutItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return CheckOutCard(
                    item: itemViewModel.getCheckOutItems[index],
                  );
                },
              ),
            )
          ],
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: CustomMedia.screenHeight * .10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new FooterSummary(itemViewModel: itemViewModel)
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: new FooterButton(
                      title: "Cancel",
                      color: CustomColors.red,
                      func: calcelCheckOut,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: new FooterButton(
                      color: CustomColors.blue,
                      title: "Proceed to Checkout",
                      func: itemViewModel.getCheckOutItems.length >= 1
                          ? () => proceedCheckOut()
                          : null,
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  calcelCheckOut() {
    Navigator.of(context).pop();
  }

  proceedCheckOut() async {
    pr.show();

    await Future.delayed(Duration(seconds: 1));

    final CategoryViewModel categoryViewModel =
        Provider.of<CategoryViewModel>(context);
    categoryViewModel.setSelectedCategory(Category.listCategory[0]);

    final ItemViewModel itemViewModel = Provider.of<ItemViewModel>(context);
    await itemViewModel.resetCartItemOrder();
    await itemViewModel.filterItem(Category.listCategory[0]);

    pr.hide();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(Routes.end, (Route<dynamic> route) => false);
  }
}
