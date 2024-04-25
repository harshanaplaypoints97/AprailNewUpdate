import 'package:get/get.dart';

class RegisterPageIndexController extends GetxController {
  RxInt activeIndex = RxInt(0);

  //set index
  void setIndex(int index) {
    activeIndex = RxInt(index);
    update();
  }
}
