import 'package:flutter/material.dart';
import 'package:zerowaste/backend/firestore_info.dart';
import 'package:zerowaste/frontend/Helpers/analytics/custom_container.dart';

class Company extends StatefulWidget {
  const Company({Key? key}) : super(key: key);

  @override
  State<Company> createState() => _Company();
}

class _Company extends State<Company> {
  int totConsumer = 0,
      totalNGO = 0,
      totManu = 0,
      prodDonated = 0,
      resell = 0,
      prodSold = 0,
      user = 0;
  double air = 0.0, tree = 0.0, co2 = 0.0;

  getStakeHolderAnalytics() async {
    var res1 = await FirebaseData().CompanyTotalConsumer();
    var res2 = await FirebaseData().CompanyTotalManu();
    var res3 = await FirebaseData().CompanyTotalNGO();
    var res4 = await FirebaseData().TotalProds();
    double res5 = await FirebaseData().CompanyESVCo2();
    var res6 = await FirebaseData().CompanyESVAir();
    var res7 = await FirebaseData().CompanyESVTree();
    setState(() {
      totConsumer = res1;
      totManu = res2;
      totalNGO = res3;
      prodSold = res4;
      co2 = res5;
      air = res6;
      tree = res7;
    });
  }

  @override
  void initState() {
    getStakeHolderAnalytics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Overall Analytics")),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("All Users", style: const TextStyle(fontSize: 16)),
              CustomContainer(
                  subtype: const ["Consumers", "Manufacturer", "NGOs"],
                  subtypeVal: [totConsumer, totManu, totalNGO]),
              Text("Total Transactions", style: const TextStyle(fontSize: 16)),
              CustomContainer(
                  subtype: const ["Products Sold", "Products Resold"],
                  subtypeVal: [prodSold, resell]),
              Text("Environment Saving Values",
                  style: const TextStyle(fontSize: 16)),
              CustomContainer(
                  subtype: const ["Air", "Co2", "Trees"],
                  subtypeVal: [air.toInt(), co2.toInt(), tree.toInt()])
            ],
          ),
        ));
  }
}
