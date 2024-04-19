import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_algo/ml_algo.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ml_dataframe/ml_dataframe.dart';

Future<int> predictScore(
    {required num distance,
    required int category,
    required String type,
    required int status}) async {
  final encodedModel = await rootBundle.loadString('assets/score_system.json');
  final loadedModel = LinearRegressor.fromJson(encodedModel);
  final reportData = [
    ['distance', 'category', 'type', 'status'],
    [distance, category, type, status],
  ];

  final dataframe = DataFrame(reportData);

  // Loading the dataset
  final csvContent = await rootBundle.loadString('assets/data.csv');
  final data = DataFrame.fromRawCsv(csvContent, fieldDelimiter: ',');
  // // applying one-hot encoding on type
  final encoder = Encoder.oneHot(
    data,
    columnNames: ['type'],
  );
  final encodedUnlabelledData = encoder.process(dataframe);

  //predict the score
  final predictionDataFrame = loadedModel.predict(encodedUnlabelledData);
  var predictionString = predictionDataFrame.rows.toString();
  String numberString =
      predictionString.replaceAll('(', '').replaceAll(')', '');

  final predictedScore = double.parse(numberString).round();

  return predictedScore;
}
