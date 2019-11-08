
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intelligent_ordering_system/core/config/routes.dart';
import 'package:intelligent_ordering_system/core/models/category.dart';
import 'package:intelligent_ordering_system/core/models/item.dart';
import 'package:intelligent_ordering_system/core/shared/custom_colors.dart';
import 'package:intelligent_ordering_system/core/shared/custom_media.dart';
import 'package:intelligent_ordering_system/core/viewmodel/item_viewmodel.dart';
import 'package:intelligent_ordering_system/ui/views/home/emotion_capture_page.dart';
import 'package:intelligent_ordering_system/ui/views/home/facial_order.dart';
import 'package:intelligent_ordering_system/ui/views/home/image_capture_page.dart';
import 'package:intelligent_ordering_system/ui/widgets/carousel_banner.dart';
import 'package:intelligent_ordering_system/ui/widgets/footer_button.dart';
import 'package:provider/provider.dart';

class Facial extends StatefulWidget {
  Facial({Key key}) : super(key: key);
  _FacialState createState() => _FacialState();
}

class _FacialState extends State<Facial>
    with AutomaticKeepAliveClientMixin<Facial> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (mounted) {}
  }

  @override
  Widget build(BuildContext context) {
    final ItemViewModel itemViewModel = Provider.of<ItemViewModel>(context);

    return Scaffold(
        body: Column(
          children: <Widget>[
            CarouselBanner(),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: CustomMedia.screenHeight * .15,
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(50),
                          ),
                          child: Image.asset(
                            "assets/images/items/others/selfie.jpg",
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Take a selfie",
                        style: Theme.of(context).textTheme.headline.copyWith(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Order meal base on your Facial Expression. Make sure you have internet to process image.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.body1.copyWith(
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
                      title: "Next",
                      func: () => getFacialOrder(),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  void takePicture() {
    Navigator.of(context).pushNamed(Routes.facialcapture);
  }

  void getFacialOrder() async {
    final ItemViewModel itemViewModel = Provider.of<ItemViewModel>(context);
    await itemViewModel.resetCartItemOrder();
    await itemViewModel.filterItem(Category.listCategory[0]);

    Emotion emo = Emotion.NORMAL;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ImageCapturePage();
        },
      ),
    );

    if(result.runtimeType == Emotion && result != null){
      emo = result;
    }

    await itemViewModel.getFacialOrder(emo);
//     Navigator.of(context).pushNamed(Routes.facialorder, emotion: emo);

    Navigator.pushNamed(
      context,
      Routes.facialorder,
      arguments: FacialOrder(emotion: emo),
    );
  }

  cancelOrder() {
    Navigator.of(context).pop();
  }



}
