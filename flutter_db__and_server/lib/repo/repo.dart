// import 'package:adoptr/model/pet.dart';
// import 'package:flutter/material.dart';

// class PetRepository with ChangeNotifier {
//   List<Pet> pets = [];
//   PetRepository() {
//     // this.pets = [
//     //   Pet(
//     //       name: "Muffin",
//     //       type: "Dog",
//     //       image: Image.asset('assets/images/corgi.webp'),
//     //       location: "Cluj, Romania",
//     //       contact: "+40712345678",
//     //       gender: "male",
//     //       breed: "Corgi",
//     //       age: 3),
//     //   Pet(
//     //       name: "Teemo",
//     //       type: "Dog",
//     //       image: Image.asset('assets/images/pug.jpg'),
//     //       location: "Cluj, Romania",
//     //       contact: "+40712345678",
//     //       gender: "male",
//     //       breed: "Pug",
//     //       age: 3),
//     //   Pet(
//     //       name: "Ricky",
//     //       type: "Hamster",
//     //       image: Image.asset('assets/images/hamster.jpg'),
//     //       location: "Iasi, Romania",
//     //       contact: "+40712345678",
//     //       gender: "male",
//     //       breed: "Corgi",
//     //       age: 3),
//     //   Pet(
//     //       name: "Cupcake",
//     //       type: "Rabbit",
//     //       image: Image.asset('assets/images/rabbit.jpg'),
//     //       location: "Berlin, Germany",
//     //       contact: "+40712345678",
//     //       gender: "female",
//     //       breed: "Lionhead",
//     //       age: 3),
//     //   Pet(
//     //       name: "Rosa",
//     //       type: "Cat",
//     //       image: Image.asset('assets/images/persian.jpg'),
//     //       location: "Sofia, Blugary",
//     //       contact: "+40712345678",
//     //       gender: "female",
//     //       breed: "Persian",
//     //       age: 3),
//     //   Pet(
//     //       name: "Bella",
//     //       type: "Cat",
//     //       image: Image.asset('assets/images/ragdoll.jpg'),
//     //       location: "Cluj, Romania",
//     //       contact: "+40712345678",
//     //       gender: "male",
//     //       breed: "Ragdoll",
//     //       age: 3),
//     //   Pet(
//     //       name: "Rex",
//     //       type: "Dog",
//     //       image: Image.asset('assets/images/beagle-dog.jpg'),
//     //       location: "Cluj, Romania",
//     //       contact: "+40712345678",
//     //       gender: "male",
//     //       breed: "Beagle",
//     //       age: 3),
//     //   Pet(
//     //       name: "Spike",
//     //       type: "Dog",
//     //       image: Image.asset('assets/images/golden_ret.jpg'),
//     //       location: "Cluj, Romania",
//     //       contact: "+40712345678",
//     //       gender: "male",
//     //       breed: "Retriever",
//     //       age: 3),
//     // ];
//   }
//   List<Pet> getPetList() {
//     return pets;
//   }

//   int get_count() {
//     return pets.length;
//   }

//   Pet get_pet(int i) {
//     return pets[i];
//   }

//   void add_pet(Pet p) {
//     pets.add(p);
//     notifyListeners();
//   }

//   void update_pet(Pet p) {
//     for (int i = 0; i < pets.length; i++) {
//       if (pets[i].id == p.id) {
//         pets[i] = p;
//         notifyListeners();
//       }
//     }
//   }

//   void removet(int id) {
//     pets.removeWhere((element) => element.id == id);
//     notifyListeners();
//   }
// }
