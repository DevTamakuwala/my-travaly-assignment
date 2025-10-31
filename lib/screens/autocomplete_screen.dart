import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_travaly_assignment/models/auto_complete_model.dart';
import 'package:my_travaly_assignment/services/api_service.dart';

class AutoCompleteSearchScreen extends StatefulWidget {
  final String visitorToken;

  const AutoCompleteSearchScreen({super.key, required this.visitorToken});

  @override
  State<AutoCompleteSearchScreen> createState() =>
      _AutoCompleteSearchScreenState();
}

class _AutoCompleteSearchScreenState extends State<AutoCompleteSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  Timer? _debounce;
  AutoCompleteList? _results;
  bool _isLoading = false;
  String _error = '';
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchAutoComplete(_searchController.text);
    });
  }

  Future<void> _fetchAutoComplete(String query) async {
    if (query.isEmpty || query.length < 3) {
      setState(() {
        _isLoading = false;
        _results = null;
        _error = '';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final AutoCompleteList? response = await _apiService.searchAutoComplete(
        visitorToken: widget.visitorToken,
        query: query,
      );

      setState(() {
        _results = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
        _results = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search by hotel, city, state...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _results = null;
                      _isLoading = false;
                      _error = '';
                    });
                  },
                )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Failed to load results: $_error",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    if (_results == null) {
      if (_searchController.text.isEmpty) {
        return const Center(
            child: Text("Type to start searching.\nEnter at least 3 characters to search"));
      } else {
        return const Center(child: Text("No results found."));
      }
    }

    final List<Widget> items = [];

    if (_results!.byPropertyName.present) {
      items.add(_buildSectionHeader("Properties"));
      items.addAll(_buildResultList(_results!.byPropertyName.listOfResult, Icons.hotel));
    }
    if (_results!.byStreet.present) {
      items.add(_buildSectionHeader("Streets"));
      items.addAll(_buildResultList(_results!.byStreet.listOfResult, Icons.signpost));
    }
    if (_results!.byCity.present) {
      items.add(_buildSectionHeader("Cities"));
      items.addAll(_buildResultList(_results!.byCity.listOfResult, Icons.location_city));
    }
    if (_results!.byCountry.present) {
      items.add(_buildSectionHeader("Countries"));
      items.addAll(_buildResultList(_results!.byCountry.listOfResult, Icons.public));
    }

    if (items.isEmpty) {
      return const Center(child: Text("No results found."));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      itemCount: items.length,
      separatorBuilder: (context, index) {
        final item = items[index];
        if (item is ListTile) {
          if (index + 1 < items.length && items[index+1] is ListTile) {
            return const Divider(height: 1, indent: 16, endIndent: 16);
          }
        }
        return const SizedBox.shrink();
      },
      itemBuilder: (context, index) {
        return items[index];
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  List<Widget> _buildResultList(List<AutoCompleteResult> results, IconData icon) {
    return results.map((result) {
      return ListTile(
        leading: Icon(icon, color: Colors.grey[600]),
        title: Text(result.valueToDisplay),
        subtitle: Text(
          result.formattedAddress,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Selected: ${result.valueToDisplay}"),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      );
    }).toList();
  }
}
