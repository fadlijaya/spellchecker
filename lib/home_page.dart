import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spellchecker/list_puebi.dart';

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
  final TextEditingController _controllerUploadFile = TextEditingController();

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
        if (!listPuebi.contains(wordToCheckInLowercase)) {
          listErrorTexts.add(wordToCheck);
        }
      }
    }
  }

  bool _isWordHasNumberOrBracket(String s) {
    return s.contains(RegExp(r'[0-9\()]'));
  }
  
  showAlertDialogExit() {
    showDialog(context: context, builder: (_){
      return AlertDialog(
        title: const Text("Keluar dari aplikasi?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tidak")),
          TextButton(onPressed: () => SystemNavigator.pop(), child: const Text("Ya"))
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
          child: Image.asset("assets/icon_app.png", width: 16,),
        ),
        actions: [
          IconButton(onPressed: showAlertDialogExit, icon: const Icon(Icons.exit_to_app, color: Colors.white,))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        width: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text("Deteksi Typo dan Kata Tidak Baku", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
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
                  minLines: 10,
                  maxLines: 15,
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
                  padding: EdgeInsets.only(top: 16, bottom: 8),
                  child: Text("Atau upload file (doc, docs, pdf)"),
                ),
            Flexible(
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width/1.5,
                    child: TextFormField(
                      controller: _controllerUploadFile,
                      decoration: InputDecoration(
                        hintText: 'Tidak ada file dipilih',
                        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey, ),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey
                          )
                        )
                      ),
                    ),
                  ),
                  ElevatedButton(onPressed: (){}, child: Text("Pilih File", style: TextStyle(color: Colors.white),), style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                    padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 16, horizontal: 16))
                  ),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
 