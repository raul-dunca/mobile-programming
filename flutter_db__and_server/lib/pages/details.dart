import 'package:adoptr/model/pet.dart';
import 'package:adoptr/pages/update.dart';
import 'package:adoptr/repo/dbrepo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  final Pet pet;

  DetailPage({required this.pet});

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetsDarabaseRepository>(context);

    void delete_pet(int? id) {
      try {
        petProvider.removet(id);
      } catch (e) {
        throw Exception('$e');
      }
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 192, 173),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 250,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/image.webp'),
                  //        image: pet.image.image,
                  fit: BoxFit.cover,
                ),
              ),
              child: Transform.translate(
                offset: const Offset(0, -5),
                child: Row(children: [
                  Transform.translate(
                    offset: const Offset(0, 5),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          size: 40,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdatePage(
                                pet: pet,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(275, 0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 55,
                        ),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Center(
              child: Text(
                pet.name,
                style: const TextStyle(
                  fontSize: 34,
                  color: Color.fromARGB(255, 255, 255, 254),
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -12),
              child: Center(
                child: Text(
                  pet.type,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(210, 255, 255, 254),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Details",
                style: TextStyle(
                  fontSize: 28,
                  color: Color.fromARGB(255, 255, 255, 254),
                ),
              ),
            ),
            Center(
              child: Text(
                "Breed: " + pet.breed,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(210, 255, 255, 254),
                ),
              ),
            ),
            Center(
              child: Text(
                "Age: " + pet.age.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(210, 255, 255, 254),
                ),
              ),
            ),
            Center(
              child: Text(
                "Gender: " + pet.gender,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(210, 255, 255, 254),
                ),
              ),
            ),
            Center(
              child: Text(
                "Location: " + pet.location,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(210, 255, 255, 254),
                ),
              ),
            ),
            Center(
              child: Text(
                "Contact: " + pet.contact,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(210, 255, 255, 254),
                ),
              ),
            ),
            const SizedBox(height: 35),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: const Text(
                            'Are you sure you want to delete this?',
                            style: TextStyle(fontSize: 16)),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          SizedBox(width: 135),
                          TextButton(
                            onPressed: () {
                              try {
                                delete_pet(pet.id);
                                Navigator.of(context).pop();
                                Navigator.pop(context, true);
                              } catch (e) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text(
                                        'Error updating pet: $e',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: const Text('Delete',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 175, 56, 56))),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size.fromHeight(70),
                  backgroundColor: const Color.fromARGB(255, 175, 56, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Color.fromARGB(225, 255, 255, 254),
                    fontSize: 20.0,
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
