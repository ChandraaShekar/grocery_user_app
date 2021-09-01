import 'package:flutter/material.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';

class Policy extends StatefulWidget {
  @override
  _PolicyState createState() => _PolicyState();
}

class _PolicyState extends State<Policy> {

  String policy='''
FRUTTE PRIVACY NOTE TO THE USERS:

1.Introduction :
while using Frutte, you trust us with your private data. We pledge to keep that trust. That starts with assisting you understand our privacy practices.This note elaborates the private data we collect, how it’s used and shared, and your way out regarding this data.We request you to go through this along with our privacy overviews which highlights and describes the key points of our privacy practices.

2.Overview:
This note describes how Frutte collects and uses private data.This note appeals to all users of our apps, websites, features, or other services.
This notice specifically applies to: Delivery recipients: Individuals who request , order or receive food, or other products and services, including via Frutte.
This notice also governs Frutte's other collections of private information in connection with its services.In detail, we may acquire the contact information of individuals who use accounts owned by Frutte or of owners or employees of restaurants or other merchants; private data of those who start but do not finish applications to be drivers or delivery persons;or other personal data in connection with our navigation technology and features.

3. Data Controller and transfer: Frutte has it's own data controllers for the personal data collected in connection with use of Frutte services.Frutte operates, and processes personal data. Frutte may also transfer such data to locations other than the one where our users live or use Frutte services.We do so in order to fulfill our agreements with users, such as our Terms of Use, or based on users’ prior consent, adequacy decisions for the relevant locations.
Questions, comments, and complaints about Frutte data practices can be submitted here. You may also use this form to submit a question to the Frutee Data Protection Executive.

4.Data collections and uses:A). The data Frutte collect:I)Frutte collects personal data: Provided by users to Frutte, during account creation.Created during use of our services, such as location, app usage, and device data.From other sources, such as other users or account owners, business partners, vendors,insurance and financial solution providers, and governmental authorities.
B). Data collections and uses:Provided by users to Frutte, during account creation:I)User profile: We collect data when users create or update their Uber accounts. This may include their name, email, phone number, login name and password, address, profile picture, payment or banking information (including related payment verification information),
II) Demographic data: We consider this option for collecting data about users, including through user surveys. In some locations, we may also receive demographic data about users from third parties.
III )User content: We collect the data submitted by users when they contact Frutte customer support ( Chats , Calls and emails) , provide ratings or compliments for other users, restaurants or merchants, or otherwise contact Frutee. This may include feedback, photographs or other information collected by users, including picture , written format )submitted by users in connection with customer support.

5.Travel information: We collect travel itinerary information, including the times and dates of upcoming orders, from users of our Frutte Travel feature.We collect such information:(A) When users manually input their information in the app(B) If authorized by users to access their Gmail accounts, from travel-related email confirmations. If so authorized, Frutte will only access users’ Gmail accounts to collect tracking information to enable the Frutte Travel feature, and will adhere to Google’s API Services User Data Policy, including the limitations on use of data collected from users’ Gmail accounts.(C) Data created during use of our services.This includes:I) Location data (Delivery recipients): We collect delivery recipients data on precise or approximate location data to enable and enhance use of our apps, including to improve pick-ups, facilitate deliveries, enable safety features, and prevent and detect fraud.We collect such data from user’s mobile devices if they enable us to do so. “Choice and transparency” is briefly described on how riders and delivery recipients can enable location data collection. Frutte collects such data from the time a ride or delivery is requested until it is finished (and may indicate such collection via an icon or notification on your mobile device depending on your device’s operating system), and any time the app is running in the foreground (app open and on-screen) of their mobile device.
Riders and delivery recipients may use the Frutte apps without enabling Frutte to collect precise location data from their mobile devices. However, this may affect features in the Frutte app.For example, a user who has not enabled location data collection will have to manually enter their pick-up address. In addition, the location data collected from a driver during a trip will be linked to the rider’s account, even if the rider has not enabled location data to be collected from their device, including for purposes of receipt generation, customer support, fraud detection, insurance, and litigation.
II)Transaction information: We collect transaction information related to the use of our services, including the type of services requested or provided, order details, payment transaction information (such as a restaurant’s or merchant's name and location and amount of transaction), delivery information, date and time the service was provided, amount charged, distance traveled, and payment method. Additionally, if someone uses your promotion code, we may associate your name with that person.
III)Communications data: We enable users to communicate with each other and Frutee through Frutte mobile apps and websites. For example, we enable drivers and riders, and delivery persons and delivery recipients, to call, text, or send other files to each other (generally without disclosing their telephone numbers to each other).To provide this service, Frutte receives some data regarding the calls, texts, or other communications, including the date and time of the communications and the content of the communications. Uber may also use this data for customer support services (including to resolve disputes between users), for safety and security purposes, to improve our services and features, and for analytics.
B. How we use personal data:
This includes using data to:
1) create/update accounts2)Enable transportation and delivery services (such as using location data to facilitate a pick up or delivery), features that involve data sharing (such as fare splitting, ETA sharing, and ratings and compliments), and accessibility features to facilitate use of our services by those with disabilitiesprocess payments.3) Track and share the progress of rides or deliveries4) Personalize user’s accounts. We may, for example, present a Frutte user with personalized restaurant or food recommendations based on their prior orders.
C. Cookies and third-party technologies:Frutee and use cookies and other identification technologies on our apps, websites, emails, and online ads for purposes described in this notice, and Frutte's Cookie Notice.
Cookies are small text files that are stored on browsers or devices by websites, apps, online media, and advertisements. Frutte uses cookies and similar technologies for purposes such as:
1)Authenticating users.2)Remembering user preferences and settings.3)Determining the popularity of content.4)Delivering and measuring the effectiveness of advertising campaigns.5)Analyzing site traffic and trends, and generally understanding the online behaviors and interests of people who interact with our services.

6. Updates to this notice:We may occasionally update this notice.
We may occasionally update this notice. If we make significant changes, we will notify users in advance of the changes through the Frutte apps or through other means, such as email. We encourage users to periodically review this notice for the latest information on our privacy practices.
Use of our services after an update constitutes consent to the updated notice to the extent permitted by law.


  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header.appBar(Constants.tncTag, null, true),
        body: SingleChildScrollView(
            child:Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(policy),
            )));
  }
}
