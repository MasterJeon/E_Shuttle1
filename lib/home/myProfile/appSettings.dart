import 'package:flutter/material.dart';


void main() => runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppSettings(),
    )
);

class AppSettings extends StatefulWidget {
  const AppSettings({Key? key}) : super(key: key);

  @override
  AppSettingsState createState() => AppSettingsState();
}

class AppSettingsState extends State<AppSettings> {
  bool isDarkMode = false;
  String selectedLanguage = 'English';
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
            appBar: AppBar(title: const Text("App Settings"),
      flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 230, 81, 0),
                Color.fromRGBO(239, 108, 0, 1),
                Color.fromRGBO(255, 167, 38, 1),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        // Set padding relative to screen size
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.05,
          horizontal: screenSize.width * 0.08,
        ),
        child: Column(
          children: [
            SizedBox(height: 96),
                SizedBox(height: 24),
            
            
            SizedBox(height: 28),

            profileTab("Language",
              trailing: DropdownButton<String>(
                value: selectedLanguage,
                icon: const Icon(Icons.arrow_downward, color: Colors.white),
                dropdownColor: const Color.fromARGB(255, 37, 137, 232),
                underline: Container(
                  height: 2,
                  color: Colors.transparent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLanguage = newValue!;
                  });
                },
                items: <String>['English', 'Sinhala']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      
                      value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                        ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),

            profileTab("Dark Mode", trailing: Switch( 
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            )),
            SizedBox(height: 16),

            profileTab("Privacy Policy"),
            SizedBox(height: 16),
            
          ],
        ),
      ),
    );
  }
  Widget profileTab(String title, {Widget? trailing}){
    return Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 37, 137, 232),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 5),
                    color: Colors.blue.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ListTile(
                
                title: Text(
                  title,
                  style: TextStyle(color : Colors.white),),
                
                //subtitle: Text(subtitle),
                //leading: Icon(iconData),
                trailing: trailing,
                tileColor: const Color.fromARGB(255, 255, 255, 255),
              ),
    );
  }
}


