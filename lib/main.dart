import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int cartCount = 0;
  String searchText = "";

  List<String> cartItems = [];

  final products = [
    {
      "name": "Kulaklık",
      "image": "assets/images/kulaklik.png",
      "price": "750 TL"
    },
    {
      "name": "Telefon",
      "image": "assets/images/telefon.png",
      "price": "15000 TL"
    },
    {
      "name": "Laptop",
      "image": "assets/images/laptop.png",
      "price": "25000 TL"
    },
    {
      "name": "Saat",
      "image": "assets/images/saat.jpg"
,
      "price": "2000 TL"
    },
  ];

  @override
  Widget build(BuildContext context) {
    var filteredProducts = products.where((product) {
      return product["name"]!
          .toLowerCase()
          .contains(searchText.toLowerCase());
    }).toList();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Mini Katalog"),
          actions: [
            IconButton(
              icon: Text(
                "🛒 $cartCount",
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CartPage(
                      items: cartItems,
                    ),
                  ),
                );
              },
            )
          ],
        ),

        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Ürün ara...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
              ),
            ),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPage(
                            product: filteredProducts[index],
                            onAdd: () {
                              setState(() {
                                cartCount++;

                                cartItems.add(
                                  filteredProducts[index]["name"]!,
                                );
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            filteredProducts[index]["image"]!,
                            width: 80,
                            height: 80,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            filteredProducts[index]["name"]!,
                          ),
                          Text(
                            filteredProducts[index]["price"]!,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Map product;
  final VoidCallback onAdd;

  const DetailPage({
    super.key,
    required this.product,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product["name"]),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Image.asset(
              product["image"],
              width: 200,
            ),
            const SizedBox(height: 20),
            Text(
              product["name"],
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(product["price"]),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                onAdd();

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content:
                        Text("Sepete eklendi"),
                  ),
                );
              },
              child:
                  const Text("Sepete Ekle"),
            )
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<String> items;

  const CartPage({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sepet"),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
          );
        },
      ),
    );
  }
}