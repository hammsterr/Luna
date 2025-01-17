import 'dart:io';

import 'package:flutter/material.dart';
import 'package:Luna/helper/customRoute.dart';
import 'package:Luna/helper/utility.dart';
import 'package:Luna/state/authState.dart';
import 'package:Luna/ui/page/profile/widgets/circular_image.dart';
import 'package:Luna/widgets/cache_image.dart';
import 'package:Luna/widgets/customFlatButton.dart';
import 'package:Luna/widgets/customWidgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);
  static MaterialPageRoute<T> getRoute<T>() {
    return CustomRoute<T>(
        builder: (BuildContext context) => const EditProfilePage());
  }

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _image;
  File? _banner;
  late TextEditingController _name;
  late TextEditingController _nick;
  late TextEditingController _bio;
  late TextEditingController _location;
  late TextEditingController _dob;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? dob;
  @override
  void initState() {
    _name = TextEditingController();
    _nick = TextEditingController();
    _bio = TextEditingController();
    _location = TextEditingController();
    _dob = TextEditingController();
    AuthState state = Provider.of<AuthState>(context, listen: false);
    _name.text = state.userModel?.displayName ?? '';
    _nick.text = state.userModel?.userName ?? '';
    _bio.text = state.userModel?.bio ?? '';
    _location.text = state.userModel?.location ?? '';
    _dob.text = Utility.getDob(state.userModel?.dob);
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _nick.dispose();
    _bio.dispose();
    _location.dispose();
    _dob.dispose();
    super.dispose();
  }

  Widget _body() {
    var authState = Provider.of<AuthState>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 180,
          child: Stack(
            children: <Widget>[
              _bannerImage(authState),
              Align(
                alignment: Alignment.bottomLeft,
                child: _userImage(authState),
              ),
            ],
          ),
        ),
        _entry('Имя', controller: _name),
        _entry('Ник', controller: _nick),
        _entry('Био', controller: _bio),
        _entry('Локация', controller: _location),
        InkWell(
          onTap: showCalender,
          child: _entry('Дата рождения', enabled: false, controller: _dob),
        )
      ],
    );
  }

  Widget _userImage(AuthState authState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 5),
        shape: BoxShape.circle,
        image: DecorationImage(
            image: customAdvanceNetworkImage(authState.userModel!.profilePic),
            fit: BoxFit.cover),
      ),
      child: CircleAvatar(
        radius: 40,
        backgroundImage: (_image != null
                ? FileImage(_image!)
                : customAdvanceNetworkImage(authState.userModel!.profilePic))
            as ImageProvider,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black38,
          ),
          child: Center(
            child: IconButton(
              onPressed: uploadImage,
              icon: const Icon(Icons.camera_alt, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bannerImage(AuthState authState) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        image: authState.userModel!.bannerImage == null
            ? null
            : DecorationImage(
                image:
                    customAdvanceNetworkImage(authState.userModel!.bannerImage),
                fit: BoxFit.cover),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black45,
        ),
        child: Stack(
          children: [
            _banner != null
                ? Image.file(_banner!,
                    fit: BoxFit.fill, width: MediaQuery.of(context).size.width)
                : CacheImage(
                    path: authState.userModel!.bannerImage ??
                        'https://xn----7sbcgrydczc.xn--p1ai/src/img/lower/priroda/priroda-luna/priroda-luna-5.png',
                    fit: BoxFit.fill),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black38),
                child: IconButton(
                  onPressed: uploadBanner,
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _entry(String title,
      {required TextEditingController controller,
      int maxLine = 1,
      bool enabled = true}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          customText(title, style: const TextStyle(color: Colors.black54)),
          TextField(
            enabled: enabled,
            controller: controller,
            maxLines: maxLine,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            ),
          )
        ],
      ),
    );
  }

  void showCalender() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2019, DateTime.now().month, DateTime.now().day),
      firstDate: DateTime(1950, DateTime.now().month, DateTime.now().day + 3),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    setState(() {
      if (picked != null) {
        dob = picked.toString();
        _dob.text = Utility.getDob(dob);
      }
    });
  }

  void _submitButton() {
    if (_name.text.length > 27) {
      Utility.customSnackBar(context, 'Name length cannot exceed 27 character');
      return;
    }
    var state = Provider.of<AuthState>(context, listen: false);
    var model = state.userModel!.copyWith(
      key: state.userModel!.userId,
      displayName: state.userModel!.displayName,
      userName: state.userModel!.userName,
      bio: state.userModel!.bio,
      contact: state.userModel!.contact,
      dob: state.userModel!.dob,
      email: state.userModel!.email,
      location: state.userModel!.location,
      profilePic: state.userModel!.profilePic,
      userId: state.userModel!.userId,
      bannerImage: state.userModel!.bannerImage,
    );
    if (_name.text.isNotEmpty) {
      model.displayName = _name.text;
    }
    if (_nick.text.isNotEmpty) {
      model.userName = _nick.text;
    }
    if (_bio.text.isNotEmpty) {
      model.bio = _bio.text;
    }
    if (_location.text.isNotEmpty) {
      model.location = _location.text;
    }
    if (dob != null) {
      model.dob = dob!;
    }

    state.updateUserProfile(model, image: _image, bannerImage: _banner);
    Navigator.of(context).pop();
  }

  void uploadImage() {
    openImagePicker(context, (file) {
      setState(() {
        _image = file;
      });
    });
  }

  void uploadBanner() {
    openImagePicker(context, (file) {
      setState(() {
        _banner = file;
      });
    });
  }

  openImagePicker(BuildContext context, Function(File) onImageSelected) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 140,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              const Text(
                'Выберите фото',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: CustomFlatButton(
                      label: "Камера",
                      borderRadius: 15,
                      onPressed: () {
                        getImage(context, ImageSource.camera, onImageSelected);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: CustomFlatButton(
                      label: "Галерея",

                      borderRadius: 15,
                      onPressed: () {
                        getImage(context, ImageSource.gallery, onImageSelected);
                      },
                    ),
                  ),

                ],
              )
            ],
          ),
        );
      },
    );
  }

  getImage(BuildContext context, ImageSource source,
      Function(File) onImageSelected) {
    ImagePicker().pickImage(source: source, imageQuality: 50).then((
      XFile? file,
    ) {
      //FIXME
      onImageSelected(File(file!.path));
      Navigator.pop(context);
    });
  }

  // TODO
  // eraseImage(BuildContext context, Function(File) onImageSelected) {
  //   // Загрузка изображения из ресурсов приложения
  //   File imageFile = File('assets/transparent.png');
  //
  //   // Вызов функции обратного вызова с выбранным изображением
  //   onImageSelected(imageFile);
  //
  //   // Закрытие текущего экрана
  //   Navigator.pop(context);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
        title: customTitleText(
          'Редактирование профиля',
        ),
        actions: <Widget>[
          InkWell(
            onTap: _submitButton,
            child: const Center(
              child: Text(
                'Сохранить',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: _body(),
      ),
    );
  }


}
