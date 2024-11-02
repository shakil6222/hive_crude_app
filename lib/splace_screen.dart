import 'package:flutter/material.dart';
import 'package:hive_crude_app/home_scree.dart';

class SplaceScreen extends StatefulWidget {
  const SplaceScreen({super.key});

  @override
  State<SplaceScreen> createState() => _SplaceScreenState();
}

class _SplaceScreenState extends State<SplaceScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2),() {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScree()), (route) => false,);
    },);
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircleAvatar(backgroundColor: Colors.green,radius: 50,),),
    );
  }
}
