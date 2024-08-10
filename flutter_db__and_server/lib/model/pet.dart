import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

const String tablePets = 'pet';

class PetFields {
  static final List<String> values = [
    id,
    name,
    type,
//    image,
    location,
    gender,
    breed,
    age,
    contact,
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String type = 'type';
//  static const String image = 'image';
  static const String location = 'location';
  static const String gender = 'gender';
  static const String breed = 'breed';
  static const String age = 'age';
  static const String contact = 'contact';
}

class Pet {
  final Logger logger = Logger();
  String name;
  String type;
//  Image image;
  String location;
  String gender;
  String breed;
  int age;
  String contact;
  int? id;

  Pet(
      {required this.name,
      required this.type,
//      required this.image,
      required this.location,
      required this.gender,
      required this.breed,
      required this.age,
      required this.contact,
      this.id});

//not helpful
  Future<Uint8List> convertImageToBytes(ImageProvider imageProvider) async {
    Completer<Uint8List> completer = Completer<Uint8List>();

    final imageStream = imageProvider.resolve(ImageConfiguration.empty);
    imageStream.addListener(ImageStreamListener((ImageInfo info, _) async {
      final ByteData? byteData =
          await info.image.toByteData(format: ImageByteFormat.png);
      if (byteData != null) {
        final Uint8List bytes = byteData.buffer.asUint8List();
        completer.complete(bytes);
      } else {
        completer.completeError('Failed to convert image to byte data.');
      }
    }, onError: (dynamic error, StackTrace? stackTrace) {
      completer.completeError(error);
    }));

    return completer.future;
  }

  Map<String, dynamic> toJson() {
    return {
      PetFields.id: id,
      PetFields.name: name,
      PetFields.type: type,
      PetFields.location: location,
      PetFields.gender: gender,
      PetFields.breed: breed,
      PetFields.age: age,
      PetFields.contact: contact,
    };
  }

  Map<String, dynamic> toJsonNoId() {
    return {
      PetFields.name: name,
      PetFields.type: type,
      PetFields.location: location,
      PetFields.gender: gender,
      PetFields.breed: breed,
      PetFields.age: age,
      PetFields.contact: contact,
    };
  }

  static Pet fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json[PetFields.id] as int,
      name: json[PetFields.name] as String,
      type: json[PetFields.type] as String,
      //  image: petImage as Image,
      location: json[PetFields.location] as String,
      gender: json[PetFields.gender] as String,
      breed: json[PetFields.breed] as String,
      age: json[PetFields.age] as int,
      contact: json[PetFields.contact] as String,
    );
  }

  Pet copy({
    int? id,
    String? name,
    String? type,
    Image? image,
    String? location,
    String? gender,
    String? breed,
    int? age,
    String? contact,
    Uint8List? byes,
  }) =>
      Pet(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        //    image: image ?? this.image,
        location: location ?? this.location,
        gender: gender ?? this.gender,
        breed: breed ?? this.breed,
        age: age ?? this.age,
        contact: contact ?? this.contact,
      );

  set setname(String n) {
    name = n;
  }

  set settype(String t) {
    type = t;
  }

  // set setImage(Image img) {
  //   image = img;
  // }

  set setlocation(String loc) {
    location = loc;
  }

  set setgender(String g) {
    gender = g;
  }

  set setbreed(String b) {
    breed = b;
  }

  set setage(String a) {
    age = int.parse(a);
  }

  set setcontact(String c) {
    contact = c;
  }

  String get getName => name;

  String get getType => type;

  // Image get getImage => image;

  String get getLocation => location;

  String get getGender => gender;

  String get getBreed => breed;

  int get getAge => age;

  String get getContact => contact;

  int? get getId => id;
}
