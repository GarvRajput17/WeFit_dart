import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wefit/components/rbutton.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _issueController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedEmailService = 'Gmail';

  @override
  void dispose() {
    _titleController.dispose();
    _issueController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _sendEmail() {
    if (_formKey.currentState!.validate()) {
      String emailBody =
          'Title: ${_titleController.text}\n\nIssue: ${_issueController.text}\n\nDescription: ${_descriptionController.text}';
      String emailSubject = 'Grievance/Issue';

      String emailUrl;
      switch (_selectedEmailService) {
        case 'Gmail':
          emailUrl = 'mailto:?subject=$emailSubject&body=$emailBody';
          break;
        case 'Outlook':
          emailUrl = 'mailto:?subject=$emailSubject&body=$emailBody';
          break;
        case 'Apple Mail':
          emailUrl = 'mailto:?subject=$emailSubject&body=$emailBody';
          break;
        default:
          emailUrl = 'mailto:?subject=$emailSubject&body=$emailBody';
      }

      _launchURL(emailUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us', style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact Us Through',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.email),
                    onPressed: () {
                      _launchURL('mailto:your-email@example.com');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.mail_outline),
                    onPressed: () {
                      _launchURL('https://outlook.live.com/owa/');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.email_outlined),
                    onPressed: () {
                      _launchURL('https://mail.google.com/');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.web),
                    onPressed: () {
                      _launchURL('https://www.linkedin.com/in/yourprofile/');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.code),
                    onPressed: () {
                      _launchURL('https://github.com/yourusername');
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Grievances and Issues',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _issueController,
                      decoration: InputDecoration(
                        labelText: 'Issue',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the issue';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Send via',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedEmailService,
                      items: ['Gmail', 'Outlook', 'Apple Mail']
                          .map((service) => DropdownMenuItem(
                        value: service,
                        child: Text(service),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedEmailService = value!;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    RoundButton(
                      onPressed: _sendEmail,
                      title: 'Send',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}