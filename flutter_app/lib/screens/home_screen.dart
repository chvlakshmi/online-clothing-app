import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../providers/app_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'product_list_screen.dart';
import 'wishlist_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerCtrl = PageController();
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadData();
    });
  }

  @override
  void dispose() {
    _bannerCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<AppProvider>(
        builder: (context, appProvider, _) {
          if (appProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }
          return SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSearchBar(appProvider),
                        _buildBannerCarousel(appProvider),
                        _buildCategories(appProvider),
                        _buildFeaturedSection(appProvider),
                        _buildNewArrivals(appProvider),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good day! 👋',
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textGrey)),
              Text('StyleStore',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark)),
            ],
          ),
          const Spacer(),
          Consumer<CartProvider>(
            builder: (context, cart, _) => Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined,
                      color: AppColors.textDark, size: 26),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CartScreen())),
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: AppColors.highlight,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text('${cart.itemCount}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline,
                color: AppColors.textDark, size: 26),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProfileScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border_outlined,
                color: AppColors.textDark, size: 26),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const WishlistScreen())),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AppProvider appProvider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (v) {
          appProvider.setSearch(v);
          if (v.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductListScreen()),
            );
          }
        },
        decoration: InputDecoration(
          hintText: 'Search clothes, styles...',
          prefixIcon:
              const Icon(Icons.search_rounded, color: AppColors.textGrey),
          suffixIcon: const Icon(Icons.tune_rounded, color: AppColors.accent),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildBannerCarousel(AppProvider appProvider) {
    final banners = appProvider.banners;
    if (banners.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: _bannerCtrl,
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final b = banners[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        b.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFF1A237E),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(b.title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700)),
                            Text(b.subtitle,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 13)),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('Shop Now',
                                  style: TextStyle(
                                      color: AppColors.textDark,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        SmoothPageIndicator(
          controller: _bannerCtrl,
          count: banners.length,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: AppColors.accent,
            dotColor: AppColors.divider,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildCategories(AppProvider appProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Categories',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ProductListScreen())),
                child: Text('See All',
                    style: TextStyle(
                        fontSize: 13,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: appProvider.categories.length,
            itemBuilder: (context, index) {
              final cat = appProvider.categories[index];
              final isSelected =
                  appProvider.selectedCategory == cat.id;
              return GestureDetector(
                onTap: () => appProvider.selectCategory(cat.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getCategoryIcon(cat.icon),
                        color: isSelected ? Colors.white : AppColors.accent,
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cat.name,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedSection(AppProvider appProvider) {
    final featured = appProvider.featuredProducts;
    if (featured.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Featured',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ProductListScreen())),
                child: Text('See All',
                    style: TextStyle(
                        fontSize: 13,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: featured.length,
            itemBuilder: (context, index) => ProductCard(
              product: featured[index],
              isHorizontal: true,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        ProductDetailScreen(product: featured[index])),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewArrivals(AppProvider appProvider) {
    final newItems = appProvider.newArrivals;
    if (newItems.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Text('New Arrivals',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.72,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: newItems.length,
          itemBuilder: (context, index) {
            return Consumer<WishlistProvider>(
              builder: (context, wishlistProvider, _) => ProductCard(
                product: newItems[index],
                isFavorite: wishlistProvider.isInWishlist(newItems[index]),
                onFavoriteToggle: () => wishlistProvider.toggleWishlist(newItems[index]),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          ProductDetailScreen(product: newItems[index])),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'apps':
        return Icons.apps_rounded;
      case 'man':
        return Icons.man_rounded;
      case 'woman':
        return Icons.woman_rounded;
      case 'child_care':
        return Icons.child_care_rounded;
      case 'checkroom':
        return Icons.checkroom_rounded;
      case 'business_center':
        return Icons.business_center_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
