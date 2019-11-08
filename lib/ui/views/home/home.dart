import 'package:intelligent_ordering_system/core/config/routes.dart';
import 'package:intelligent_ordering_system/core/models/category.dart';
import 'package:intelligent_ordering_system/core/models/item.dart';
import 'package:intelligent_ordering_system/core/shared/custom_colors.dart';
import 'package:intelligent_ordering_system/core/shared/custom_media.dart';
import 'package:intelligent_ordering_system/core/shared/custom_text_styles.dart';
import 'package:intelligent_ordering_system/core/viewmodel/category_viewmodel.dart';
import 'package:intelligent_ordering_system/core/viewmodel/item_viewmodel.dart';
import 'package:intelligent_ordering_system/ui/views/home/emotion_capture_page.dart';
import 'package:intelligent_ordering_system/ui/views/home/image_capture_page.dart';
import 'package:intelligent_ordering_system/ui/widgets/CarouselBanner.dart';
import 'package:intelligent_ordering_system/ui/widgets/category_button.dart';
import 'package:intelligent_ordering_system/ui/widgets/footer_button.dart';
import 'package:intelligent_ordering_system/ui/widgets/item_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  @override
  bool get wantKeepAlive => true;
  Emotion _emotion;

  @override
  void initState() {
    super.initState();
    if (mounted) {}
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    //   statusBarColor: Colors.white,
    // ));

    final CategoryViewModel categoryViewModel =
        Provider.of<CategoryViewModel>(context);

    final ItemViewModel itemViewModel = Provider.of<ItemViewModel>(context);

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
                    img: index.image,
                    title: index.name,
                    category: index.category,
                    price: index.price,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      height: CustomMedia.screenHeight * .06,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: Category.listCategory.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CategoryButton(
                                active: categoryViewModel.getSelectedCategory ==
                                        Category.listCategory[index]
                                    ? true
                                    : false,
                                title: Category.listCategory[index].name,
                                func: () async {
                                  if (Category.listCategory[index].name ==
                                      "ai suggestion") {
                                    if (_emotion != null) {
                                      final result =
                                          await _recaptureConfirmationDialog(
                                              context);
                                      if (!result)
                                        return setCategory(
                                            Category.listCategory[index],
                                            emotion: _emotion);
                                    }

                                    final result =
                                        await captureEmotion(context);
                                    if (result.runtimeType == Emotion &&
                                        result != null) {
                                      _emotion = result;
                                      return setCategory(
                                          Category.listCategory[index],
                                          emotion: result);
                                    }
                                  }
                                  return setCategory(
                                      Category.listCategory[index]);
                                }),
                          );
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Summary',
                              style: Theme.of(context).textTheme.caption),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('4 Items',
                                  style: Theme.of(context).textTheme.subhead),
                              Text('Total 533.53',
                                  style: Theme.of(context).textTheme.subhead)
                            ],
                          )
                        ],
                      ),
                    ),
                  )
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

  setCategory(Category category, {Emotion emotion}) {
    final CategoryViewModel categoryViewModel =
        Provider.of<CategoryViewModel>(context);
    final ItemViewModel itemViewModel = Provider.of<ItemViewModel>(context);

    categoryViewModel.setSelectedCategory(category);
    itemViewModel.filterItem(category, emotion: emotion);
  }

  void viewOrder() {
    print('view order');
    Navigator.of(context).pushNamed(Routes.checkout);
  }

  cancelOrder() {
    // Navigator.of(context).pushNamed(Routes.checkout);
  }

  Future<Emotion> captureEmotion(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
//          return ImageCapturePage();
        return EmotionCapturePage();
        },
      ),
    );

    if (result.runtimeType == Emotion) {
      return result;
    }
    return null;
  }

  _recaptureConfirmationDialog(context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "There is a previous captured emotion.",
                  style: CustomTextStyle.body2.copyWith(color: CustomColors.blue),
                ),
                Text(
                  "\nDo you want to capture again?",
                  style: CustomTextStyle.body2.copyWith(color: CustomColors.blue),
                ),
              ],
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      ),
    );
  }
}
