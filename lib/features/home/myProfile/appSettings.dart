import 'package:e_shuttle/core/constants/app_dimensions.dart';
import 'package:e_shuttle/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({
    super.key,
    this.showAppBar = true,
  });

  /// Set this to false when using this screen inside bottom navigation.
  final bool showAppBar;

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  bool _isDarkMode = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('App Settings'),
              centerTitle: true,
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.pagePadding(context),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.maxContentWidth(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: ResponsiveHelper.value<double>(
                      context,
                      mobile: AppDimensions.lg,
                      tablet: AppDimensions.xl,
                      large: AppDimensions.xxl,
                    ),
                  ),

                  Text(
                    'App Settings',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.sectionTitleSize(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.lg),

                  _settingsTile(
                    title: 'Language',
                    trailing: DropdownButton<String>(
                      value: _selectedLanguage,
                      dropdownColor: Colors.blue,
                      underline: const SizedBox.shrink(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'English',
                          child: Text('English'),
                        ),
                        DropdownMenuItem(
                          value: 'Sinhala',
                          child: Text('Sinhala'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          _selectedLanguage = value;
                        });
                      },
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.md),

                  _settingsTile(
                    title: 'Dark Mode',
                    trailing: Switch(
                      value: _isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          _isDarkMode = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: AppDimensions.md),

                  _settingsTile(
                    title: 'Privacy Policy',
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: AppDimensions.iconSm,
                    ),
                    onTap: () {
                      // TODO: Navigate to privacy policy screen.
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable responsive setting tile.
  Widget _settingsTile({
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Colors.blue.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.sm,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.bodyTextSize(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: trailing,
      ),
    );
  }
}