import 'package:flutter/material.dart';
import 'package:prufcoach/core/localStorage/user_storage.dart';
import 'package:prufcoach/core/utils/asset_pathes.dart';
import 'package:prufcoach/views/widgets/setting_button.dart';
import 'package:prufcoach/views/widgets/social_button.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  _loadUserName() async {
    final name = await UserStorage.getFullName();
    if (mounted) {
      setState(() {
        _userName = name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue,
                    child: Image.asset(
                      'assets/icons/profile_ic.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 30),
                  Text(
                    _userName ?? "Benutzer",
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Settings title
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Einstellungen",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Settings items
            Expanded(
              child: ListView(
                children: [
                  settingsItem(
                    icon: Icons.language,
                    text: "Sprache",
                    onTap: () {
                      Navigator.pushNamed(context, "/language");
                    },
                  ),
                  settingsItem(
                    icon: Icons.notifications,
                    text: "Benachrichtigungen",
                    onTap: () {
                      Navigator.pushNamed(context, "/notifications");
                    },
                  ),
                  settingsItem(
                    icon: Icons.help_outline,
                    text: "FAQ (Häufige Fragen)",
                    onTap: () async {
                      final url = Uri.parse("https://yourfaqpage.com");
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                  ),
                  settingsItem(
                    icon: Icons.support_agent,
                    text: "Kontakt aufnehmen",
                    onTap: () {
                      Navigator.pushNamed(context, "/contact");
                    },
                  ),
                  settingsItem(
                    icon: Icons.feedback_outlined,
                    text: "Feedback senden",
                    onTap: () {
                      Navigator.pushNamed(context, "/feedback");
                    },
                  ),
                  settingsItem(
                    icon: Icons.share,
                    text: "Mit Freunden teilen",
                    onTap: () {
                      // Share feature
                    },
                  ),
                  settingsItem(
                    icon: Icons.person_remove,
                    text: "Konto löschen",
                    onTap: () {
                      // Delete account confirmation
                    },
                  ),
                ],
              ),
            ),

            // Social links
            const SizedBox(height: 10),
            const Text("Folge uns"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialButton(
                  url: "https://instagram.com",
                  imagePath: AssetPaths.instagramIcon,
                ),
                const SizedBox(width: 10),
                SocialButton(
                  url: "https://x.com",
                  imagePath: AssetPaths.twitterIcon,
                ),

                const SizedBox(width: 10),
                SocialButton(
                  url: "https://facebook.com",
                  imagePath: AssetPaths.facebookIcon,
                ),
                const SizedBox(width: 10),

                SocialButton(
                  url: "https://youtube.com",
                  imagePath: AssetPaths.youtubeIcon,
                ),
                const SizedBox(width: 10),
                SocialButton(
                  url: "https://prufcoach.com",
                  imagePath: AssetPaths.prufCoachIcon,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
