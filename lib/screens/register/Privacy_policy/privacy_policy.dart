import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Privacy & Policy"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Privacy Policy ",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "The privacy policy enlisted here describes the way in which your data will be used by Playpointz.The collected data will be retained only for as long as the purpose for which it was shared remains valid. We place paramount importance on your privacy and assure you that all steps will be taken to uphold it at all stages. We recommend that you read the policy here before furnishing your details and by accessing our website and its services, we infer that you agree to its contents.  "),
                SizedBox(
                  height: 16,
                ),
                Text("Data collected by us",
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "The below data will be collected by us during the time of your registration on PlayPointz."),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "When you use Playpointz, we collect the content, communication, and other information that you provide when you sign up for an account when creating or sharing content, and when sending or communicating with others. Below parameters related to the content you see will also be collected, Views, engagement, actions, frequency and duration, Posts, videos and other content you view, Product purchase"),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "Information from the phone, computer, or tablet you use our Products on, like what kind it is and what version of our app you’re using."),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "Other device Information (such as computers and phones) cookie data (data from cookies stored on your device, including cookie IDs and settings) may also be collected. "),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "Data related to your online activity on the website, the ads and links that you chose to click may also be recorded."),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "How the information is used ",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "The data that is provided by you will be used for us to acknowledge you as a registered user of the Playpointz site and access other products and features offered by it. Data that we collect will be used for promotional purposes, marketing the products and additional features of the PlayPointz site."),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "Data will also be used for communication purposes; such as to inform you about the latest offers, information about your profile, the point-reward system, the latest updates and notifications about our products and your profile."),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "Data will also be used to create personalized products that are unique and relevant to you, we use your connections, preferences, interests and activities based on the data we collect and learn from you and others"),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "Information collected by us will not be used, sold or rented to third-party websites or marketers without your consent."),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "We do not use your financial information for any purpose other than that of transactions. All bank transactions are carried out under the governing laws and policies of the Democratic Socialist Republic of Sri Lanka."),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "We keep information for as long as we need it to provide a feature or service. But you can request that we delete your information. We’ll delete that information unless we have to keep it for something else, like for legal reasons."),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Data Security ",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "Details collected will be stored in secure locations in our premises or in network systems that are in our control. Your data will be safeguarded at all times with sufficient measures."),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Data Rights",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "We recommend that you use all the information on the Setting Page to make your Playpointz service more efficient. You can delete or modify your data on the Settings page."),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "We provide you with the ability to access, rectify, and delete your data."),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "In case you are unable to, at any point during usage, you may request us to forego the data records collected by us. However, any data we are obliged to retain for legal, administrative, legal or security purposes will be exempted from this."),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "Further, we assure you that the data collected will only be used in the manner prescribed by this privacy policy. You may unsubscribe from our promotional emails or notifications at any time. You may opt-out of receiving our promotional material at any given time."),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Data Deletion Request",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "Users have the right to request the deletion of their personal data stored by the App. To submit a data deletion request, users can follow these steps:"),
                SizedBox(
                  height: 16,
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600),
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.circle_rounded,
                          size: 8.sp,
                        ),
                      ),
                      TextSpan(text: ' Open the App.'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600),
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.circle_rounded,
                          size: 8.sp,
                        ),
                      ),
                      TextSpan(
                          text:
                              ' Navigate to the Menu > Profile > Profile Settings section.'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600),
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.circle_rounded,
                          size: 8.sp,
                        ),
                      ),
                      TextSpan(
                          text:
                              ' Locate and select the "Account delete" option.'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600),
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.circle_rounded,
                          size: 8.sp,
                        ),
                      ),
                      TextSpan(
                          text:
                              ' Follow the on-screen instructions to submit the request, which may include verifying your identity.'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                          text:
                              'Alternatively, users can contact our Data Protection Officer at '),
                      TextSpan(
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          text: ' dpo@playpointz.com'),
                      TextSpan(text: ' to request data deletion.'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Data Deletion Process",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "Upon receiving a valid data deletion request, we will process the request as follows:"),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "Verify the request: We may need to verify the identity of the person making the request to ensure the security and privacy of the data involved."),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "Identify and delete data: We will identify and delete all personal data associated with the requesting user, including any copies stored in backup systems, as soon as reasonably practicable."),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Data Retention",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "We will retain user data only for as long as necessary to fulfill the purposes for which it was collected, or as required by applicable laws and regulations. After the retention period expires, we will securely delete or anonymize the data."),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Exceptions",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "There may be circumstances where we are unable to fulfill a data deletion request, such as when it is necessary to retain certain data for legal or legitimate business reasons. In such cases, we will inform the user of the reasons for the denial."),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Changes to this Policy",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "We reserve the right to update this Data Deletion Policy at any time. Any changes to this Policy will be communicated to users through the App or other appropriate channels. Users are encouraged to review this Policy periodically."),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Contact Information",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                ),
                SizedBox(
                  height: 16,
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                          text:
                              'For any questions, concerns, or requests related to data deletion, please contact our Data Protection Officer at:'),
                      TextSpan(
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          text: ' dpo@playpointz.com'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Conclusion",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "We are committed to protecting the privacy and data security of our users. This Data Deletion Policy outlines our procedures for handling data deletion requests and provides transparency on how user data is managed within the App. Users are encouraged to read and understand this Policy, and we appreciate their trust in us to protect their personal information."),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Third Parties and Vendors ",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "The data that you provide may be shared with third-party vendors for promotional or marketing purposes. We will also use it for measurement, analytics, and other business services to help advertisers and other partners measure the effectiveness and distribution of their ads and services and understand the types of people who use their services and how people interact with their websites, apps, and services."),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Prevention of Fraudulent acts ",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "We respond to legal requests in accordance and compliance with the jurisdiction of Sri Lanka; in the detection and prevention of fraud, unauthorized use of products, violation of our terms or policies or other harmful or illegal activities; We may use your account's information with third parties for legal action to prevent fraud, abuse and other harmful activities on our products."),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Copyright",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                    "Playpointz reserves the right to change or update this policy at any time. Such changes shall be effective immediately upon posting to the Site."),
                SizedBox(
                  height: 16,
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          text: '*Disclaimer :'),
                      TextSpan(
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500),
                          text:
                              ' Although we wish to safeguard the confidentiality of your personally identifiable information, transmissions made through the Internet cannot be made secure. By using this site, you agree that we are not liable for the disclosure of your information due to errors in transmission or unauthorized acts of third parties.'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ));
  }
}
