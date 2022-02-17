import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/uder_product_item.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product';
  Future<void>_refreshProducts()async{
   await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }
  
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(' your products'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator( 
        onRefresh:()=> _refreshProducts(context),
     child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (_, i) => UserProductItem(
              productData.items[i].id,
              productData.items[i].title, productData.items[i].imageUrl),
          itemCount: productData.items.length,
        ),
      ),
      ),
    );
  }
}
