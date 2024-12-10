import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/services/api_service.dart';
import 'package:flutter_ecommerce/widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _apiService = ApiService();
  List<Product> _searchResults = [];
  bool _isLoading = false;
  String _currentQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchProducts(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _currentQuery = '';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _currentQuery = query;
    });

    try {
      final results = await _apiService.searchProducts(query);
      if (mounted && _currentQuery == query) {
        setState(() {
          _searchResults = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted && _currentQuery == query) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error searching products')),
        );
      }
    }
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        padding: const EdgeInsets.all(50),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _searchProducts,
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 16,
            ),
            border: InputBorder.none,
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      _searchProducts('');
                    },
                  )
                : null,
          ),
        ),
      ),
      body: Column(
        children: [
          if (_searchResults.isNotEmpty || _isLoading)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Search Results 👇',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Expanded(
            child: _isLoading
                ? _buildLoadingShimmer()
                : _searchResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _currentQuery.isEmpty
                                  ? 'Start searching for products'
                                  : 'No products found',
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return ProductCard(product: _searchResults[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
