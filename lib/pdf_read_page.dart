import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf_text/pdf_text.dart';

import 'custom_text_editing_controller.dart';
import 'list_basic_word.dart';

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
        if (!listBasicWord.contains(wordToCheckInLowercase)) {
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
      _textPdf = text;
      _controllerPdf.text = text;
      _buttonsEnabled = true;
    });
  }

  @override
  void initState() {
    _pickPDFText();
    _controllerPdf = CustomTextEdittingController(listErrorTexts: listErrorTexts);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(_pdfDoc == null ? "" : "Dokumen Pdf, ${_pdfDoc!.length} halaman \n",),
        )
      ),
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextButton(
                child: Text(
                  "Klik untuk membaca seluruh dokumen",
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: _buttonsEnabled
                    ? () {
                        _readWholeDoc();
                      }
                    : () {},
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
                    decoration: const InputDecoration(
                      hintText: '',
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
