import 'package:flutter/material.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';
import 'package:saghi/widget/app_text.dart';

class BottomSheetDesign extends StatelessWidget {
  const BottomSheetDesign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(getProportionateScreenHeight(20)),
      child: Column(
        children: [
          SizedBox(height: SizeConfigManger.bodyHeight*.1,),
          Align(
              alignment: AlignmentDirectional.topStart,
              child: AppText(text: "Share audio to :",textSize: 22,fontWeight: FontWeight.bold,)),
          SizedBox(height: SizeConfigManger.bodyHeight*.06,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: (){},
                child: buildDesign(color:const Color(0xff22DF1E),icon: "assets/icons/whats-vector.png"),
              ),
              InkWell(
                onTap: (){},
                child:  buildDesign(color: const Color(0xff2182C9),icon: "assets/icons/telegram.png"),
              ),
              InkWell(
                onTap: (){},
                child: buildDesign(color: const Color(0xff52D74F),icon: "assets/icons/msg.png"),
              ),
              InkWell(
                onTap: (){},
                child: buildDesign(color: Colors.transparent,icon: "assets/icons/more.png"),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget buildDesign({required Color color , required String icon}){
    return SizedBox(
      height: SizeConfigManger.bodyHeight*.1,
      width: SizeConfigManger.bodyHeight*.1,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(getProportionateScreenHeight(10)),
            color: color,
            border: Border.all(color: Colors.grey),
            image: DecorationImage(
              image: AssetImage(icon),
            )

        ),

      ),
    );
  }
}
