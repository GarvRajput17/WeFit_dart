import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy for WeFit',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Welcome to WeFit. Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your personal information when you use our app.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '1. Information Collection',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• Personal Information: We may collect personal information such as your name, email address, and demographic information when you register for an account or use our services.\n'
                    '• Usage Data: We collect information about your interactions with the app, including workout activities, preferences, and app usage patterns.\n'
                    '• Device Information: We gather information about the device you use to access the app, such as IP address, device type, operating system, and unique device identifiers.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '2. Use of Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• Service Provision: We use your information to provide, maintain, and improve our services, including personalized workout recommendations and progress tracking.\n'
                    '• Communication: We may use your contact information to send you updates, newsletters, promotional materials, and other information related to our services.\n'
                    '• Analytics: We analyze usage data to understand user behavior and improve our app\'s functionality and user experience.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '3. Data Sharing and Disclosure',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• Third-Party Service Providers: We may share your information with third-party service providers who perform services on our behalf, such as analytics, marketing, and customer support.\n'
                    '• Legal Requirements: We may disclose your information if required by law, regulation, or legal process, or to protect the rights, property, or safety of our users or others.\n'
                    '• Business Transfers: In the event of a merger, acquisition, or sale of assets, your information may be transferred as part of the transaction.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '4. Data Security',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'We implement appropriate technical and organizational measures to protect your information from unauthorized access, loss, or misuse. However, please note that no method of transmission over the internet or electronic storage is completely secure.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '5. Data Retention',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'We retain your personal information for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required or permitted by law.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '6. Your Rights',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'You have the right to access, update, or delete your personal information. You may also object to or restrict the processing of your data. To exercise these rights, please contact us at [Your Contact Information].',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '7. Children\'s Privacy',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Our app is not intended for use by children under the age of 13. We do not knowingly collect personal information from children under 13. If we become aware that we have inadvertently collected such information, we will take steps to delete it.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '8. Changes to the Privacy Policy',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the effective date. Your continued use of the app after any changes constitutes your acceptance of the revised Privacy Policy.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}