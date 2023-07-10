import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:spellchecker/models/pdf_api.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../controllers/custom_text_editing_controller.dart';
import '../words/list_indonesian_word.dart';

class PdfReadPage extends StatefulWidget {
  const PdfReadPage({super.key});

  @override
  State<PdfReadPage> createState() => _PdfReadPageState();
}

class _PdfReadPageState extends State<PdfReadPage> {
  final List<String> listErrorTexts = [];
  final List<String> listTexts = [];
  CustomTextEdittingController _controllerPdf = CustomTextEdittingController();

  PDFDoc? _pdfDoc;
  String _textPdf = "";
  bool _buttonsEnabled = true;

  Future _pickPDFText() async {
    var filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      _pdfDoc = await PDFDoc.fromPath(filePickerResult.files.single.path!);
      setState(() {});
    }
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

  Future _readWholeDoc() async {
    if (_pdfDoc == null) {
      return;
    }
    setState(() {
      _buttonsEnabled = false;
    });

    String text = await _pdfDoc!.text;

    setState(() {
      _controllerPdf.text = text;
      _buttonsEnabled = true;
    });
  }

  @override
  void initState() {
    _pickPDFText();
    _controllerPdf =
        CustomTextEdittingController(listErrorTexts: listErrorTexts);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          Navigator.popAndPushNamed(context, '/homePage'),
                      child: Icon(
                        Icons.close,
                        color: Colors.blue,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/pdf.png",
                        width: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          _pdfDoc == null
                              ? ""
                              : "${_pdfDoc!.length} halaman \n",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed:
                          _buttonsEnabled ? () => _readWholeDoc() : () {},
                      child: Text(
                        "Deteksi Dokumen",
                        style: TextStyle(color: Colors.blue.shade700),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Colors.blue.shade100,
                          ),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)))),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final pdfFile = await PdfApi.generateText(_controllerPdf.text);
                          PdfApi.openFile(pdfFile);
                        },
                        child: Text("Download"),
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                        ))
                  ],
                ),
                /*Padding(
                              child: Text(
                                _textPdf == "" ? "" : "Text: ",
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                              padding: EdgeInsets.all(15),
                            ),
                            Text(_textPdf),*/
                Focus(
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      _handleSpellCheck(_controllerPdf.text, false);
                    }
                  },
                  child: TextFormField(
                      controller: _controllerPdf,
                      onChanged: _handleOnChange,
                      maxLines: 100,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                        hintText: '',
                      )),
                ),
                TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.download),
                    label: Text("Download"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
