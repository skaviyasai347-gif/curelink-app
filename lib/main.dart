import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/* ================= APP ================= */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthChoicePage(),
    );
  }
}

/* ================= ANIMATED PURPLE BG ================= */
class AnimatedPurpleBG extends StatefulWidget {
  final Widget child;
  const AnimatedPurpleBG({super.key, required this.child});

  @override
  State<AnimatedPurpleBG> createState() => _AnimatedPurpleBGState();
}

class _AnimatedPurpleBGState extends State<AnimatedPurpleBG>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Color(0xFF5E35B1),
                Color(0xFF7E57C2),
                Color(0xFFD1C4E9),
              ],
              stops: [
                controller.value,
                controller.value + 0.3,
                controller.value + 0.6,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

/* ================= AUTH ================= */
class AuthChoicePage extends StatelessWidget {
  const AuthChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedPurpleBG(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.health_and_safety,
                  color: Colors.tealAccent, size: 48),
              const SizedBox(height: 12),
              const Text(
                "Welcome to CureLink",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              authButton("LOGIN", () {
                Navigator.push(context, fadeRoute(const LoginPage()));
              }),
              const SizedBox(height: 12),
              authButton("SIGN UP", () {
                Navigator.push(context, fadeRoute(const SignUpPage()));
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedPurpleBG(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              authField("Email"),
              const SizedBox(height: 12),
              authField("Password", isPassword: true),
              const SizedBox(height: 20),
              authButton("LOGIN", () {
                Navigator.pushReplacement(
                    context, fadeRoute(const HomePage()));
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedPurpleBG(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              authField("Name"),
              const SizedBox(height: 12),
              authField("Email"),
              const SizedBox(height: 12),
              authField("Password", isPassword: true),
              const SizedBox(height: 20),
              authButton("CREATE ACCOUNT", () {
                Navigator.pushReplacement(
                    context, fadeRoute(const HomePage()));
              }),
            ],
          ),
        ),
      ),
    );
  }
}

/* ================= HOME – CHAT UI (LIKE SCREENSHOT) ================= */
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();

  final List<Map<String, dynamic>> messages = [
    {
      "text":
          "Hello! I am your AI Health Assistant. Ask me about symptoms, diseases, or prevention methods.",
      "isUser": false
    },
    {
      "text": "What are the first symptoms of dengue?",
      "isUser": true
    },
    {
      "text":
          "Common first symptoms of dengue include high fever, severe headache, pain behind the eyes, and joint and muscle pain.",
      "isUser": false
    }
  ];

  void sendMessage() {
    if (controller.text.trim().isEmpty) return;
    setState(() {
      messages.add({"text": controller.text, "isUser": true});
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: commonAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Personal Health Assistant (AI)",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          /// CHAT
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final m = messages[i];
                return Align(
                  alignment: m["isUser"]
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(14),
                    constraints:
                        const BoxConstraints(maxWidth: 280),
                    decoration: BoxDecoration(
                      color: m["isUser"]
                          ? Colors.teal
                          : const Color(0xFFF1F3F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      m["text"],
                      style: TextStyle(
                          color: m["isUser"]
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),

          /// INPUT
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              border:
                  Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send,
                        color: Colors.white),
                    onPressed: sendMessage,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}


/* ================= DASHBOARD ================= */
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: commonAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Dashboard",
              style:
                  TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          dashboardCard(Icons.verified_user, Colors.green,
              "Vaccine Status", "Fully Vaccinated"),
          dashboardCard(Icons.notifications, Colors.red,
              "Alerts", "1 New Alert"),
          dashboardCard(Icons.calendar_month, Colors.blue,
              "Next Appointment", "Nov 20"),
          dashboardCard(Icons.sick, Colors.orange,
              "Disease Info", "View Details",
              onTap: () {
            Navigator.push(
                context, fadeRoute(const DiseasePage()));
          }),
        ],
      ),
    );
  }
}


/* ================= DISEASE PAGE – OLD NICE UI ================= */
class DiseasePage extends StatelessWidget {
  const DiseasePage({super.key});

  Widget row(String d, String s, String p, String st, Color c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(child: Text(d)),
          Expanded(child: Text(s)),
          Expanded(child: Text(p)),
          Expanded(
              child: Text(st,
                  style: TextStyle(
                      color: c,
                      fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Disease Information",
                style:
                    TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText:
                    "Search for a disease (e.g. Malaria, COVID-19)",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.search),
                label: const Text("Search"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            row("COVID-19", "Fever, Cough",
                "Vaccination", "High Alert", Colors.red),
            row("Influenza", "Body Aches",
                "Flu Shot", "Seasonal", Colors.orange),
            row("Malaria", "Fever, Chills",
                "Mosquito Nets", "Regional", Colors.blue),
            row("Dengue", "High Fever",
                "Avoid Stagnant Water", "Seasonal",
                Colors.orange),
          ],
        ),
      ),
    );
  }
}

/* ================= VACCINES PAGE (EXACT UI) ================= */
class VaccinesPage extends StatelessWidget {
  const VaccinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      drawer: const AppDrawer(),
      appBar: commonAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Vaccination Tracker",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937)),
            ),
            const SizedBox(height: 20),

            // FIND SLOT CARD
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Find Vaccine Slots (via Govt. API)",
                      style: TextStyle(
                          color: Color(0xFF009688),
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  const Text("Enter Pincode"),
                  const SizedBox(height: 6),
                  _input("e.g., 110001"),
                  const SizedBox(height: 14),
                  const Text("Vaccine"),
                  const SizedBox(height: 6),
                  _dropdown(),
                  const SizedBox(height: 20),
                  _button("Find Slots"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // HISTORY
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Your Vaccination History",
                      style: TextStyle(
                          color: Color(0xFF009688),
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _historyHeader(),
                  const Divider(),
                  _historyRow("COVID-19 (Covishield)", "1st Dose",
                      "June 15, 2024", "Completed", Colors.green),
                  _historyRow("COVID-19 (Covishield)", "2nd Dose",
                      "Sept 15, 2024", "Completed", Colors.green),
                  _historyRow("COVID-19 (Booster)", "-", "-", "Pending",
                      Colors.orange),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 8)
            ]),
        child: child,
      );

  Widget _input(String hint) => TextField(
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF1F3F5),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
        ),
      );

  Widget _dropdown() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            color: const Color(0xFFF1F3F5),
            borderRadius: BorderRadius.circular(8)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: "All Vaccines",
            isExpanded: true,
            items: const [
              DropdownMenuItem(
                  value: "All Vaccines", child: Text("All Vaccines")),
              DropdownMenuItem(
                  value: "Covishield", child: Text("Covishield")),
              DropdownMenuItem(value: "Covaxin", child: Text("Covaxin")),
            ],
            onChanged: (_) {},
          ),
        ),
      );

  Widget _button(String text) => SizedBox(
        width: double.infinity,
        height: 46,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF009688)),
          onPressed: () {},
          child: Text(text,
              style:
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );

  Widget _historyHeader() => const Row(
        children: [
          Expanded(flex: 3, child: Text("Vaccine")),
          Expanded(child: Text("Dose")),
          Expanded(child: Text("Date")),
          Expanded(child: Text("Status")),
        ],
      );

  Widget _historyRow(String v, String d, String dt, String s, Color c) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(flex: 3, child: Text(v)),
            Expanded(child: Text(d)),
            Expanded(child: Text(dt)),
            Expanded(
                child:
                    Text(s, style: TextStyle(color: c, fontWeight: FontWeight.bold))),
          ],
        ),
      );
}

/* ================= DRAWER ================= */
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
              child: Text("CURELINK",
                  style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
          drawerItem(context, Icons.home, "Home", const HomePage()),
          drawerItem(context, Icons.dashboard, "Dashboard",
              const DashboardPage()),
          drawerItem(context, Icons.sick, "Disease", const DiseasePage()),
          drawerItem(context, Icons.vaccines, "Vaccines",
              const VaccinesPage()),
          const Spacer(),
          drawerItem(context, Icons.logout, "Logout", null, logout: true),
        ],
      ),
    );
  }
}

/* ================= HELPERS ================= */
PreferredSizeWidget commonAppBar() => AppBar(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      title: const Text("CureLink", style: TextStyle(color: Colors.black)),
    );

Widget drawerItem(BuildContext context, IconData icon, String title,
        Widget? page,
        {bool logout = false}) =>
    ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        if (logout) {
          Navigator.pushAndRemoveUntil(
              context, fadeRoute(const AuthChoicePage()), (r) => false);
        } else if (page != null) {
          Navigator.push(context, fadeRoute(page));
        }
      },
    );

Widget dashboardCard(IconData icon, Color color, String title, String subtitle,
        {VoidCallback? onTap}) =>
    GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 8)
            ]),
        child: Row(
          children: [
            CircleAvatar(
                backgroundColor: color.withOpacity(.2),
                child: Icon(icon, color: color)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style: const TextStyle(color: Colors.grey)),
              ],
            )
          ],
        ),
      ),
    );

Widget authField(String hint, {bool isPassword = false}) => SizedBox(
      width: 280,
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
      ),
    );

Widget authButton(String text, VoidCallback onTap) => SizedBox(
      width: 280,
      child: ElevatedButton(onPressed: onTap, child: Text(text)),
    );

PageRoute fadeRoute(Widget page) => PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, a, __, c) =>
          FadeTransition(opacity: a, child: c),
    );