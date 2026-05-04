class CategoryData {
  final String name;
  final String description;
  final String imageUrl;
  final String count;

  const CategoryData({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.count,
  });
}

const allCategories = [
  CategoryData(
    name: 'Abstract',
    description: 'Fluid dynamics, geometric patterns, and digital dreamscapes.',
    imageUrl: 'https://images.pexels.com/photos/2832382/pexels-photo-2832382.jpeg',
    count: '4.1k',
  ),
  CategoryData(
    name: 'Aesthetic',
    description: 'Vaporwave, lo-fi vibes, and visually pleasing artistic compositions.',
    imageUrl: 'https://images.pexels.com/photos/18264716/pexels-photo-18264716.jpeg',
    count: '2.5k',
  ),
  CategoryData(
    name: 'Animals',
    description: 'Majestic wildlife, loyal companions, and the beauty of the animal kingdom.',
    imageUrl: 'https://images.pexels.com/photos/47547/squirrel-animal-cute-rodents-47547.jpeg',
    count: '3.8k',
  ),
  CategoryData(
    name: 'Anime',
    description: 'Stunning illustrations and scenes inspired by Japanese animation.',
    imageUrl: 'https://images.pexels.com/photos/11100063/pexels-photo-11100063.jpeg',
    count: '3.9k',
  ),
  CategoryData(
    name: 'Cars & Bikes',
    description: 'Powerful engines, sleek designs, and the thrill of the open road.',
    imageUrl: 'https://images.pexels.com/photos/337909/pexels-photo-337909.jpeg',
    count: '2.8k',
  ),
  CategoryData(
    name: 'Cute',
    description: 'Whimsical characters, soft palettes, and heartwarming imagery.',
    imageUrl: 'https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg',
    count: '2.2k',
  ),
  CategoryData(
    name: 'Landscape',
    description: 'Vast scenic horizons, mountain ranges, and breathtaking vistas.',
    imageUrl: 'https://images.pexels.com/photos/3225517/pexels-photo-3225517.jpeg',
    count: '5.2k',
  ),
  CategoryData(
    name: 'Minimal',
    description: 'Simplicity, clean lines, and negative space for a focused look.',
    imageUrl: 'https://images.pexels.com/photos/3124111/pexels-photo-3124111.jpeg',
    count: '3.2k',
  ),
  CategoryData(
    name: 'Nature',
    description: 'The raw beauty of forests, flowers, and natural phenomena.',
    imageUrl: 'https://images.pexels.com/photos/1761279/pexels-photo-1761279.jpeg',
    count: '5.2k',
  ),
  CategoryData(
    name: 'Quotes',
    description: 'Inspirational words, artistic typography, and powerful messages.',
    imageUrl: 'https://images.pexels.com/photos/2249602/pexels-photo-2249602.jpeg',
    count: '1.4k',
  ),
  CategoryData(
    name: 'Superheroes',
    description: 'Epic heroes, legendary villains, and comic-inspired action.',
    imageUrl: 'https://images.pexels.com/photos/2422265/pexels-photo-2422265.jpeg',
    count: '1.9k',
  ),
  CategoryData(
    name: 'Others',
    description: 'A diverse mix of unique styles and uncategorized gems.',
    imageUrl: 'https://images.pexels.com/photos/356079/pexels-photo-356079.jpeg',
    count: '1.7k',
  ),
];
