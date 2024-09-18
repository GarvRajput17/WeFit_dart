import 'package:flutter/material.dart';
import 'package:wefit/components/customcolor.dart';

class SleepPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ideal Sleep Time', style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: TColor.primaryColor1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildImage(),
            _buildSectionTitle('Why 8 Hours?'),
            _buildTextContent(),
            _buildSectionTitle('Benefits of Adequate Sleep'),
            _buildBenefitsList(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Why You Need at Least 8 Hours of Sleep',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: TColor.primaryColor1,
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Image.asset(
          'lib/images/moon.png',
          height: 200,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: TColor.primaryColor1,
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        'Getting at least 8 hours of sleep each night is crucial for maintaining overall health and well-being. '
            'During sleep, your body and mind undergo restorative processes that support cognitive function, mood stability, and physical health. '
            'Inadequate sleep can lead to various health issues, including increased risk of chronic conditions such as heart disease, diabetes, and obesity.',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
    );
  }

  Widget _buildBenefitsList() {
    final benefits = [
      'Improves cognitive function and memory.',
      'Boosts mood and emotional resilience.',
      'Supports healthy weight management.',
      'Enhances immune system function.',
      'Reduces the risk of chronic diseases.',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: benefits.map((benefit) => ListTile(
          leading: Icon(Icons.check_circle, color: TColor.primaryColor1,),
          title: Text(benefit, style: TextStyle(fontSize: 16)),
        )).toList(),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Make sleep a priority in your daily routine. Aim for at least 8 hours of restful sleep each night to reap the many benefits it offers!',
        style: TextStyle(
          fontSize: 16,
          fontStyle: FontStyle.italic,
          color: TColor.primaryColor1,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
