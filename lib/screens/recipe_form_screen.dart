// lib/screens/recipe_form_screen.dart
// Formulário de receita - CREATE e UPDATE do CRUD

import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../data/recipes_data.dart';

class RecipeFormScreen extends StatefulWidget {
  // Se `recipe` for null, estamos CRIANDO; se não, EDITANDO
  final Recipe? recipe;

  const RecipeFormScreen({super.key, this.recipe});

  @override
  State<RecipeFormScreen> createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState extends State<RecipeFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers para os campos de texto
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _timeCtrl;
  late final TextEditingController _servingsCtrl;

  late String _selectedCategory;
  late String _selectedDifficulty;
  late String _selectedEmoji;

  // Listas dinâmicas para ingredientes e passos
  late List<TextEditingController> _ingredientCtrls;
  late List<TextEditingController> _stepCtrls;

  bool get _isEditing => widget.recipe != null;

  @override
  void initState() {
    super.initState();
    final r = widget.recipe;

    // Preenche os campos com os dados existentes (edição) ou vazios (criação)
    _nameCtrl = TextEditingController(text: r?.name ?? '');
    _descCtrl = TextEditingController(text: r?.description ?? '');
    _timeCtrl = TextEditingController(text: r?.time ?? '');
    _servingsCtrl = TextEditingController(text: r?.servings.toString() ?? '4');

    _selectedCategory = r?.category ?? categories.first;
    _selectedDifficulty = r?.difficulty ?? difficulties.first;
    _selectedEmoji = r?.emoji ?? emojis.first;

    _ingredientCtrls = r != null
        ? r.ingredients.map((e) => TextEditingController(text: e)).toList()
        : [TextEditingController()];

    _stepCtrls = r != null
        ? r.steps.map((e) => TextEditingController(text: e)).toList()
        : [TextEditingController()];
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _timeCtrl.dispose();
    _servingsCtrl.dispose();
    for (var c in _ingredientCtrls) {
      c.dispose();
    }
    for (var c in _stepCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Salvar (CREATE ou UPDATE) ──────────────────────────────────────────────
  void _save() {
    if (!_formKey.currentState!.validate()) return;

    // Filtra campos vazios
    final ingredients = _ingredientCtrls
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final steps = _stepCtrls
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (ingredients.isEmpty) {
      _showError('Adicione pelo menos 1 ingrediente.');
      return;
    }
    if (steps.isEmpty) {
      _showError('Adicione pelo menos 1 passo.');
      return;
    }

    final Recipe result;

    if (_isEditing) {
      // UPDATE — mantém o mesmo ID
      result = widget.recipe!.copyWith(
        name: _nameCtrl.text.trim(),
        category: _selectedCategory,
        emoji: _selectedEmoji,
        time: _timeCtrl.text.trim(),
        servings: int.tryParse(_servingsCtrl.text) ?? 4,
        difficulty: _selectedDifficulty,
        description: _descCtrl.text.trim(),
        ingredients: ingredients,
        steps: steps,
      );
    } else {
      // CREATE — gera um ID único baseado no timestamp
      result = Recipe(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameCtrl.text.trim(),
        category: _selectedCategory,
        emoji: _selectedEmoji,
        time: _timeCtrl.text.trim(),
        servings: int.tryParse(_servingsCtrl.text) ?? 4,
        difficulty: _selectedDifficulty,
        description: _descCtrl.text.trim(),
        ingredients: ingredients,
        steps: steps,
      );
    }

    Navigator.pop(context, result);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F5F2),
        elevation: 0,
        title: Text(
          _isEditing ? '✏️ Editar Receita' : '➕ Nova Receita',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check),
              label: const Text('Salvar'),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A1A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Seletor de Emoji ─────────────────────────────────────────────
            _Section(
              title: 'Ícone da Receita',
              child: SizedBox(
                height: 56,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: emojis.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final e = emojis[i];
                    final selected = e == _selectedEmoji;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedEmoji = e),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color:
                              selected ? const Color(0xFF1A1A1A) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF1A1A1A)
                                : Colors.grey.shade300,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(e, style: const TextStyle(fontSize: 22)),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Informações básicas ──────────────────────────────────────────
            _Section(
              title: 'Informações Básicas',
              child: Column(
                children: [
                  _InputField(
                    controller: _nameCtrl,
                    label: 'Nome da Receita *',
                    icon: Icons.restaurant_menu,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Campo obrigatório'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  _InputField(
                    controller: _descCtrl,
                    label: 'Descrição *',
                    icon: Icons.description_outlined,
                    maxLines: 3,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Campo obrigatório'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _InputField(
                          controller: _timeCtrl,
                          label: 'Tempo *',
                          icon: Icons.timer_outlined,
                          hint: 'ex: 30 min',
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Obrigatório'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InputField(
                          controller: _servingsCtrl,
                          label: 'Porções *',
                          icon: Icons.people_outlined,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Obrigatório';
                            }
                            if (int.tryParse(v) == null) {
                              return 'Número inválido';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Categoria e Dificuldade ──────────────────────────────────────
            _Section(
              title: 'Categoria e Dificuldade',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Categoria',
                      style: TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: categories.map((cat) {
                      final sel = cat == _selectedCategory;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: sel,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = cat),
                        selectedColor: const Color(0xFF1A1A1A),
                        labelStyle: TextStyle(
                          color: sel ? Colors.white : Colors.black,
                        ),
                        backgroundColor: Colors.white,
                        showCheckmark: false,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Dificuldade',
                      style: TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: difficulties.map((diff) {
                      final sel = diff == _selectedDifficulty;
                      Color diffColor;
                      switch (diff) {
                        case 'Fácil':
                          diffColor = Colors.green;
                          break;
                        case 'Médio':
                          diffColor = Colors.orange;
                          break;
                        default:
                          diffColor = Colors.red;
                      }
                      return ChoiceChip(
                        label: Text(diff),
                        selected: sel,
                        onSelected: (_) =>
                            setState(() => _selectedDifficulty = diff),
                        selectedColor: diffColor,
                        labelStyle: TextStyle(
                          color: sel ? Colors.white : Colors.black,
                        ),
                        backgroundColor: Colors.white,
                        showCheckmark: false,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Ingredientes ─────────────────────────────────────────────────
            _Section(
              title: '🧂 Ingredientes',
              child: Column(
                children: [
                  ..._ingredientCtrls.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: entry.value,
                                  decoration: InputDecoration(
                                    hintText: 'Ex: 200 g de farinha de trigo',
                                    prefixIcon: Text(
                                      '${entry.key + 1}.',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 12,
                                    ),
                                  ),
                                ),
                              ),
                              if (_ingredientCtrls.length > 1)
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline,
                                      color: Colors.red),
                                  onPressed: () => setState(
                                    () => _ingredientCtrls.removeAt(entry.key),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                  TextButton.icon(
                    onPressed: () => setState(
                      () => _ingredientCtrls.add(TextEditingController()),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar Ingrediente'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Passos ───────────────────────────────────────────────────────
            _Section(
              title: '👨‍🍳 Modo de Preparo',
              child: Column(
                children: [
                  ..._stepCtrls.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                margin:
                                    const EdgeInsets.only(top: 10, right: 8),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1A1A1A),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${entry.key + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: entry.value,
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                    hintText: 'Descreva o passo...',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.all(12),
                                  ),
                                ),
                              ),
                              if (_stepCtrls.length > 1)
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline,
                                      color: Colors.red),
                                  onPressed: () => setState(
                                    () => _stepCtrls.removeAt(entry.key),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                  TextButton.icon(
                    onPressed: () => setState(
                      () => _stepCtrls.add(TextEditingController()),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar Passo'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Botão Salvar ─────────────────────────────────────────────────
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A1A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  _isEditing ? 'Salvar Alterações' : 'Criar Receita',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ── Widgets auxiliares ─────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _InputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor: const Color(0xFFF7F5F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1A1A1A), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
