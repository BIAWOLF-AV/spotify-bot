import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Импортируйте библиотеку intl

void main() {
  runApp(MyApp());
  DateTime now = DateTime.now();
  String formattedDate = DateFormat.yMMMEd().format(now);
  print(formattedDate);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<FamilyAccount> familyAccounts = [];

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController serviceExpiryDateController = TextEditingController();
  String selectedStatus = 'Пробный период';

  DateTime? selectedDate; // Для хранения выбранной даты

  void _addFamilyAccount() {
    // Проверьте, выбрана ли дата
    if (selectedDate == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ошибка'),
            content: Text(
                'Пожалуйста, выберите дату окончания срока действия услуги.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Получите данные из контроллеров и выбранного значения статуса
    final newAccount = FamilyAccount(
      familyemail: emailController.text,
      trialExpiryDate: DateFormat.yMMMEd().format(selectedDate!),
      status: selectedStatus,
    );
    setState(() {
      familyAccounts.add(newAccount);
    });
    // Очистите поля ввода после добавления аккаунта
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    serviceExpiryDateController.clear();
    // Закройте окно добавления аккаунта
    Navigator.of(context).pop();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family Account Stock'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20.0),
            Text(
              'Список пробных аккаунтов',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Поиск по email',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: familyAccounts.length,
                itemBuilder: (context, index) {
                  final account = familyAccounts[index];
                  return ListTile(
                    title: Text(account.familyemail),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Срок истечения: ${account.trialExpiryDate}'),
                        Text('Статус: ${account.status}'),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Добавление нового аккаунта'),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(labelText: 'Email'),
                            ),
                            TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(labelText: 'Пароль'),
                            ),
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(labelText: 'Имя'),
                            ),
                            TextButton(
                              onPressed: () {
                                _selectDate(
                                    context); // Вызов диалога выбора даты
                              },
                              child: Text(
                                  'Выберите дату окончания срока действия услуги'),
                            ),
                            Text(
                                'Дата: ${selectedDate == null ? "Не выбрана" : DateFormat.yMMMEd().format(selectedDate!)}'),
                            DropdownButton<String>(
                              value: selectedStatus,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedStatus = newValue!;
                                });
                              },
                              items: <String>[
                                'Пробный период',
                                'Завершен',
                                'Продлен',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            _addFamilyAccount();
                          },
                          child: Text('Добавить пользователя'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Отмена'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Добавить новый аккаунт'),
            ),
          ],
        ),
      ),
    );
  }
}

class FamilyAccount {
  final String familyemail;
  final String trialExpiryDate;
  final String status;

  FamilyAccount({
    required this.familyemail,
    required this.trialExpiryDate,
    required this.status,
  });
}
