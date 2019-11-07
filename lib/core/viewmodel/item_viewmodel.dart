import 'package:intelligent_ordering_system/core/models/base_model.dart';
import 'package:intelligent_ordering_system/core/models/category.dart';
import 'package:intelligent_ordering_system/core/models/item.dart';

class ItemViewModel extends BaseModel {
  List<Item> _filterItems = Item.listServices;

  List<Item> get getAllItems => Item.listServices;

  List<Item> get getFilterItems => _filterItems;

  filterItem(Category category, {Emotion emotion}) async {
    if (category.name == "All") {
      _filterItems = getAllItems;
    } else if (emotion != null) {
      _filterItems = [];
      getAllItems.forEach((val) {
        if(val.emotion == emotion)
          _filterItems.add(val);
      });
    } else {
      _filterItems = [];
      getAllItems.forEach((val) {
        val.category.forEach((cat) {
          if (cat.name == category.name) {
            _filterItems.add(val);
          }
        });
      });
    }
    notifyListeners();
  }
}
