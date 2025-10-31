import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_travaly_assignment/models/hotel_model.dart';
import 'package:my_travaly_assignment/screens/autocomplete_screen.dart';
import 'package:my_travaly_assignment/screens/google_sign_in_screen.dart';
import 'package:my_travaly_assignment/services/api_service.dart';
import 'package:my_travaly_assignment/services/auth_service.dart';
import 'package:my_travaly_assignment/widgets/hotel_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  String? _visitorToken;
  List<Hotel> _popularHotels = [];
  bool _isLoading = true;
  String _error = '';
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _authService.currentUser;
    _initializeHomeScreen();
  }

  Future<void> _initializeHomeScreen() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final token = await _apiService.registerDevice();
      if (token == null) {
        throw Exception("Failed to register device.");
      }
      if (mounted) {
        setState(() {
          _visitorToken = token;
        });
        final hotels = await _apiService.fetchPopularHotels(token);
        setState(() {
          _popularHotels = hotels;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToSearch() {
    if (_visitorToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Service not initialized. Please try again."),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            AutoCompleteSearchScreen(visitorToken: _visitorToken!),
      ),
    );
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const GoogleSignInScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyTravaly"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'signOut') {
                _signOut();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'profile',
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentUser?.displayName ?? 'Guest User',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      _currentUser?.email ?? '',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'signOut',
                child: Text('Sign Out'),
              ),
            ],
            icon: CircleAvatar(
              radius: 16,
              backgroundImage: _currentUser?.photoUrl != null
                  ? NetworkImage(_currentUser!.photoUrl!)
                  : null,
              child: _currentUser?.photoUrl == null
                  ? const Icon(Icons.person, size: 16)
                  : null,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: _navigateToSearch,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 10),
                    Text(
                      'Search by hotel, city, state...',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error.isNotEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Failed to load hotels: $_error",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  )
                : _popularHotels.isEmpty
                ? const Center(child: Text("No popular hotels found."))
                : RefreshIndicator(
                    onRefresh: _initializeHomeScreen,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      itemCount: _popularHotels.length,
                      itemBuilder: (context, index) {
                        return HotelListItem(hotel: _popularHotels[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
