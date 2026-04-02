import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Fond clair CityFix DZ
      body: Column(
        children: [
          // --- HEADER BLEU DÉGRADÉ ---
          _buildHeader(context),

          // --- LISTE DES LANGUES ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "select_language".tr(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLanguageCard(
                    context,
                    title: "Français",
                    subTitle: "French",
                    locale: const Locale('fr'),
                    flag: "🇫🇷",
                  ),
                  _buildLanguageCard(
                    context,
                    title: "English",
                    subTitle: "English",
                    locale: const Locale('en'),
                    flag: "🇬🇧",
                  ),
                  _buildLanguageCard(
                    context,
                    title: "العربية",
                    subTitle: "Arabic",
                    locale: const Locale('ar'),
                    flag: "🇩🇿", 
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour le Header dégradé
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2B58E4), Color(0xFF448AFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            "settings".tr(), // "settings": "Paramètres"
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          Text(
            "language".tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour les cartes de langue
  Widget _buildLanguageCard(
    BuildContext context, {
    required String title,
    required String subTitle,
    required Locale locale,
    required String flag,
  }) {
    bool isSelected = context.locale == locale;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: const Color(0xFF2B58E4).withOpacity(0.1),
          highlightColor: const Color(0xFF2B58E4).withOpacity(0.05),
          onTap: () => context.setLocale(locale),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? const Color(0xFF2B58E4) : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(flag, style: const TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      subTitle,
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                  ],
                ),
                const Spacer(),
                if (isSelected)
                  const Icon(
                    Icons.check_circle, 
                    color: Color(0xFF2B58E4), 
                    size: 28
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}