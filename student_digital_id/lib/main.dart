import 'package:flutter/material.dart';

// ===========================================================================
// CSC303 – Mobile Application Development
// Project Name: Student Digital ID & Campus Dashboard
// ===========================================================================

void main() {
  runApp(const StudentDigitalIdApp());
}

// MAIN APPLICATION WIDGET
class StudentDigitalIdApp extends StatelessWidget {
  const StudentDigitalIdApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Digital ID & Campus Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

// DASHBOARD SCREEN (StatefulWidget for managing Quick Notes state)
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Controller for Quick Notes TextField
  final TextEditingController _noteController = TextEditingController();
  
  // List to store added notes dynamically
  final List<String> _notesList = [];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  // Method to handle adding a note
  void _addNote() {
    final noteText = _noteController.text.trim();
    if (noteText.isNotEmpty) {
      setState(() {
        _notesList.insert(0, noteText); // Add latest note at top
        _noteController.clear();
      });
      // Show SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note added successfully!'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ENROLLED COURSES DATA LIST
    final List<String> courses = [
      'Mobile Application Development',
      'Software Design and Architecture',
      'Computer Organization and Assembly Language',
      'Web Technologies',
      'Operating Systems',
    ];

    return Scaffold(
      // =====================================================================
      // APP BAR
      // =====================================================================
      appBar: AppBar(
        title: const Text(
          'Student Campus Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Search button clicked'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),

      // =====================================================================
      // DRAWER (NAVIGATION DRAWER)
      // =====================================================================
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // User Accounts Drawer Header
            const UserAccountsDrawerHeader(
              accountName: Text(
                'M. Jameel',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: Text(
                'Registration No: SP24-BSE-051',
                style: TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 45, color: Colors.indigo),
              ),
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
            ),
            // Menu Item 1: Student Profile
            ListTile(
              leading: const Icon(Icons.person, color: Colors.indigo),
              title: const Text('Student Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            // Menu Item 2: Digital ID Card
            ListTile(
              leading: const Icon(Icons.badge, color: Colors.indigo),
              title: const Text('Digital ID Card'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            // Menu Item 3: My Courses
            ListTile(
              leading: const Icon(Icons.book, color: Colors.indigo),
              title: const Text('My Courses'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            // Menu Item 4: Settings
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.indigo),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      // =====================================================================
      // BODY (SafeArea & SingleChildScrollView)
      // =====================================================================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =============================================================
              // STUDENT DIGITAL ID CARD
              // =============================================================
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Colors.indigo, Colors.indigoAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card Header Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'STUDENT DIGITAL ID CARD',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Icon(Icons.verified, color: Colors.white, size: 20),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Profile Image, Active Status, and Details Row
                      Row(
                        children: [
                          // =================================================
                          // PROFILE IMAGE & ACTIVE STATUS (Stack & Positioned)
                          // =================================================
                          Stack(
                            children: [
                              const CircleAvatar(
                                radius: 36,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 34,
                                  backgroundColor: Colors.indigo,
                                  child: Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // Active Dot Indicator
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          // =================================================
                          // STUDENT INFORMATION ALIGNMENT (Column & Row)
                          // =================================================
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'M. Jameel',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Roll No: SP24-BSE-051',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Department: Software Engineering',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Semester: 5th Semester',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // =============================================================
              // CAMPUS DASHBOARD
              // =============================================================
              const Text(
                'Campus Dashboard',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 12),
              // Dashboard Summary Cards side-by-side using Row and Expanded
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(Icons.school, color: Colors.indigo, size: 28),
                            SizedBox(height: 8),
                            Text(
                              'Department',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Software Eng.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(Icons.calendar_month, color: Colors.indigo, size: 28),
                            SizedBox(height: 8),
                            Text(
                              'Semester',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '5th Semester',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // =============================================================
              // ENROLLED COURSES SECTION
              // =============================================================
              const Text(
                'Enrolled Courses',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 12),
              // Dynamic Course List using ListView.builder inside SingleChildScrollView
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo.shade50,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        courses[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: const Text('Current Semester Course'),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // =============================================================
              // QUICK NOTES SECTION
              // =============================================================
              const Text(
                'Quick Notes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // TextField for entering a note
                      TextField(
                        controller: _noteController,
                        decoration: InputDecoration(
                          hintText: 'Enter your note...',
                          prefixIcon: const Icon(Icons.note, color: Colors.indigo),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.indigo, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // ElevatedButton to add note
                      ElevatedButton(
                        onPressed: _addNote,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Add Note',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      
                      // Display entered notes dynamically if any exist
                      if (_notesList.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Saved Notes:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _notesList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.indigo.shade50,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              elevation: 0,
                              child: ListTile(
                                leading: const Icon(Icons.note_alt, color: Colors.indigo),
                                title: Text(_notesList[index]),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      _notesList.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
