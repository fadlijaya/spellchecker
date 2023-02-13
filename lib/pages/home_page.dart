import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:spellchecker/constants/constants.dart';

import 'package:spellchecker/words/list_indonesian_word.dart';
import 'package:spellchecker/words/list_english_word.dart';
import 'package:spellchecker/pages/pdf_read_page.dart';

import '../controllers/custom_text_editing_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> listErrorTexts = [];
  final List<String> listTexts = [];
  CustomTextEdittingController _controller = CustomTextEdittingController();

  PDFDoc? _pdfDoc;
  String _textPdf = "";
  bool _buttonsEnabled = true;

  @override
  void initState() {
    _controller = CustomTextEdittingController(listErrorTexts: listErrorTexts);
    super.initState();
  }

  void _handleOnChange(String text) {
    _handleSpellCheck(text, true);
  }

  void _handleSpellCheck(String text, bool ignoreLastWord) {
    if (!text.contains(' ')) {
      return;
    }
    final List<String> arr = text.split(' ');
    if (ignoreLastWord) {
      arr.removeLast();
    }
    for (var word in arr) {
      if (word.isEmpty) {
        continue;
      } else if (_isWordHasNumberOrBracket(word)) {
        continue;
      }
      final wordToCheck = word.replaceAll(RegExp(r"[^\s\w]"), '');
      final wordToCheckInLowercase = wordToCheck.toLowerCase();
      if (!listTexts.contains(wordToCheckInLowercase)) {
        listTexts.add(wordToCheckInLowercase);
        if (!listIndonesianWord.contains(wordToCheckInLowercase)) {
          listErrorTexts.add(wordToCheck);
        }
      }
    }
  }

  bool _isWordHasNumberOrBracket(String s) {
    return s.contains(RegExp(r'[0-9\()]'));
  }

  /*Future _readRandomPage() async {
    if (_pdfDoc == null) {
      return;
    }
    setState(() {
      _buttonsEnabled = false;
    });

    String text =
        await _pdfDoc!.pageAt(Random().nextInt(_pdfDoc!.length) + 1).text;

    setState(() {
      _textPdf = text;
      _buttonsEnabled = true;
    });
  }*/

  //membaca seluruh dokumen
  Future _readWholeDoc() async {
    if (_pdfDoc == null) {
      return;
    }
    setState(() {
      _buttonsEnabled = false;
    });

    String text = await _pdfDoc!.text;

    setState(() {
      _textPdf = text;
      _buttonsEnabled = true;
    });
  }

  /*showAlertDialogExit() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Keluar dari aplikasi?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Tidak")),
              TextButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: const Text("Ya"))
            ],
          );
        });
  }*/

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      /*actions: [
          IconButton(
              onPressed: showAlertDialogExit,
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ))
        ],*/
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Image.asset(
                        "assets/icon_app.png",
                        width: 60,
                      ),
                    ),
                    const Text(
                      titleApp,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(top: 24, bottom: 8),
                      child: Text(
                        "Deteksi Kesalahan Kata (Typo)",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                          "Silakan masukkan teks ke dalam kotak di bawah ini!", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),),
                    ),
                  ],
                ),
                Focus(
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      _handleSpellCheck(_controller.text, false);
                    }
                  },
                  child: TextFormField(
                      controller: _controller,
                      onChanged: _handleOnChange,
                      minLines: 7,
                      maxLines: 7,
                      maxLength: 500,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                          hintText: 'Ketik disini',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)))),
                ),
                Row(
                  children: [
                    Text("*Kata yang berlabel merah berarti salah (typo)", style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey),),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text("Atau", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "Upload File PDF",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                DottedBorder(
                  borderType: BorderType.RRect,
                  dashPattern: const [10, 4],
                  radius: const Radius.circular(8),
                  strokeCap: StrokeCap.round,
                  color: Colors.grey.shade300,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.blue.shade50.withOpacity(.5),
                        borderRadius: BorderRadius.circular(10)),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PdfReadPage())),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/upload_pdf.png",
                            width: 80,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              'Upload File',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                /*TextButton(
                  child: Text(
                    "Read random page",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: _buttonsEnabled ? _readRandomPage : () {},
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
