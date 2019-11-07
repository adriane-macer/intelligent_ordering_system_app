import 'package:intelligent_ordering_system/core/models/base_model.dart';
import 'package:intelligent_ordering_system/core/models/category.dart';

class CategoryViewModel extends BaseModel {
  Category _selectedCategory = Category.listCategory[0];

  Category get getSelectedCategory => _selectedCategory;

  setSelectedCategory(Category category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
