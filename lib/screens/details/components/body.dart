import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aasd/constants.dart';
import 'package:tflite/tflite.dart';

import 'image_and_icons.dart';

class Body1 extends StatefulWidget {
  const Body1({super.key});
  @override
  State<Body1> createState() => _MyBody1State();
}

class _MyBody1State extends State<Body1> {
  File? _file;
  ImagePicker image = ImagePicker();
  bool loading = true;

  var output;
  var label;
  var fine;
  final imagepicker = ImagePicker();
  var gfg = {
    '0 Healthyt_N': 'Class 1',
    '1 Early_N_Def': 'Class 2',
    '2 Prog_N_Def': 'Class 3',
    '3 Late_N_Def': 'Class 4',
  };

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
  }

  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
  }

  detectimage(File l) async {
    var prediction = await Tflite.runModelOnImage(
        path: l.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      output = prediction;
      //label = (output![0]['label']).toString().substring(2);
      //fine = gfg[label];
      loading = false;
    });
    
  }
     

  loadmodel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  @override
  void dispose() {
    super.dispose();
  }

  getImageFromCamera() async {
    var img = await image.pickImage(source: ImageSource.camera);

    setState(() {
      _file = File(img!.path);
    });
    detectimage(_file!);
    return (_file);
  }

  

  getImageFromGallery() async {
    var PickerImage = await image.pickImage(source: ImageSource.gallery);

    setState(() async {
      _file = File(PickerImage!.path);

      ;
    });
    detectimage(_file!);
    return (_file);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          ImageAndIcons(size: size),
          // ignore: prefer_const_constructors
          Container(
            child: _file == null
                ? Text('')
                : Image.file(
                    _file!,
                    height: 400,
                    width: 300,
                  ),
          ),
          output != null
              ? Text((output[0]['label']).toString().substring(2),
                  style: GoogleFonts.roboto(fontSize: 18))
              : Text(''),
          output != null
              ? Text('Confidence: ' + (output[0]['confidence']).toString(),
                  style: GoogleFonts.roboto(fontSize: 18))
              : Text(''),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text("TEST"), Text("TEST")],
            ),
          ),

          const SizedBox(height: kDefaultPadding),
          Row(
            children: <Widget>[
              SizedBox(
                width: size.width / 2,
                height: 84,
                child: TextButton(
                  style: TextButton.styleFrom(
                      // ignore: prefer_const_constructors
                      shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(10),
                        ),
                      ),
                      foregroundColor: Colors.black,
                      backgroundColor: kPrimaryColor),
                  onPressed: getImageFromCamera,
                  child: const Text(
                    "Camera",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: size.width / 2,
                height: 84,
                child: TextButton(
                  style: TextButton.styleFrom(
                      // ignore: prefer_const_constructors
                      shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      foregroundColor: Colors.black,
                      backgroundColor: kPrimaryColor),
                  onPressed: getImageFromGallery,
                  child: const Text(
                    "Gallery",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
