import 'package:flutter/material.dart';
import 'package:flutter_application_2/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItems extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  CartItems(this.id, this.productId, this.price, this.quantity, this.title);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(
          productId,
        );
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('are you sure?'),
            content: Text('do you want to remove the item from the'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text('no'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('yes'),
              ),
            ],
          ),
        );
      },
      child: Card(
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
          child: Padding(
              padding: EdgeInsets.all(10),
              child: ListTile(
                leading: CircleAvatar(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: FittedBox(
                      child: Text('\$price'),
                    ),
                  ),
                ),
                title: Text(title),
                subtitle: Text('Total: \$${(price * quantity)}'),
                trailing: Text('$quantity x'),
              ))),
    );
  }
}
