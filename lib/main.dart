import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _pickImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              child: Center(
                child: IconButton(
                    icon: Icon(Icons.add_a_photo),
                    onPressed: () {
                      _showImageDailogBox(context);
                    }),
              ),
            ),
            if (_pickImage != null)
              Container(
                  width: double.infinity,
                  height: 250,
                  child: Image.file(_pickImage)),
          ],
        ),
      ),
    );
  }

  imagePicked(ImageSource source,context) async {
    PickedFile pickerFile = await ImagePicker().getImage(source: source);
    setState(() {
      if (pickerFile != null) {
        cropImage(pickerFile,context);
      }
    });
    Navigator.pop(context);
  }

  cropImage(PickedFile pickedFile,BuildContext context) async {
    double ratio = MediaQuery.of(context).size.width.floor()/250;
    File cropped = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      compressQuality: 99,
      maxWidth: MediaQuery.of(context).size.width.floor(),
      maxHeight: 250,
      aspectRatio: CropAspectRatio(ratioX: ratio, ratioY: 1)
      // aspectRatioPresets: [CropAspectRatioPreset.square,]
      );
      if(cropped != null){
        setState(() {
          _pickImage = cropped;
        });      
      }
    }

  void _showImageDailogBox(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text('Gallery'),
                    onTap: () {
                      imagePicked(ImageSource.gallery,context);
                    },
                  ),
                  ListTile(
                    title: Text('Camera'),
                    onTap: () {
                      imagePicked(ImageSource.camera,context);
                    },
                  ),
                ],
              ),
            ));
  }
}
