import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/pokemon_model.dart';
import 'package:get/get.dart';
import '../controllers/pokemon_controller.dart';

class PokemonDetailPage extends StatefulWidget {
  final PokemonModel pokemon;
  const PokemonDetailPage({super.key, required this.pokemon});

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pokemon = widget.pokemon;
    return Scaffold(
      backgroundColor: const Color(0xFFEAF0F6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF22223B)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                            style: const TextStyle(
                              color: Color(0xFF22223B),
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GetBuilder<PokemonController>(
                            builder: (controller) => IconButton(
                              icon: Icon(
                                pokemon.isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: Colors.red,
                                size: 28,
                              ),
                              onPressed: () => controller.toggleFavorite(pokemon),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        pokemon.id.toString().padLeft(3, '0'),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4A4E69),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F7FA),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: pokemon.imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF22223B),
                  unselectedLabelColor: const Color(0xFF4A4E69),
                  indicatorColor: const Color(0xFF22223B),
                  tabs: const [
                    Tab(text: 'Forms'),
                    Tab(text: 'Detail'),
                    Tab(text: 'Types'),
                    Tab(text: 'Stats'),
                    Tab(text: 'Weakness'),
                  ],
                ),
                SizedBox(
                  height: 400,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildFormsTab(pokemon),
                      _buildDetailTab(pokemon),
                      _buildTypesTab(pokemon),
                      _buildStatsTab(pokemon),
                      _buildWeaknessTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormsTab(PokemonModel pokemon) {
    // Placeholder: on ne récupère qu'une seule forme ici
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F7FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CachedNetworkImage(
                  imageUrl: pokemon.imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF22223B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Mega Evolution',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF22223B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "In order to support its flower, which has grown larger due to Mega Evolution, its back and legs have become stronger.",
            style: TextStyle(fontSize: 15, color: Color(0xFF4A4E69)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTab(PokemonModel pokemon) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Height', '${pokemon.height / 10} m'),
          _buildInfoRow('Weight', '${pokemon.weight / 10} kg'),
          const SizedBox(height: 16),
          const Text('Abilities', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: pokemon.abilities.map((a) => Chip(label: Text(a))).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTypesTab(PokemonModel pokemon) {
    return Center(
      child: Wrap(
        spacing: 12,
        children: pokemon.types.map((type) => Chip(
          label: Text(type, style: const TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF22223B),
        )).toList(),
      ),
    );
  }

  Widget _buildStatsTab(PokemonModel pokemon) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: pokemon.stats.entries.map((stat) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat.key.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: stat.value / 255,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF22223B)),
                ),
                Text('${stat.value}'),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWeaknessTab() {
    return const Center(
      child: Text('Weakness info coming soon...', style: TextStyle(color: Color(0xFF4A4E69))),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }
} 