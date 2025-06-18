import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/pokemon_controller.dart';

class PokemonListPage extends StatelessWidget {
  final PokemonController controller = Get.put(PokemonController());

  PokemonListPage({super.key});

  Color _pastelColor(int index) {
    // Palette pastel simple
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pokédex',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF22223B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Search for a Pokémon by name or using its National Pokédex number.",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF4A4E69),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Name or number',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: controller.setSearchQuery,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.error.value.isNotEmpty) {
                  return Center(child: Text('Error: ${controller.error.value}'));
                }
                if (controller.pokemons.isEmpty) {
                  return const Center(child: Text('No Pokémon found'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.95,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                  ),
                  itemCount: controller.pokemons.length,
                  itemBuilder: (context, index) {
                    final pokemon = controller.pokemons[index];
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
                        child: Column(
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
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF22223B),
        child: const Icon(Icons.favorite, color: Colors.white),
        onPressed: () => context.push('/favorites'),
      ),
    );
  }
} 