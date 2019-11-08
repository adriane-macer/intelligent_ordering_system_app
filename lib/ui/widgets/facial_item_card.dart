
import 'package:flutter/material.dart';
import 'package:intelligent_ordering_system/core/models/item.dart';
import 'package:intelligent_ordering_system/core/shared/custom_colors.dart';
import 'package:intelligent_ordering_system/core/shared/custom_media.dart';
import 'package:intelligent_ordering_system/core/viewmodel/item_viewmodel.dart';
import 'package:provider/provider.dart';


class FacialItemCard extends StatefulWidget {
  Item item;

  FacialItemCard({
    @required this.item,
    Key key,
  }) : super(key: key);

  @override
  _FacialItemCardState createState() => _FacialItemCardState();
}

class _FacialItemCardState extends State<FacialItemCard> {
  @override
  Widget build(BuildContext context) {
    final ItemViewModel itemViewModel = Provider.of<ItemViewModel>(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 3, left: 8, right: 8),
      child: Card(
        child: Container(
          width: CustomMedia.screenWidth,
          height: CustomMedia.screenHeight * .10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      width: CustomMedia.screenWidth * .20,
                      height: 70,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "${widget.item.image}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: CustomMedia.screenWidth * .65,
                      height: 70,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    ' ${widget.item.orderQty}X ${widget.item.name}',
                                    style: Theme.of(context).textTheme.body2,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                Text(
                                  '${widget.item.price}',
                                  style: Theme.of(context).textTheme.subhead,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  '${widget.item.price * widget.item.orderQty}',
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .copyWith(color: CustomColors.red),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Text(
                                  'Total',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
