import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/pokemon_controller.dart';

class FavoritesPage extends StatelessWidget {
  final PokemonController controller = Get.find<PokemonController>();

  FavoritesPage({super.key});

  Color _pastelColor(int index) {
    const colors = [
      Color(0xFFE0F7FA),
      Color(0xFFFFF9C4),
      Color(0xFFFFE0B2),
      Color(0xFFE1BEE7),
      Color(0xFFD1C4E9),
      Color(0xFFC8E6C9),
      Color(0xFFFFCDD2),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF22223B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Favorite Pokémon',
          style: TextStyle(
            color: Color(0xFF22223B),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.favoritePokemons.isEmpty) {
          return const Center(
            child: Text(
              'No favorite Pokémon yet',
              style: TextStyle(fontSize: 18, color: Color(0xFF4A4E69)),
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.95,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
          ),
          itemCount: controller.favoritePokemons.length,
          itemBuilder: (context, index) {
            final pokemon = controller.favoritePokemons[index];
            return GestureDetector(
              onTap: () {
                context.push('/pokemon/${pokemon.id}', extra: pokemon);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _pastelColor(index),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: CachedNetworkImage(
                              imageUrl: pokemon.imageUrl,
                              height: 90,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF22223B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          pokemon.id.toString().padLeft(3, '0'),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4A4E69),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                    Positioned(
                      top: 12,
                      right: 16,
                      child: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red, size: 28),
                        onPressed: () => controller.toggleFavorite(pokemon),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
} 