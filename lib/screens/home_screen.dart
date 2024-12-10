import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/services/api_service.dart';
import 'package:flutter_ecommerce/widgets/product_card.dart';
import 'package:flutter_ecommerce/widgets/bottom_navigation.dart';
import 'package:flutter_ecommerce/screens/search_screen.dart';
import 'package:flutter_ecommerce/screens/cart_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _pageSize = 10;
  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 0);
  final ApiService _apiService = ApiService();
  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await _apiService.getProducts(
        limit: _pageSize,
        offset: pageKey,
      );
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void _onNavigationTap(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SearchScreen()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAD6C3), //Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: Color(0xFFFAD6C3),
              elevation: 0,
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Color(0xFFFAD6C3),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Welcome back ;)',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: Colors.grey[900],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Find your style😎',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Container(
                  height: 120,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue[700]!,
                        Color.fromARGB(255, 255, 0, 0)!
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -30,
                        top: -20,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'Arv Sale is on',
                                  textStyle: GoogleFonts.inter(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  speed: const Duration(milliseconds: 100),
                                ),
                              ],
                              repeatForever: true,
                              pause: const Duration(milliseconds: 900),
                              displayFullTextOnTap: true,
                              stopPauseOnTap: true,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Up to 50% off',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: PagedSliverGrid<int, Product>(
                pagingController: _pagingController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                builderDelegate: PagedChildBuilderDelegate<Product>(
                  itemBuilder: (context, item, index) => ProductCard(
                    product: item,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onNavigationTap,
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
