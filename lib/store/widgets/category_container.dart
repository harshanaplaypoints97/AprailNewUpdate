import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/controllers/categor_controller.dart';
import 'package:play_pointz/controllers/upcomming_items_controller.dart';
import 'package:play_pointz/store/widgets/category_loardig_widget.dart';

import 'package:play_pointz/widgets/store/category_btn.dart';

class CategoryContainer extends StatefulWidget {
  final CategoryController categoryController;
  final ItemController itemController;
  final VoidCallback callback;
  final VoidCallback getCurrentTime;
  final Function(String currentCategory) setCurrentCategory;
  final Function itemLoading;
  final bool changeable;
  const CategoryContainer({
    Key key,
    this.categoryController,
    this.itemController,
    this.callback,
    this.setCurrentCategory,
    this.itemLoading,
    this.getCurrentTime,
    this.changeable,
  }) : super(key: key);

  @override
  State<CategoryContainer> createState() => _CategoryContainerState();
}

class _CategoryContainerState extends State<CategoryContainer> {
  String categoryText = 'Browse All';
  double position = 0.0;
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      child: widget.categoryController.categories.isEmpty
          ? Container(
              margin: const EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) => CategoryLoadingWidget())
                      .toList()),
            )
          : Column(
              children: [
                Container(
                  constraints: BoxConstraints(minHeight: 80, maxHeight: 100),
                  child: ListView.builder(
                    itemCount: widget.categoryController.categories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, index) {
                      return Column(
                        children: <Widget>[
                          index == 0
                              ? Row(
                                  children: [
                                    IgnorePointer(
                                      ignoring: !widget.changeable,
                                      child: categoryBtn(
                                          interactable: !widget.changeable,
                                          categoryIcon:
                                              '$baseUrl/assets/images/all_categories.png',
                                          ontaped: () async {
                                            widget.getCurrentTime();
                                            widget.setCurrentCategory("all");
                                            widget.itemController.otherItems
                                                .clear();
                                            widget.callback();
                                            setState(() {
                                              categoryText = "Browse All";
                                              position = 0.0;
                                            });
                                            await widget.itemController
                                                .fethcUpCommingItems(
                                                    category: "all")
                                                .then(
                                                    (value) => setState(() {}));
                                            widget.itemController
                                                .filterItems("all");
                                            widget.itemLoading();
                                            widget.callback();
                                          },
                                          selected: categoryText,
                                          title: "Browse All"),
                                    ),
                                    IgnorePointer(
                                      ignoring: !widget.changeable,
                                      child: categoryBtn(
                                          interactable: !widget.changeable,
                                          categoryIcon: widget
                                              .categoryController
                                              .categories[index]
                                              .imageUrl,
                                          ontaped: widget.changeable
                                              ? () async {
                                                  widget.getCurrentTime();
                                                  widget.setCurrentCategory(
                                                      widget
                                                          .categoryController
                                                          .categories[index]
                                                          .id);
                                                  widget
                                                      .itemController.otherItems
                                                      .clear();
                                                  widget.callback();
                                                  setState(() {
                                                    categoryText = widget
                                                        .categoryController
                                                        .categories[index]
                                                        .name;
                                                    position = 1.0;
                                                  });
                                                  await widget.itemController
                                                      .fethcUpCommingItems(
                                                          category: widget
                                                              .categoryController
                                                              .categories[index]
                                                              .id)
                                                      .then((value) =>
                                                          setState(() {}));
                                                  widget.itemController
                                                      .filterItems(widget
                                                          .categoryController
                                                          .categories[index]
                                                          .id);
                                                  widget.itemLoading();
                                                  widget.callback();
                                                }
                                              : () {},
                                          selected: categoryText,
                                          title: widget.categoryController
                                              .categories[index].name
                                              .toString()),
                                    )
                                  ],
                                )
                              : IgnorePointer(
                                  ignoring: !widget.changeable,
                                  child: categoryBtn(
                                      interactable: !widget.changeable,
                                      categoryIcon: widget.categoryController
                                          .categories[index].imageUrl,
                                      ontaped: widget.changeable
                                          ? () async {
                                              widget.getCurrentTime();
                                              widget.setCurrentCategory(widget
                                                  .categoryController
                                                  .categories[index]
                                                  .id);
                                              widget.itemController.otherItems
                                                  .clear();
                                              widget.callback();
                                              setState(() {
                                                categoryText = widget
                                                    .categoryController
                                                    .categories[index]
                                                    .name;
                                                position = index.toDouble() + 1;
                                              });
                                              await widget.itemController
                                                  .fethcUpCommingItems(
                                                      category: widget
                                                          .categoryController
                                                          .categories[index]
                                                          .id)
                                                  .then((value) =>
                                                      setState(() {}));
                                              widget.itemController.filterItems(
                                                  widget.categoryController
                                                      .categories[index].id);
                                              widget.itemLoading();
                                              widget.callback();
                                            }
                                          : () {},
                                      selected: categoryText,
                                      title: widget.categoryController
                                          .categories[index].name),
                                ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 40.h,
                  width: MediaQuery.of(context).size.width,
                  child: DotsIndicator(
                    dotsCount: widget.categoryController.categories.length + 1,
                    position: position,
                  ),
                ),
              ],
            ),
    );
  }
}
