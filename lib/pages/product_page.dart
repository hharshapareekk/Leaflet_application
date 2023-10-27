import 'package:flutter/material.dart';
import 'package:books/db.dart';
import 'package:books/styles.dart';

class ProductPage extends StatelessWidget {
  final Book book;
  const ProductPage({super.key, required this.book});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
        body: CustomScrollView(slivers: [
      const SliverAppBar(
        title: SearchBar(trailing: [Icon(Icons.search)]),
      ),
      SliverList.list(children: [
        Module(
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RoundedWidget(child: Image(height: 200, image: AssetImage(book.cover))),
                  Expanded(
                    child: Column(
                      children: [
                        ListTile(
                            title: Text(book.title),
                            leading: const Icon(Icons.local_library)),
                        ListTile(
                            title: Text(book.author),
                            leading: const Icon(Icons.face)),
                        ListTile(
                            title: Text("${book.sellers[0].addedOn}"),
                            leading: const Icon(Icons.calendar_today)),
                        ListTile(
                            title: Text("${book.rating}"),
                            leading: const Icon(Icons.star)),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                      book.sellers.length > 1
                          ? "₹ ${book.sellers[0].cost} onwards"
                          : "₹ ${book.sellers[0].cost}",
                      style: Styles.title),
                  const Spacer(flex: 1),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.shopping_cart_outlined),
                      color: colors.primary),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.shopping_bag_outlined),
                      color: colors.primary),
                ],
              ),
            ],
          ),
        ),
        DescriptionBox(book: book),
        SellerView(sellers: book.sellers, colors: colors),
      ])
    ]));
  }
}

class DescriptionBox extends StatefulWidget {
  DescriptionBox({
    super.key,
    required this.book,
  });

  bool flag = false;
  static const int maxLines = 8;
  final Book book;

  @override
  State<DescriptionBox> createState() => _DescriptionBoxState();
}

class _DescriptionBoxState extends State<DescriptionBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Description", style: Styles.title)),
        GestureDetector(
            onTap: () {
              setState(() {
                widget.flag = !widget.flag;
              });
            },
            child: Module(
                child: Text(widget.book.desc, overflow: TextOverflow.fade,
                    maxLines: widget.flag ? null : DescriptionBox.maxLines))),
      ],
    );
  }
}

class SellerView extends StatefulWidget {
  SellerView({
    super.key,
    required this.sellers,
    required this.colors,
  });

  final List<Seller> sellers;
  final ColorScheme colors;
  int index = 0;

  @override
  State<SellerView> createState() => _SellerViewState();
}

class _SellerViewState extends State<SellerView> {
  @override
  Widget build(BuildContext context) {
    Seller seller = widget.sellers[widget.index];
    final int sellersLen = widget.sellers.length - 1;
    final colors = widget.colors;
    return Column(
      children: [
        const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Sellers", style: Styles.title)),
        Module(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              RoundedWidget(
                child: SizedBox(
                  height: 150,
                  child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: seller.images
                          .map((uri) => Image(image: AssetImage(uri)))
                          .toList()),
                ),
              ),
              GestureDetector(
                  child: Column(children: [
                    GridView(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, mainAxisExtent: 50),
                      children: [
                        ListTile(
                            leading: const Icon(Icons.verified_user),
                            title: Text(seller.name)),
                        ListTile(
                            leading: const Icon(Icons.calendar_today),
                            title: Text("${seller.addedOn}")),
                        ListTile(
                            leading: const Icon(Icons.star),
                            title: Text("${seller.rating}")),
                        ListTile(
                            leading: const Icon(Icons.location_pin),
                            title: Text("${seller.loc}")),
                      ],
                    ),
                    Row(
                      children: [
                        Text("₹ ${seller.cost}", style: Styles.title),
                        const Spacer(flex: 1),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.shopping_cart_outlined),
                            color: colors.primary),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.shopping_bag_outlined),
                            color: colors.primary),
                      ],
                    ),
                  ]),
                  onHorizontalDragUpdate: (details) {
                    if (details.delta.dx > 20) {
                      if (widget.index < sellersLen) {
                        setState(() {
                          widget.index++;
                        });
                      }
                    } else if (details.delta.dx < -20) {
                      if (widget.index > 0) {
                        setState(() {
                          widget.index--;
                        });
                      }
                    }
                  }),
            ])),
      ],
    );
  }
}
