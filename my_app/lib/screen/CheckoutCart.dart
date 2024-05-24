import 'package:flutter/material.dart';
import '../model/Item.dart';
import "package:provider/provider.dart";
import "../provider/shoppingcart_provider.dart";

class CheckoutCart extends StatelessWidget {
  const CheckoutCart({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          getItems(context),
          getItems(context).runtimeType == Align // it means the retrieved from getItems is the Align with Text('No Items to Checkout!')
              ? const SizedBox()
              : SizedBox(
                  height: 150,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        computeCost(),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ShoppingCart>().removeAll();
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Payment Successful!"),
                              duration: Duration(seconds: 1, milliseconds: 100),
                            ));
                            Navigator.pushNamed(context, "/products");
                          },
                          child: const Text("Pay Now"),
                        ),
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Widget getItems(BuildContext context) {
    List<Item> products = context.watch<ShoppingCart>().cart;
    return products.isEmpty
        ? const Align(
            alignment: Alignment.topCenter,
            child: Text('No Items to Checkout!'),
          )
        : Expanded(
            child: Column(
            children: [
              const ListTile(
                title: Row(children: [
                  Expanded(
                    child: Text(
                      "Item Name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Price",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  )
                ]),
              ),
              Flexible(
                  child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Row(children: [
                      Expanded(
                        child: Text(
                          products[index].name,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          products[index].price.toString(),
                          textAlign: TextAlign.right,
                        ),
                      )
                    ]),
                  );
                },
              )),
            ],
          ));
  }

  Widget computeCost() {
    return Consumer<ShoppingCart>(builder: (context, cart, child) {
      return ListTile(
        title: Row(children: [
          const Expanded(
            child: Text(
              "Total Amount to Pay: ",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: Text(
              "${cart.cartTotal}",
              style: const TextStyle(fontWeight: FontWeight.normal),
              textAlign: TextAlign.right,
            ),
          )
        ]),
      );
    });
  }
}
