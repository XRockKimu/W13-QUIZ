import 'package:flutter/material.dart';
import '../../data/mock_grocery_repository.dart';
import '../../models/grocery.dart';
import 'grocery_form.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void onCreate() async {
    // Navigate to the form screen using the Navigator push
    Grocery? newGrocery = await Navigator.push<Grocery>(
      context,
      MaterialPageRoute(builder: (context) => const GroceryForm()),
    );
    if (newGrocery != null) {
      setState(() {
        dummyGroceryItems.add(newGrocery);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));

    final filteredItems = dummyGroceryItems
        .where((item) => item.name.toLowerCase().startsWith(_filter.toLowerCase()))
        .toList();

    if (dummyGroceryItems.isNotEmpty) {
      //  Display groceries with an Item builder and  LIst Tile
      content = ListView.builder(
        itemCount: dummyGroceryItems.length,
        itemBuilder: (context, index) =>
            GroceryTile(grocery: dummyGroceryItems[index]),
      );
    }

    Widget filteredContent = const Center(child: Text('No items match your search.'));

    if (filteredItems.isNotEmpty) {
      filteredContent = ListView.builder(
        itemCount: filteredItems.length,
        itemBuilder: (context, index) =>
            GroceryTile(grocery: filteredItems[index]),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: onCreate, icon: const Icon(Icons.add))],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          content,
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search by name',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _filter = value;
                    });
                  },
                ),
              ),
              Expanded(child: filteredContent),
            ],
          ),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(icon: Icon(Icons.local_grocery_store )),
          Tab(icon: Icon(Icons.search)),
        ],
      ),
    );
  }
}

class GroceryTile extends StatelessWidget {
  const GroceryTile({super.key, required this.grocery});

  final Grocery grocery;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(width: 15, height: 15, color: grocery.category.color),
      title: Text(grocery.name),
      trailing: Text(grocery.quantity.toString()),
    );
  }
}
