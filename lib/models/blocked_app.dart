class BlockedApp {
  final String packageName;
  final String appName;
  final String? iconPath;
  final bool isBlocked;

  BlockedApp({
    required this.packageName,
    required this.appName,
    this.iconPath,
    this.isBlocked = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'appName': appName,
      'iconPath': iconPath,
      'isBlocked': isBlocked,
    };
  }

  factory BlockedApp.fromJson(Map<String, dynamic> json) {
    return BlockedApp(
      packageName: json['packageName'] as String,
      appName: json['appName'] as String,
      iconPath: json['iconPath'] as String?,
      isBlocked: json['isBlocked'] as bool? ?? false,
    );
  }

  BlockedApp copyWith({
    String? packageName,
    String? appName,
    String? iconPath,
    bool? isBlocked,
  }) {
    return BlockedApp(
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      iconPath: iconPath ?? this.iconPath,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }
}
