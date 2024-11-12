// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:flutter/services.dart'; // For copying to clipboard

class TranslatorFeature extends StatefulWidget {
  @override
  _TranslatorFeatureState createState() => _TranslatorFeatureState();
}

class _TranslatorFeatureState extends State<TranslatorFeature> {
  GoogleTranslator translator = GoogleTranslator();

  String selectedLanguage = 'English';
  String out = ''; // Initialize output with an empty string

  // Complete map of language codes
  final Map<String, String> languageCodes = {
    'Afrikaans': 'af',
    'Albanian': 'sq',
    'Amharic': 'am',
    'Arabic': 'ar',
    'Armenian': 'hy',
    'Azerbaijani': 'az',
    'Basque': 'eu',
    'Bengali': 'bn',
    'Bosnian': 'bs',
    'Bulgarian': 'bg',
    'Catalan': 'ca',
    'Chinese (Simplified)': 'zh-CN',
    'Chinese (Traditional)': 'zh-TW',
    'Croatian': 'hr',
    'Czech': 'cs',
    'Danish': 'da',
    'Dutch': 'nl',
    'English': 'en',
    'Esperanto': 'eo',
    'Estonian': 'et',
    'Finnish': 'fi',
    'French': 'fr',
    'Galician': 'gl',
    'Georgian': 'ka',
    'German': 'de',
    'Greek': 'el',
    'Gujarati': 'gu',
    'Haitian Creole': 'ht',
    'Hebrew': 'iw',
    'Hindi': 'hi',
    'Hungarian': 'hu',
    'Icelandic': 'is',
    'Igbo': 'ig',
    'Indonesian': 'id',
    'Irish': 'ga',
    'Italian': 'it',
    'Japanese': 'ja',
    'Kannada': 'kn',
    'Kazakh': 'kk',
    'Khmer': 'km',
    'Korean': 'ko',
    'Kurdish (Kurmanji)': 'ku',
    'Kyrgyz': 'ky',
    'Latvian': 'lv',
    'Lithuanian': 'lt',
    'Luxembourgish': 'lb',
    'Macedonian': 'mk',
    'Malagasy': 'mg',
    'Malay': 'ms',
    'Malayalam': 'ml',
    'Maltese': 'mt',
    'Maori': 'mi',
    'Marathi': 'mr',
    'Mongolian': 'mn',
    'Nepali': 'ne',
    'Norwegian': 'no',
    'Pashto': 'ps',
    'Persian': 'fa',
    'Polish': 'pl',
    'Portuguese': 'pt',
    'Punjabi': 'pa',
    'Romanian': 'ro',
    'Russian': 'ru',
    'Serbian': 'sr',
    'Slovak': 'sk',
    'Slovenian': 'sl',
    'Spanish': 'es',
    'Swahili': 'sw',
    'Swedish': 'sv',
    'Tajik': 'tg',
    'Tamil': 'ta',
    'Tatar': 'tt',
    'Telugu': 'te',
    'Thai': 'th',
    'Turkish': 'tr',
    'Turkmen': 'tk',
    'Ukrainian': 'uk',
    'Urdu': 'ur',
    'Uzbek': 'uz',
    'Vietnamese': 'vi',
    'Welsh': 'cy',
    'Xhosa': 'xh',
    'Yiddish': 'yi',
    'Yoruba': 'yo',
    'Zulu': 'zu'
  };

  // Output and input
  final TextEditingController lang = TextEditingController();

  void trans() {
    if (lang.text.isEmpty) {
      // Show a snackbar if the input field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter some text to translate'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      String langCode =
          languageCodes[selectedLanguage] ?? 'en'; // Default to English
      translator.translate(lang.text, to: langCode).then((value) {
        setState(() {
          out = value.toString();
        });
      });
    }
  }

  void copyText() {
    if (out.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: out));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Translated text copied to clipboard'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void clearText() {
    setState(() {
      lang.clear();
      out = ''; // Clear both input and output
    });
  }

  @override
  Widget build(BuildContext context) {
    // Set background color based on the current theme
    final backgroundColor = Theme.of(context).brightness == Brightness.dark
        ? const Color.fromARGB(255, 52, 51, 51)
        : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: 'Lumi',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 49, 167, 245),
                      fontFamily: 'PoppinsBold')),
              TextSpan(
                  text: 'Translate',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.blue,
                      fontFamily: 'PoppinsBold')),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[800], // Change to grey shade
                      ),
                      child: TextField(
                        controller: lang,
                        minLines: 5,
                        maxLines: 999,
                        decoration: InputDecoration(
                          hintText: "Tap to enter text",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'PoppinsReg',
                            fontSize: 20,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(
                            fontFamily: 'PoppinsReg',
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: IconButton(
                        icon: Icon(Icons.clear, color: Colors.white),
                        onPressed: clearText,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(right: 198.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: languageCodes.keys
                        .map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                    value: selectedLanguage,
                    style: TextStyle(
                        fontFamily: 'PoppinsReg',
                        color: const Color.fromARGB(255, 16, 132, 233)),
                    onChanged: (String? value) {
                      setState(() {
                        selectedLanguage = value!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Center(
                child: ElevatedButton.icon(
                  onPressed: trans,
                  icon: Icon(Icons.translate, color: Colors.white),
                  label: Text(
                    'Translate',
                    style: TextStyle(
                        fontFamily: 'PoppinsReg', color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blue, // Set button background to blue
                  ),
                ),
              ),

              SizedBox(height: 20.0), // Add spacing
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.blue[400],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 10.0, right: 10.0),
                        child: SelectableText(
                          out,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'PoppinsReg',
                          ),
                          showCursor: true,
                          cursorColor: Colors.white,
                          minLines: 5,
                          maxLines: 999,
                          scrollPhysics: ClampingScrollPhysics(),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: IconButton(
                        icon: Icon(Icons.copy, color: Colors.white),
                        onPressed: copyText,
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
