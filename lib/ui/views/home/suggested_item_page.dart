import 'package:intelligent_ordering_system/core/config/routes.dart';
import 'package:intelligent_ordering_system/core/models/category.dart';
import 'package:intelligent_ordering_system/core/models/item.dart';
import 'package:intelligent_ordering_system/core/shared/custom_colors.dart';
import 'package:intelligent_ordering_system/core/shared/custom_media.dart';
import 'package:intelligent_ordering_system/core/viewmodel/category_viewmodel.dart';
import 'package:intelligent_ordering_system/core/viewmodel/item_viewmodel.dart';
import 'package:intelligent_ordering_system/ui/widgets/carousel_banner.dart';
import 'package:intelligent_ordering_system/ui/widgets/category_button.dart';
import 'package:intelligent_ordering_system/ui/widgets/footer_button.dart';
import 'package:intelligent_ordering_system/ui/widgets/footer_summary.dart';
import 'package:intelligent_ordering_system/ui/widgets/item_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SuggestedImagePage extends StatefulWidget {
  SuggestedImagePage({Key key, this.emotion}) : super(key: key);
  final Emotion emotion;

  _SuggestedImagePageState createState() => _SuggestedImagePageState();
}

class _SuggestedImagePageState extends State<SuggestedImagePage>
    with AutomaticKeepAliveClientMixin<SuggestedImagePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (mounted) {}
  }

  @override
  Widget build(BuildContext context) {
    final CategoryViewModel categoryViewModel =
        Provider.of<CategoryViewModel>(context);

    final ItemViewModel itemViewModel = Provider.of<ItemViewModel>(context);
    itemViewModel.filterItemByEmotion(widget.emotion);

    return Scaffold(
        body: Column(
          children: <Widget>[
            CarouselBanner(),
            Expanded(
              child: GridView.count(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8).copyWith(top: 20),
                crossAxisSpacing: 10,
                crossAxisCount: 2,
                children: itemViewModel.getFilterItems.map((index) {
                  return ItemCard(
                    item: index,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                height: CustomMedia.screenHeight * .17,
                child: new FooterSummary(itemViewModel: itemViewModel)),
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
                      title: "Back",
                      color: CustomColors.red,
                      func: cancelOrder,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: new FooterButton(
                      color: CustomColors.blue,
                      title: "View Order",
                      func: () => viewOrder(),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  setCategory(Category category) {
    final CategoryViewModel categoryViewModel =
        Provider.of<CategoryViewModel>(context);
    final ItemViewModel itemViewModel = Provider.of<ItemViewModel>(context);

    categoryViewModel.setSelectedCategory(category);
    itemViewModel.filterItem(category);
  }

  void viewOrder() {
    print('view order');
    Navigator.of(context).pushNamed(Routes.checkout);
  }

  cancelOrder() {
    Navigator.of(context).pop();
  }
}
