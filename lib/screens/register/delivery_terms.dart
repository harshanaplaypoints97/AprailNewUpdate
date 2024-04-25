import 'package:flutter/material.dart';

class DeliveryTermsConditions extends StatefulWidget {
  const DeliveryTermsConditions({Key key}) : super(key: key);

  @override
  State<DeliveryTermsConditions> createState() =>
      _DeliveryTermsConditionsState();
}

class _DeliveryTermsConditionsState extends State<DeliveryTermsConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Delivery Terms"),
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
                    "The following terms and conditions govern the delivery of items ordered through our PlayPointz app. By using our app and placing an order, you agree to be bound by these terms and conditions. Please read them carefully before placing an order."),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "DELIVERY AREAS ",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                    "We currently deliver to the following areas: Sri Lanka - Islandwide. If you are located outside of Sri Lanka, Sorry we will not deliver outside of Sri Lanka."),
                SizedBox(
                  height: 16,
                ),
                Text("DELIVERY TIMES",
                    style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(
                  height: 12,
                ),
                Text(
                    "We aim to deliver your order within 1 to 14 days from the date of redeem. However, delivery times may vary depending on the availability of the items and the delivery location. We will keep you informed of any delays."),
                SizedBox(
                  height: 16,
                ),
                Text("DELIVERY METHODS",
                    style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Home delivery",
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                          'We use reputable third-party courier services to deliver your order. Don\'t worry about the Delivery fees, it\'s totally FREE 😊'),
                      SizedBox(
                        height: 12,
                      ),
                      Text("Self Pickup",
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                          'Customers must visit the Playpointz Colombo store to pick up their non-deliverable items and ensure safe delivery'),
                      SizedBox(
                        height: 12,
                      ),
                      Text("Online",
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                          'It is necessary to provide accurate contact information to ensure that digital deliveries are received successfully.'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text("DELIVERY ADDRESS",
                    style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(
                  height: 12,
                ),
                Text(
                    'Please ensure that the delivery address you provide is accurate and complete (MUST). We will not be responsible for any delays or additional costs. '),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'We cancel all incorrect or incomplete delivery address items and we will not ship those  items because this is a FREE game and it\'s unfair to other players.', /* style:TextStyle(fontSize: 12,color: Colors.grey), */
                ),
                SizedBox(
                  height: 16,
                ),
                Text("DELIVERY CANCELLATION",
                    style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(
                  height: 12,
                ),
                Text(
                    'You will not be able to cancel your order after it has been placed.'),
                SizedBox(
                  height: 16,
                ),
                Text('DELIVERY LIMITATIONS',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(
                  height: 12,
                ),
                Text(
                    'We reserve the right to limit the quantity of Items that can be ordered for delivery. We also reserve the right to refuse delivery to any location or person for any reason of privacy policy.'),
                SizedBox(
                  height: 16,
                ),
                Text('FORCE MAJEURE',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(
                  height: 12,
                ),
                Text(
                    'We will not be liable for any delay or failure to deliver your order due to events beyond our control, including but not limited to natural disasters, war, terrorism, and strikes. We are not responsible after shipping your order. '),
                SizedBox(
                  height: 16,
                ),
                Text('DISCLAIMER',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(
                  height: 12,
                ),
                Text(
                    'We make every effort to ensure that your order is delivered on time and in good condition. However, we cannot be held responsible for any losses or damages arising from the delivery of your order.'),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ));
  }
}
