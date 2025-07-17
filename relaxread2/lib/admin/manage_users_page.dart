import 'package:flutter/material.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  List<Map<String, String>> users = [
    {'name': 'Alice Smith', 'email': 'alice.s@example.com', 'role': 'User'},
    {'name': 'Bob Johnson', 'email': 'bob.j@example.com', 'role': 'User'},
    {
      'name': 'Charlie Brown',
      'email': 'charlie.b@example.com',
      'role': 'Admin',
    },
    {'name': 'Diana Prince', 'email': 'diana.p@example.com', 'role': 'User'},
  ];

  void _deleteUser(int index) {
    final deletedUser = users[index]['name'];
    setState(() {
      users.removeAt(index);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$deletedUser deleted')));
  }

  void _editUser(int index) async {
    final user = users[index];
    TextEditingController nameController = TextEditingController(
      text: user['name'],
    );
    TextEditingController emailController = TextEditingController(
      text: user['email'],
    );
    TextEditingController roleController = TextEditingController(
      text: user['role'],
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(labelText: 'Role'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                users[index] = {
                  'name': nameController.text,
                  'email': emailController.text,
                  'role': roleController.text,
                };
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${nameController.text} updated')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Accounts',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(child: Text(user['name']![0])),
                      title: Text(
                        user['name'] ?? 'N/A',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      subtitle: Text(
                        '${user['email']} - ${user['role']}',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editUser(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteUser(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Add New User')));
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Add New User'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B923C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
