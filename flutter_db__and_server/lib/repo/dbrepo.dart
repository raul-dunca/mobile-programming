import 'dart:async';
import 'dart:convert';

import 'package:adoptr/model/pet.dart';
import 'package:adoptr/repo/db_helper.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;

class PetsDarabaseRepository with ChangeNotifier {
  List<Pet> pets = [];
  final DatabaseRepo _databaseHelper = DatabaseRepo.instance;
  final Logger logger = Logger();
  late IOWebSocketChannel channel;
  List<Pet> savedPets = [];
  int cntr = 0;
  bool wasOffline = false;
  var OfflineOperationQueue = <List<dynamic>>[];
  late Timer _connectivityTimer;
  bool listening_already = false;

  PetsDarabaseRepository() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _initPets();
    _startConnectivityMonitoring();
  }

  Future<void> _initPets() async {
    logger.d('Initializing pets');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      wasOffline = true;
      logger.d('Initializing without network');
      pets = await _databaseHelper.readAllPets();
      notifyListeners();
    } else {
      logger.d('Initializing with network');
      channel = IOWebSocketChannel.connect('ws://10.0.2.2:2320');
      final response = await http.get(Uri.parse('http://10.0.2.2:2320/all'));
      if (response.statusCode == 200) {
        wasOffline = false;
        // Handle the response data here
        pets = parsePetsFromMessage(response.body);

        await _databaseHelper.deleteAllPets();

        for (int i = 0; i < pets.length; i++) {
          Pet pet = pets[i];
          await _databaseHelper.create(pet);
        }
        notifyListeners();
        lstenToBroadcast();
        listening_already = true;
      } else {
        throw Exception(
            'Failed to read pets. Status code: ${response.statusCode}');
      }
    }
  }

  List<Pet> parsePetsFromMessage(String message) {
    List<dynamic> jsonList = json.decode(message);

    List<Pet> petsList = jsonList.map((json) => Pet.fromJson(json)).toList();

    return petsList;
  }

  Future<List<Pet>> getPetList() async {
    logger.d('Get all pets');
    //pets = await _databaseHelper.readAllPets();
    return pets;
  }

  void lstenToBroadcast() {
    channel.stream.listen((message) async {
      // Handle messages received via WebSocket
      Map<String, dynamic> data = jsonDecode(message);
      String action = data['action'];
      logger.d('Action is ' + action);
      if (action == 'add') {
        Pet receivedPet = Pet.fromJson(data['data']);
        pets.add(receivedPet);
        await _databaseHelper.create(receivedPet);
        notifyListeners();
      } else if (action == 'delete') {
        int id = data['data'];
        pets.removeWhere((element) => element.id == id);
        await _databaseHelper.delete(id);
        notifyListeners();
      } else if (action == 'update') {
        Pet updatedPet = Pet.fromJson(data['data']);
        for (int i = 0; i < pets.length; i++) {
          if (pets[i].id == updatedPet.id) {
            pets[i] = updatedPet;
          }
        }
        await _databaseHelper.update(updatedPet);
        notifyListeners();
      }
    });
  }

  void _startConnectivityMonitoring() {
    const Duration checkInterval = Duration(seconds: 1);

    _connectivityTimer = Timer.periodic(checkInterval, (_) async {
      var connectivityResult = await Connectivity().checkConnectivity();
      _handleConnectivityChange(connectivityResult);
    });
  }

  void _handleConnectivityChange(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      //online->offline
      if (!wasOffline) {
        wasOffline = true;
        logger.d("From online to offline (switching to local db)");
        pets = await _databaseHelper.readAllPets();
        notifyListeners();
        savedPets = pets;
      }
    } else if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      if (wasOffline) {
        wasOffline = false;
        logger.d("From offline to online (pushing local changes to server)");

        channel = IOWebSocketChannel.connect('ws://10.0.2.2:2320');

        //try to push local changes to server

        print(OfflineOperationQueue);
        if (!listening_already) {
          lstenToBroadcast();
        }
        while (OfflineOperationQueue.isNotEmpty) {
          var dequeuedPair = OfflineOperationQueue.removeAt(0);
          var firstElement = dequeuedPair[0];
          var action = dequeuedPair[1];
          if (action == 'add') {
            await addPetOnlineNoDB(firstElement);
          } else if (action == 'update') {
            //print(firstElement.id);
            await updatePetOnline(firstElement);
          } else if (action == 'delete') {
            await removePetOnline(firstElement);
          }
        }

        final response = await http.get(Uri.parse('http://10.0.2.2:2320/all'));
        if (response.statusCode == 200) {
          wasOffline = false;
          pets = parsePetsFromMessage(response.body);
          await _databaseHelper.deleteAllPets();
          for (final pet in pets) {
            await _databaseHelper.create(pet);
          }
          notifyListeners();
        } else {
          throw Exception(
              'Failed to read pets. Status code: ${response.statusCode}');
        }
      }
    }
  }

  Future<void> add_pet(Pet pet) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      await addPetOffline(pet);
    } else {
      await addPetOnline(pet);
    }
  }

  Future<void> addPetOnlineNoDB(Pet pet) async {
    logger.d("Adding pet online (but not in db)");
    final url = Uri.parse('http://10.0.2.2:2320/pet');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pet.toJsonNoId()),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      int? old_id = pet.id;
      int id = responseBody['_id'] as int;
      print("BEFORE FOR");
      print(old_id);
      print(OfflineOperationQueue);
      for (int i = 0; i < OfflineOperationQueue.length; i++) {
        if (OfflineOperationQueue[i][0] is int) {
          print(OfflineOperationQueue[i][0]);
          if (OfflineOperationQueue[i][0] == old_id) {
            OfflineOperationQueue[i][0] = id;
          }
        } else {
          print(OfflineOperationQueue[i][0].id);
          if (OfflineOperationQueue[i][0].id == old_id) {
            OfflineOperationQueue[i][0].id = id;
          }
        }
      }
      print(OfflineOperationQueue);
      pet.id = id;
    } else {
      throw Exception('Failed to add pet. Status code: ${response.statusCode}');
    }
  }

  Future<void> addPetOnline(Pet pet) async {
    logger.d("Adding pet online");
    final url = Uri.parse('http://10.0.2.2:2320/pet');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pet.toJsonNoId()),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      int id = responseBody['_id'] as int;
      pet.id = id;
      //await _databaseHelper.create(pet);
    } else {
      throw Exception('Failed to add pet. Status code: ${response.statusCode}');
    }
  }

  Future<void> addPetOffline(Pet pet) async {
    logger.d("Adding pet offline");
    int create_pet_id = await _databaseHelper.create_no_id(pet);
    pet.id = create_pet_id;
    pets.add(pet);
    OfflineOperationQueue.add([pet, 'add']);
    notifyListeners();
  }

  Future<void> update_pet(Pet pet) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      await updatePetOffline(pet);
    } else {
      await updatePetOnline(pet);
    }
  }

  Future<void> updatePetOnline(Pet pet) async {
    logger.d("Updating pet online");
    final url = Uri.parse('http://10.0.2.2:2320/pet/${pet.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pet.toJsonNoId()),
    );

    if (response.statusCode == 200) {
      //await _databaseHelper.update(pet);
    } else {
      throw Exception(
          'Failed to update pet. Status code: ${response.statusCode}');
    }
  }

  Future<void> updatePetOffline(Pet pet) async {
    for (int i = 0; i < pets.length; i++) {
      if (pets[i].id == pet.id) {
        pets[i] = pet;
      }
    }
    logger.d('Updating pet offline');
    await _databaseHelper.update(pet);
    OfflineOperationQueue.add([pet, 'update']);
    notifyListeners();
  }

  Future<void> removet(int? id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      await removePetOffline(id);
    } else {
      await removePetOnline(id);
    }
  }

  Future<void> removePetOnline(int? id) async {
    logger.d("Deleting pet online");
    final url = Uri.parse('http://10.0.2.2:2320/pet/${id}');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      //Map<String, dynamic> responseBody = jsonDecode(response.body);
      //int id = responseBody['_id'] as int;
      //await _databaseHelper.delete(id);
    } else {
      throw Exception(
          'Failed to delete pet. Status code: ${response.statusCode}');
    }
  }

  Future<void> removePetOffline(int? id) async {
    if (id == null) {
      throw ArgumentError('ID cannot be null');
    }
    logger.d('Deleting pet offline');
    pets.removeWhere((element) => element.id == id);
    await _databaseHelper.delete(id);
    OfflineOperationQueue.add([id, 'delete']);
    notifyListeners();
  }
}
