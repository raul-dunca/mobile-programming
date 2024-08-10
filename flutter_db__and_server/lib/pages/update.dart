import 'package:adoptr/model/pet.dart';
import 'package:adoptr/repo/dbrepo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdatePage extends StatefulWidget {
  final Pet pet;

  const UpdatePage({required this.pet, Key? key}) : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  int _selectedValue = 1;
  final name_input = TextEditingController();
  final breed_input = TextEditingController();
  final type_input = TextEditingController();
  final age_input = TextEditingController();
  final location_input = TextEditingController();
  final contact_input = TextEditingController();
  bool _validateLocation = true;
  bool _validateName = true;
  bool _validateBreed = true;
  bool _validateType = true;
  bool _validateAge = true;
  bool _validateContact = true;
  bool break_var = false;

  @override
  void initState() {
    super.initState();
    name_input.text = widget.pet.name;
    breed_input.text = widget.pet.breed;
    type_input.text = widget.pet.type;
    age_input.text = widget.pet.age.toString();
    location_input.text = widget.pet.location;
    contact_input.text = widget.pet.contact;
    if (widget.pet.gender == "male") {
      _selectedValue = 1;
    } else {
      _selectedValue = 2;
    }
  }

  // Future<void> _pickImage() async {
  //   final returnedImage =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (returnedImage == null) return;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetsDarabaseRepository>(context);

    void update_pet(Pet p) {
      try {
        petProvider.update_pet(p);
      } catch (e) {
        throw Exception('$e');
      }
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 192, 173),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Transform.translate(
                offset: const Offset(0, 0),
                child: Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/image.webp'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Transform.translate(
                    offset: const Offset(0, -10),
                    child: Row(children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 55,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context, true);
                          },
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(270, 0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(
                              Icons.check,
                              size: 55,
                            ),
                            onPressed: () {
                              break_var = false;
                              if (name_input.text.isEmpty) {
                                setState(() {
                                  _validateName = false;
                                });
                                break_var = true;
                              }
                              if (!name_input.text.isEmpty) {
                                setState(() {
                                  _validateName = true;
                                });
                              }
                              if (type_input.text.isEmpty) {
                                _validateType = false;
                                break_var = true;
                              }
                              if (!type_input.text.isEmpty) {
                                _validateType = true;
                              }
                              if (breed_input.text.isEmpty) {
                                _validateBreed = false;
                                break_var = true;
                              }
                              if (!breed_input.text.isEmpty) {
                                _validateBreed = true;
                              }
                              if (age_input.text.isEmpty ||
                                  int.tryParse(age_input.text) == null) {
                                _validateAge = false;
                                break_var = true;
                              }
                              if (!(age_input.text.isEmpty ||
                                  int.tryParse(age_input.text) == null)) {
                                _validateAge = true;
                              }
                              if (location_input.text.isEmpty) {
                                _validateLocation = false;
                                break_var = true;
                              }
                              if (!location_input.text.isEmpty) {
                                _validateLocation = true;
                              }

                              if (contact_input.text.isEmpty) {
                                _validateContact = false;
                                break_var = true;
                              }
                              if (!contact_input.text.isEmpty) {
                                _validateContact = true;
                              }

                              if (break_var) {
                                return;
                              }

                              // Image petImage;
                              // if (_selecteImage != null) {
                              //   petImage = Image.file(_selecteImage!);
                              // } else {
                              //   petImage = widget.pet.image;
                              // }
                              widget.pet.name = name_input.text;
                              widget.pet.type = type_input.text;
                              // widget.pet.image = petImage;
                              widget.pet.location = location_input.text;
                              widget.pet.contact = contact_input.text;
                              widget.pet.gender =
                                  _selectedValue == 1 ? "male" : "female";
                              widget.pet.breed = breed_input.text;
                              widget.pet.age = int.parse(age_input.text);
                              try {
                                update_pet(widget.pet);
                                Navigator.pop(context);
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
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(220, 100),
                      ),
                    ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 255, 254),
                      ),
                    ),
                    const SizedBox(height: 1),
                    TextField(
                      controller: name_input,
                      decoration: InputDecoration(
                        errorText:
                            !_validateName ? 'Please enter a name' : null,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(vertical: 3),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Type',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 255, 254),
                      ),
                    ),
                    const SizedBox(height: 1),
                    TextField(
                      controller: type_input,
                      decoration: InputDecoration(
                        errorText:
                            !_validateType ? 'Please enter a type' : null,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(vertical: 3),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Breed',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 255, 254),
                      ),
                    ),
                    const SizedBox(height: 1),
                    TextField(
                      controller: breed_input,
                      decoration: InputDecoration(
                        errorText:
                            !_validateBreed ? 'Please enter a breed' : null,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(vertical: 3),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Age',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 255, 254),
                      ),
                    ),
                    const SizedBox(height: 1),
                    TextField(
                      controller: age_input,
                      decoration: InputDecoration(
                        errorText:
                            !_validateAge ? 'Please enter valid age' : null,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(vertical: 3),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Gender',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 255, 254),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(-25, 0),
                      child: Row(
                        children: [
                          Flexible(
                            child: RadioListTile<int>(
                              title: const Text(
                                'Male',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 254),
                                  fontSize: 18,
                                ),
                              ),
                              value: 1,
                              groupValue: _selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  _selectedValue = value!;
                                });
                              },
                              dense: true,
                              activeColor: Colors.black,
                            ),
                          ),
                          Flexible(
                            child: RadioListTile<int>(
                              title: const Text(
                                'Female',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 254),
                                  fontSize: 18,
                                ),
                              ),
                              value: 2,
                              groupValue: _selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  _selectedValue = value!;
                                });
                              },
                              dense: true,
                              activeColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 1),
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 255, 254),
                      ),
                    ),
                    const SizedBox(height: 1),
                    TextField(
                      controller: location_input,
                      decoration: InputDecoration(
                        errorText: !_validateLocation
                            ? 'Please enter a location'
                            : null,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(vertical: 3),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Contact',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 255, 254),
                      ),
                    ),
                    const SizedBox(height: 1),
                    TextField(
                      controller: contact_input,
                      decoration: InputDecoration(
                        errorText: !_validateContact
                            ? 'Please enter contact info'
                            : null,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(vertical: 3),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularPhotoButton extends StatelessWidget {
  final VoidCallback? onPressed;

  CircularPhotoButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color.fromARGB(255, 255, 192, 173),
          border: Border.all(color: Colors.black, width: 1.0),
        ),
        child: const Center(
          child: ImageIcon(
            AssetImage('assets/images/camera_icon.png'),
            color: Colors.black,
            size: 35,
          ),
        ),
      ),
    );
  }
}
