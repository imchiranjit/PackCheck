import 'package:flutter/material.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('New Scan'),
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: NutritionContent(),
      ),
    );
  }
}

class NutritionContent extends StatelessWidget {
  const NutritionContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Honey Nut Cereal',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.check,
              color: Colors.green[600],
              size: 24,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Info cards row
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                context: context,
                color: const Color(0xFFFFF8E1),
                iconColor: Colors.orange,
                icon: Icons.warning_amber_rounded,
                text: 'Consume Moderately',
                hasShadow: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoCard(
                context: context,
                color: const Color(0xFFE3F2FD),
                iconColor: Colors.blue,
                icon: Icons.food_bank,
                text: '25g',
                textAlign: TextAlign.center,
                hasShadow: true,
                extraText: "Recommended Serving",
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Health Concerns Section
        _buildSection(
          title: 'Health Concerns',
          backgroundColor: const Color(0xFFFFEBEE),
          textColor: Colors.red[700]!,
          items: const ['High in added sugars'],
          borderColor: Colors.red[200]!,
        ),
        const SizedBox(height: 16),

        // Benefits Section
        _buildSection(
          title: 'Benefits',
          backgroundColor: const Color(0xFFE8F5E9),
          textColor: Colors.green[700]!,
          items: const [
            'Good source of fiber',
            'Contains essential vitamins',
          ],
          borderColor: Colors.green[200]!,
        ),
        const SizedBox(height: 24),

        // Nutrition Facts Section
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nutrition Facts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildNutritionTable(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required Color color,
    required Color iconColor,
    required IconData icon,
    required String text,
    String? extraText,
    TextAlign textAlign = TextAlign.left,
    bool hasShadow = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60, // Width of the circle
            height: 60, // Height of the circle
            decoration: BoxDecoration(
              color: color, // Background color
              shape: BoxShape.circle, // Circular shape
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: textAlign,
            style: TextStyle(
              color: iconColor,
              fontSize: 14 + (extraText != null ? 4 : 0),
              fontWeight:
                  (extraText != null ? FontWeight.w900 : FontWeight.w500),
            ),
          ),
          extraText != null
              ? Text(
                  extraText,
                  textAlign: textAlign,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Color backgroundColor,
    required Color textColor,
    required List<String> items,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildNutritionTable() {
    final nutritionData = {
      'Calories': '120',
      'Sugar': '12mg',
      'Fiber': '2mg',
      'Protein': '3mg',
      'Sodium': '140mg',
    };

    return Column(
      children: nutritionData.entries.map((entry) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.black12,
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                entry.key,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                entry.value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
