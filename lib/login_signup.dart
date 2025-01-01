import 'package:eco_track/pages/user_pages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'ecotrack_db.dart';

class LoginSignup extends StatefulWidget {
  const LoginSignup({super.key});

  @override
  State<LoginSignup> createState() => _LoginSignupState();
}

class _LoginSignupState extends State<LoginSignup>
{
  // Controllers for login
  late final TextEditingController emailController;
  late final TextEditingController passController;
  // Controllers for sign in
  late final TextEditingController nameControllerSign;
  late final TextEditingController addressControllerSign;
  late final TextEditingController emailControllerSign;
  late final TextEditingController passControllerSign;

  Color color1 = Colors.green.shade600;
  Color color2 = Colors.green.shade400;
  Color color3 = Colors.green.shade300;
  bool isUserSelected = true;
  bool isSignUpMode = false;

  Future<bool> insertNewUser(
      String email, String password, String name, String address) async {
    final conn = DatabaseConnection().connection;
    if (conn == null || !conn.connected) {
      print("Not connected to DB");
      return false;
    }
    try {
      String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      int role = 0;
      int points = 0;
      await conn.execute(
        'INSERT INTO user (email, password, name, address, `date_joined`, role, points) VALUES (:email, :password, :name, :address, :date, :role, :points)',
        {
          "email": email,
          "password": password,
          "name": name,
          "address": address,
          "date": date,
          "role": role,
          "points": points,
        },
      );
      print("User inserted successfully");
      return true;
    } catch (e) {
      print("Error inserting user: $e");
      return false;
    }
  }

  Future<int?> validateLogin(String email, String password) async {
    final conn = DatabaseConnection().connection;
    if (conn == null || !conn.connected) {
      print("Not connected");
      return null;
    } else {
      var result = await conn.execute(
        'SELECT id FROM user WHERE email = :email AND password = :password',
        {"email": email, "password": password},
      );
      print(result.toString());
      if (result.rows.isNotEmpty) {
        // Return the user_id
        return int.parse(result.rows.first.typedAssoc()['id'].toString());
      } else {
        return null;
      }
    }
  }

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passController.text.trim();
    int? userId = await validateLogin(email, password);
    if (userId != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserPages(userId: userId)),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid credentials")));
    }
  }

  @override
  void initState() {
    emailController = TextEditingController();
    passController = TextEditingController();
    emailControllerSign = TextEditingController();
    passControllerSign = TextEditingController();
    nameControllerSign = TextEditingController();
    addressControllerSign = TextEditingController();
    super.initState();
  }

  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: AnimatedContainer(
          duration: const Duration(seconds: 1),
          padding: const EdgeInsets.only(top: 0),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                color1,
                color2,
                color3,
              ],
            ),
          ),
          child: Stack(
            children: [
              Container(
                alignment: const Alignment(0, 0),
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.36,
                child: Image.asset(
                  'assets/images/background.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 80),
                    child: const Text(
                      "Eco Track",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 45,
                        fontFamily: "Arial",
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(60),
                          topLeft: Radius.circular(60),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: isSignUpMode
                                  ? _buildSignUpForm()
                                  : _buildSlider(context),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.1),
                            if (!isSignUpMode)
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isSignUpMode = true;
                                  });
                                },
                                child: const Text(
                                  "Sign Up As New User",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded LoginButton(BuildContext context) {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height*0.07,
        width: MediaQuery.of(context).size.width*0.95,
        child: ElevatedButton(onPressed: login,
          child:Text("Login",style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: "Arial"

          ),),
          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blue),),
        ),
      ),
    );
  }
  Widget _buildSlider(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                ),
                child: Column(children: [
                  LogininputField(
                      "Email", Icons.import_contacts, emailController, false),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  LogininputField(
                      "Password", Icons.import_contacts, passController, true),
                  SizedBox(
                    height: 100,
                  ),
                  Row(
                    children: [
                      LoginButton(context),
                    ],
                  ),
                ]),
              )
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Stack(
          key: const ValueKey('Slider'),
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.shade300,
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment:
                  isUserSelected ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.45,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: isUserSelected
                      ? Colors.green.shade600
                      : Colors.blue.shade600,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      isUserSelected = true;
                      color1 = Colors.green.shade200;
                      color2 = Colors.green.shade900;
                      color3 = Colors.green.shade600;
                    }),
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: const Text(
                        "Login As User",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      isUserSelected = false;

                      color1 = Colors.blue.shade200;
                      color2 = Colors.blue.shade800;
                      color3 = Colors.blue.shade900;
                    }),
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: const Text(
                        "Login As Authority",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        key: const ValueKey('SignUpForm'),
        children: [
          signInInputField("Full Name", Icons.person, nameControllerSign),
          signInInputField("Email", Icons.email, emailControllerSign),
          signInInputField("Password", Icons.lock, passControllerSign),
          signInInputField("Complete address", Icons.house, addressControllerSign),
          const SizedBox(height: 20),
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.blue.shade300,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                )
              ],
            ),
            child: Center(
              child:
              InkWell(
                onTap: () async {
                  String name = nameControllerSign.text.trim();
                  String email = emailControllerSign.text.trim();
                  String password = passControllerSign.text.trim();
                  String address = addressControllerSign.text.trim();

                  if (name.isEmpty || email.isEmpty || password.isEmpty || address.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill in all fields")),
                    );
                    return;
                  }

                  bool success = await insertNewUser(email, password, name, address);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Registration successful!")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Registration failed. Try again.")),
                    );
                  }
                },
                child: const Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            ),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              setState(() {
                isSignUpMode = false;
              });
            },
            child: Text(
              "Already Registered? Login",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Container signInInputField(String hintText, IconData inputIcon,
      TextEditingController controller
      ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Icon(inputIcon),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Container LogininputField(String hintText, IconData inputIcon,
    TextEditingController controller, bool obscureText) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start, // Align to the start
      children: [
        SizedBox(
          width: 24, // Control icon size
          height: 24,
          child: Icon(inputIcon),
        ),
        const SizedBox(width: 8), // Add spacing
        Expanded(
          // Make TextField fill available space
          child: TextField(
            obscureText: obscureText,
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    ),
  );
}
