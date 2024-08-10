// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:adoptr/model/pet.dart';
// import 'package:adoptr/repo/db_helper.dart';
// import 'package:logger/logger.dart';
// import 'dart:async';
// import 'package:connectivity/connectivity.dart';
// import 'package:web_socket_channel/io.dart';

// class PetsRemoteDatabaseRepository with ChangeNotifier {
//   List<Pet> pets = [];
//   final DatabaseRepo _databaseHelper = DatabaseRepo.instance;
//   final Logger logger = Logger();
//   final channel = IOWebSocketChannel.connect('ws://10.0.2.2:2320/');

//   PetsRemoteDatabaseRepository() {
//     _initPets();
//   }

//   Future<void> _initPets() async {
//     logger.d('Initializing pets');
//     //List<Pet> localPets = await _databaseHelper.readAllPets();
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       logger.d('innit without network');
//       pets = await _databaseHelper.readAllPets();
//       notifyListeners();
//     } else {
//       logger.d('innit with network');
//       channel.stream.listen((message) {
//         List<Pet> networkPets =
//             parsePetsFromMessage(message); // Implement your parsing logic

//         pets = networkPets;
//         logger.d(pets);
//         //_databaseHelper.savePetsToDatabase(networkPets); // Save fetched data locally
//         notifyListeners();
//       });

//       channel.sink.add('getPets');
//     }
//   }

//   List<Pet> parsePetsFromMessage(String message) {
//     List<dynamic> jsonList = json.decode(message);

//     List<Pet> petsList = jsonList.map((json) => Pet.fromJson(json)).toList();

//     return petsList;
//   }

//   // Future<void> _initPets() async {
//   //   logger.d('Initializing pets');
//   //   pets = await _databaseHelper.readAllPets();
//   //   notifyListeners();
//   // }

//   Future<List<Pet>> getPetList() async {
//     logger.d('get all pets');
//     //pets = await _databaseHelper.readAllPets();
//     return pets;
//   }

//   Future<int> get_count() async {
//     logger.d('get count called');
//     int count = await _databaseHelper.countPets();
//     return count;
//   }

//   Future<Pet> get_pet(int i) async {
//     logger.d('get pet');
//     int? id = pets[i].id;
//     if (id != null) {
//       return await _databaseHelper.readOnePet(id);
//     }
//     return await _databaseHelper.readOnePet(i);
//   }

//   Future<void> add_pet(Pet pet) async {
//     logger.d('add pet');
//     Pet createdPet = await _databaseHelper.create(pet);
//     pets.add(createdPet);
//     notifyListeners();
//   }

//   Future<void> update_pet(Pet p) async {
//     for (int i = 0; i < pets.length; i++) {
//       if (pets[i].id == p.id) {
//         pets[i] = p;
//       }
//     }
//     logger.d('final update pet');
//     logger.d(p.name);
//     await _databaseHelper.update(p);
//     notifyListeners();
//   }

//   Future<void> removet(int? id) async {
//     if (id == null) {
//       throw ArgumentError('ID cannot be null');
//     }
//     logger.d('deleting');
//     logger.d(id);
//     pets.removeWhere((element) => element.id == id);
//     await _databaseHelper.delete(id);
//     notifyListeners();
//   }
// }
