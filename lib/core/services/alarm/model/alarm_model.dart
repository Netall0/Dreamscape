// //not used now


// final class AlarmModel {
//   final int id;
//   final int hour;
//   final int minute;
//   final String label;
//   final bool isEnabled;

//   const AlarmModel({
//     required this.id,
//     required this.hour,
//     required this.minute,
//     required this.label,
//     this.isEnabled = true,
//   });

//   String get formattedTime =>
//       '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';



//   AlarmModel copyWith({
//     int? id,
//     int? hour,
//     int? minute,
//     String? label,
//     bool? isEnabled,
//   }) {
//     return AlarmModel(
//       id: id ?? this.id,
//       hour: hour ?? this.hour,
//       minute: minute ?? this.minute,
//       label: label ?? this.label,
//       isEnabled: isEnabled ?? this.isEnabled,
//     );
//   }
// }
