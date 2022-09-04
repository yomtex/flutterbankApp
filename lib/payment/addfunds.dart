
import 'package:bankapp/payment/paystack.dart';
import 'package:flutter/material.dart';
class AddFunds extends StatefulWidget {
  const AddFunds({Key? key}) : super(key: key);

  @override
  State<AddFunds> createState() => _AddFundsState();
}

class _AddFundsState extends State<AddFunds> {


@override
void initState() {
}
  int _amount = 0;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( backgroundColor:Colors.purple,centerTitle: true,  title: Text("Add FUnds"),),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formkey, child: Column(
          children: [
            SizedBox(height: 30,),
          TextFormField(
            keyboardType: const TextInputType.numberWithOptions(decimal:true),
            controller: amount,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount',
                hintText: 'Amount'),
          ),
          SizedBox(height: 10),
          TextButton(onPressed: ()  async {
            if(formkey.currentState!.validate() && amount.text.isNotEmpty){
              _amount = int.parse(amount.text);
              print(_amount);
            }else{
              print("Enter valid details");
            }
          },
              child:
              Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.purple,borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("Add", textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
              )))
        ],),
        ),
      ),
    );
  }

}
