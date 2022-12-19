import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_text/pdf_text.dart';

import 'package:spellchecker/list_basic_word.dart';

import 'custom_text_editing_controller.dart';

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
  final String _textPdf = "";

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
        if (!listBasicWord.contains(wordToCheckInLowercase)) {
          listErrorTexts.add(wordToCheck);
        }
      }
    }
  }

  bool _isWordHasNumberOrBracket(String s) {
    return s.contains(RegExp(r'[0-9\()]'));
  }

  Future _pickPDFText() async {
    var filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      _pdfDoc = await PDFDoc.fromPath(filePickerResult.files.single.path!);
      setState(() {});
    }
  }

  showAlertDialogExit() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("iDetech"),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Image.asset(
            "assets/icon_app.png",
            width: 16,
          ),
        ),
        actions: [
          IconButton(
              onPressed: showAlertDialogExit,
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Deteksi Typo dan Kata Tidak Baku",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text("Silakan masukkan teks ke dalam kotak di bawah ini!"),
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
                    minLines: 15,
                    maxLines: 100,
                    maxLength: 1000,
                    decoration: const InputDecoration(
                        hintText: 'Ketik disini',
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)))),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text("Atau upload file PDF"),
              ),
              _pdfDoc == null
              ? ElevatedButton(
                onPressed: _pickPDFText,
                child: Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          "Upload File",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll(Colors.blue),
                    padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 16, horizontal: 16)),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)))
                    ),
                    
              )
              : Text("Membuka dokumen Pdf, ${_pdfDoc!.length} halaman \n"),
               Padding(
                  child: Text(
                    _textPdf == "" ? "" : "Text:",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.all(15),
                ),
                Text(_textPdf),
            ],
          ),
        ),
      ),
    );
  }
}
