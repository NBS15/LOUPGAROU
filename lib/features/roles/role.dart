enum RoleCamp { village, wolves, neutral }

class GameRole {
  const GameRole({
    required this.id,
    required this.name,
    required this.description,
    required this.power,
    required this.camp,
    required this.icon,
    required this.nightOrder,
  });

  final String id;
  final String name;
  final String description;
  final String power;
  final RoleCamp camp;
  final String icon;
  final int nightOrder;
}
