// lib/data/recipes_data.dart
// Dados iniciais das receitas (baseado no projeto CookEasy original)

import '../models/recipe.dart';

final List<Recipe> initialRecipes = [
  Recipe(
    id: '1',
    name: 'Tiramisu Cremoso',
    category: 'Sobremesas',
    emoji: '🍮',
    time: '30 min',
    servings: 6,
    difficulty: 'Médio',
    description:
        'Sobremesa italiana clássica com biscoitos embebidos em espresso e creme de mascarpone.',
    ingredients: [
      '300 g de queijo mascarpone',
      '3 ovos, separados',
      '80 g de açúcar de confeiteiro',
      '200 ml de espresso forte, frio',
      '200 g de biscoito champagne',
      '2 colheres de sopa de rum escuro (opcional)',
      'Cacau em pó para polvilhar',
    ],
    steps: [
      'Bata as gemas com o açúcar até ficar pálido e cremoso.',
      'Adicione o mascarpone e misture até ficar homogêneo.',
      'Bata as claras em neve e incorpore delicadamente.',
      'Misture espresso com rum numa tigela rasa.',
      'Mergulhe rapidamente os biscoitos no espresso.',
      'Monte camadas: biscoitos, creme, biscoitos, creme.',
      'Polvilhe generosamente com cacau e refrigere por 4 horas.',
    ],
  ),
  Recipe(
    id: '2',
    name: 'Torrada de Abacate',
    category: 'Salgados',
    emoji: '🥑',
    time: '10 min',
    servings: 2,
    difficulty: 'Fácil',
    description:
        'Pão sourdough torrado coberto com abacate cremoso e ovo pochê.',
    ingredients: [
      '2 fatias de pão sourdough',
      '1 abacate maduro',
      '2 ovos',
      '1 colher de sopa de vinagre branco',
      'Suco de meio limão',
      'Pimenta calabresa',
      'Sal e pimenta-do-reino',
    ],
    steps: [
      'Toste o pão até ficar dourado e crocante.',
      'Amasse o abacate com limão, sal e pimenta.',
      'Prepare os ovos pochê em água fervente com vinagre.',
      'Espalhe o abacate sobre as torradas.',
      'Coloque o ovo pochê por cima e finalize com pimenta.',
    ],
  ),
  Recipe(
    id: '3',
    name: 'Lassi de Manga',
    category: 'Bebidas',
    emoji: '🥭',
    time: '5 min',
    servings: 2,
    difficulty: 'Fácil',
    description:
        'Bebida indiana refrescante de iogurte com manga madura e cardamomo.',
    ingredients: [
      '2 mangas maduras, em cubos',
      '250 ml de iogurte natural',
      '150 ml de leite gelado',
      '2 colheres de sopa de mel',
      '¼ colher de chá de cardamomo moído',
      'Gelo a gosto',
    ],
    steps: [
      'Coloque a manga, iogurte e leite no liquidificador.',
      'Adicione mel e cardamomo.',
      'Bata por 60 segundos até ficar homogêneo.',
      'Sirva em copos com gelo.',
    ],
  ),
  Recipe(
    id: '4',
    name: 'Macarrão ao Alho e Óleo',
    category: 'Salgados',
    emoji: '🍝',
    time: '20 min',
    servings: 4,
    difficulty: 'Fácil',
    description:
        'Espaguete irresistível refogado em manteiga de alho com salsa fresca.',
    ingredients: [
      '400 g de espaguete',
      '80 g de manteiga sem sal',
      '6 dentes de alho fatiados',
      '½ colher de chá de pimenta calabresa',
      'Salsa fresca picada',
      '60 g de parmesão ralado',
      'Sal e pimenta-do-reino',
    ],
    steps: [
      'Cozinhe o macarrão em água salgada até al dente. Reserve 1 xícara da água.',
      'Derreta a manteiga em fogo médio-baixo.',
      'Doure o alho fatiado por 3-4 minutos.',
      'Adicione o macarrão e misture bem.',
      'Acrescente água do cozimento para criar um molho cremoso.',
      'Finalize com salsa e parmesão.',
    ],
  ),
];

const List<String> categories = ['Sobremesas', 'Salgados', 'Bebidas'];
const List<String> difficulties = ['Fácil', 'Médio', 'Difícil'];
const List<String> emojis = [
  '🍮',
  '🥑',
  '🥭',
  '🍫',
  '🍝',
  '🍵',
  '🍰',
  '🍗',
  '🍓',
  '🍄',
  '🍕',
  '🥗',
  '🍜'
];
