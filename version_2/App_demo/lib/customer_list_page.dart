import 'package:flutter/material.dart';
import 'database_helper.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State<CustomerListPage> createState() =>
      _CustomerListPageState();
}

class _CustomerListPageState
    extends State<CustomerListPage> {

  List<Map<String, dynamic>> customers = [];

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {

    final data =
    await DatabaseHelper.instance.getCustomers();

    setState(() {
      customers = data;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered Customers'),
      ),

      body: ListView.builder(
        itemCount: customers.length,

        itemBuilder: (context, index) {

          return ListTile(
            title: Text(
              customers[index]['name'],
            ),

            subtitle: Text(
              customers[index]['email'],
            ),

            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                Text(
                  '${customers[index]['points']} pts',
                ),

                IconButton(
                  icon: const Icon(Icons.add),

                  onPressed: () async {

                    int newPoints =
                        customers[index]['points'] + 10;

                    await DatabaseHelper.instance
                        .updateCustomerPoints(
                      customers[index]['id'],
                      newPoints,
                    );

                    loadCustomers();
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.delete),

                  onPressed: () async {

                    await DatabaseHelper.instance
                        .deleteCustomer(
                      customers[index]['id'],
                    );

                    loadCustomers();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}