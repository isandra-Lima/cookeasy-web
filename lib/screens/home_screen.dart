// lib/screens/home_screen.dart
// Tela inicial - Lista de receitas (READ do CRUD)

import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../data/recipes_data.dart';
import 'recipe_form_screen.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lista principal de receitas (estado local do app)
  List<Recipe> _recipes = List.from(initialRecipes);
  String _searchQuery = '';
  String _selectedCategory = 'Todas';

  // Getter que aplica filtros
  List<Recipe> get _filteredRecipes {
    return _recipes.where((r) {
      final matchSearch =
          r.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              r.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchCategory =
          _selectedCategory == 'Todas' || r.category == _selectedCategory;
      return matchSearch && matchCategory;
    }).toList();
  }

  // ── CREATE ──────────────────────────────────────────────────────────────────
  Future<void> _addRecipe() async {
    final newRecipe = await Navigator.push<Recipe>(
      context,
      MaterialPageRoute(
        builder: (_) => const RecipeFormScreen(),
      ),
    );
    if (newRecipe != null) {
      setState(() => _recipes.add(newRecipe));
      _showSnackBar('Receita "${newRecipe.name}" criada! ✅');
    }
  }

  // ── UPDATE ──────────────────────────────────────────────────────────────────
  Future<void> _editRecipe(Recipe recipe) async {
    final updated = await Navigator.push<Recipe>(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeFormScreen(recipe: recipe),
      ),
    );
    if (updated != null) {
      setState(() {
        final index = _recipes.indexWhere((r) => r.id == updated.id);
        if (index != -1) _recipes[index] = updated;
      });
      _showSnackBar('Receita "${updated.name}" atualizada! ✅');
    }
  }

  // ── DELETE ──────────────────────────────────────────────────────────────────
  Future<void> _deleteRecipe(Recipe recipe) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Receita'),
        content: Text(
          'Tem certeza que deseja excluir "${recipe.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() => _recipes.removeWhere((r) => r.id == recipe.id));
      _showSnackBar('Receita "${recipe.name}" excluída! 🗑️');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredRecipes;
    final allCategories = ['Todas', ...categories];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F5F2),
        elevation: 0,
        title: const Text(
          '🍽️ CookEasy',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Chip(
              label: Text(
                '${_recipes.length} receitas',
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: const Color(0xFFE8F5E2),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Barra de pesquisa ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Buscar receitas...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // ── Filtro de categorias ───────────────────────────────────────────
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: allCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = allCategories[i];
                final selected = _selectedCategory == cat;
                return FilterChip(
                  label: Text(cat),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedCategory = cat),
                  selectedColor: const Color(0xFF1A1A1A),
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w500,
                  ),
                  backgroundColor: Colors.white,
                  showCheckmark: false,
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // ── Lista de receitas ──────────────────────────────────────────────
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🍳', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'Nenhuma receita encontrada'
                              : 'Nenhuma receita ainda',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _addRecipe,
                          icon: const Icon(Icons.add),
                          label: const Text('Criar Receita'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _RecipeCard(
                      recipe: filtered[i],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              RecipeDetailScreen(recipe: filtered[i]),
                        ),
                      ),
                      onEdit: () => _editRecipe(filtered[i]),
                      onDelete: () => _deleteRecipe(filtered[i]),
                    ),
                  ),
          ),
        ],
      ),

      // ── Botão de Adicionar (CREATE) ────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addRecipe,
        icon: const Icon(Icons.add),
        label: const Text('Nova Receita'),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
      ),
    );
  }
}

// ── Card de Receita ────────────────────────────────────────────────────────────
class _RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _RecipeCard({
    required this.recipe,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  Color get _difficultyColor {
    switch (recipe.difficulty) {
      case 'Fácil':
        return Colors.green;
      case 'Médio':
        return Colors.orange;
      case 'Difícil':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Emoji
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F5F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  recipe.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
              const SizedBox(width: 12),

              // Informações
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      recipe.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _Tag(icon: Icons.timer_outlined, label: recipe.time),
                        const SizedBox(width: 8),
                        _Tag(
                          icon: Icons.bar_chart,
                          label: recipe.difficulty,
                          color: _difficultyColor,
                        ),
                        const SizedBox(width: 8),
                        _Tag(
                          icon: Icons.category_outlined,
                          label: recipe.category,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Menu de ações (UPDATE / DELETE)
              PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == 'edit') onEdit();
                  if (v == 'delete') onDelete();
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Editar'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Excluir', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                child: const Icon(Icons.more_vert, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _Tag({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.grey;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: c),
        const SizedBox(width: 2),
        Text(label, style: TextStyle(fontSize: 11, color: c)),
      ],
    );
  }
}
