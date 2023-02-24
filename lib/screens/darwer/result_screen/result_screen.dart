import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saghi/models/emotion_model.dart';
import 'package:saghi/screens/layout/speech_to_text/cubit/speech_cubit.dart';
import 'package:saghi/widget/app_text.dart';
import 'package:saghi/widget/emotion_deisgn.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../shared/helper/mangers/size_config.dart';

class ResultHistoryScreen extends StatelessWidget {
  final String id;

  const ResultHistoryScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpeechCubit()..getFavItemData(docId: id),
      child: BlocConsumer<SpeechCubit, SpeechState>(
        listener: (context, state) {},
        builder: (context, state) {
          SpeechCubit cubit = SpeechCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              leading: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back,
                      color: Color.fromRGBO(68, 84, 106, 1))),
            ),
            body: state is GetFavItemsLoading?
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SafeArea(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: SizeConfigManger.bodyHeight * .02),
                          Container(
                            height: SizeConfigManger.bodyHeight * .25,
                            padding: const EdgeInsets.all(20),
                            width: SizeConfigManger.screenWidth * 0.8,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(
                                    getProportionateScreenHeight(20))),
                            child: AppText(
                              color: Colors.black,
                              textSize: 22,
                              maxLines: 20,
                              text: "${cubit.audioModel2!.text}.",
                            ),
                          ),
                          SizedBox(height: SizeConfigManger.bodyHeight * .02),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfigManger.bodyHeight * .05),
                            child: Align(
                                alignment: AlignmentDirectional.topStart,
                                child: AppText(
                                    text: "Speaker is mostly:",
                                    fontWeight: FontWeight.w500,
                                    textSize: 22)),
                          ),
                          EmotionDesign(cubit.emotionResultModel!),
                          SizedBox(height: SizeConfigManger.bodyHeight * .02),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: SizeConfigManger.bodyHeight * .02),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(
                                    getProportionateScreenHeight(20))),
                            child: Column(
                              children: [
                                SfCartesianChart(
                                  primaryXAxis: CategoryAxis(
                                    isVisible: false,
                                  ),
                                  axes: [],
                                  primaryYAxis: NumericAxis(
                                    isVisible: false,
                                  ),
                                  enableAxisAnimation: true,
                                  series: <ChartSeries>[
                                    ColumnSeries<EmotionModel, String>(
                                      dataSource: cubit.listEmotionModel,
                                      xValueMapper: (EmotionModel model, _) =>
                                          model.title,
                                      yValueMapper: (EmotionModel model, _) =>
                                          model.value,
                                      pointColorMapper: (data, _) => data.color,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                        width:
                                            SizeConfigManger.screenWidth * .05),
                                    EmotionDesign(emojiList[0]),
                                    SizedBox(
                                        width:
                                            SizeConfigManger.screenWidth * .07),
                                    EmotionDesign(emojiList[1]),
                                    SizedBox(
                                        width:
                                            SizeConfigManger.screenWidth * .05),
                                    EmotionDesign(emojiList[2]),
                                    SizedBox(
                                        width:
                                            SizeConfigManger.screenWidth * .05),
                                    EmotionDesign(emojiList[3]),
                                    SizedBox(
                                        width:
                                            SizeConfigManger.screenWidth * .05),
                                    EmotionDesign(emojiList[4]),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: SizeConfigManger.bodyHeight * .02),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
