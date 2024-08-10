import 'package:adoptr/model/pet.dart';
import 'package:adoptr/pages/add.dart';
import 'package:adoptr/pages/details.dart';
import 'package:adoptr/repo/dbrepo.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {
  final PetsDarabaseRepository repository;
  const ListPage({Key? key, required this.repository}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();

    //fetch data from API
  }

  getData() async {
    // pets=
  }

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetsDarabaseRepository>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 192, 173),
      body: ListView.builder(
        itemCount: petProvider.pets.length,
        itemBuilder: (context, index) {
          Pet pet = petProvider.pets[index];
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(pet: pet),
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 39, 28, 25),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    width: 400,
                    height: 100,
                  ),
                  Positioned(
                    left: 18,
                    top: 9,
                    child: Row(
                      children: [
                        const SizedBox(width: 40),
                        Transform.translate(
                          offset: const Offset(0, -5),
                          child: Column(
                            children: [
                              Text(
                                pet.name,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 254),
                                  fontSize: 20.0,
                                ),
                              ),
                              Transform.translate(
                                offset: const Offset(0, -7),
                                child: Text(
                                  pet.type,
                                  style: const TextStyle(
                                    color: Color.fromARGB(210, 255, 255, 254),
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                              Transform.translate(
                                offset: const Offset(0, 3),
                                child: Text(
                                  pet.location,
                                  style: const TextStyle(
                                    color: Color.fromARGB(210, 255, 255, 254),
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 220,
                    top: 25,
                    child: Text(
                      "• breed: " + pet.breed,
                      style: const TextStyle(
                        color: Color.fromARGB(210, 255, 255, 254),
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 220,
                    top: 55,
                    child: Text(
                      "• age: " + pet.age.toString(),
                      style: const TextStyle(
                        color: Color.fromARGB(210, 255, 255, 254),
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      //}
      //}),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPage(),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 255, 255, 254),
        foregroundColor: const Color.fromARGB(255, 39, 28, 25),
        child: const Icon(Icons.add),
      ),
    );
  }
}
