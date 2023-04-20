// ignore_for_file: camel_case_types, constant_identifier_names

import 'package:flutter/services.dart';

// import 'dialog.dart';

class ExportHelper {
  static const _PATH_METHOD_CALL = 'com.example.attendance_app/path';
  static const _platform = MethodChannel(_PATH_METHOD_CALL);
  static const _PDF_PATH = 'getPdfPath';
  static const _EXCEL_PATH = 'getExcelPath';
  static const _BACKUP_PATH = 'getBackupPath';

  static Future<String?> getPdfPath() {
    return _platform.invokeMethod<String>(_PDF_PATH);
  }

  static Future<String?> getExcelPath() {
    return _platform.invokeMethod<String>(_EXCEL_PATH);
  }

  static Future<String?> getBackupPath() {
    return _platform.invokeMethod<String>(_BACKUP_PATH);
  }
}

class AndroidVersion {
  static const _VERSION_METHOD_CALL = 'com.example.attendance_app/version';
  static const _platform = MethodChannel(_VERSION_METHOD_CALL);
  static const _VERSION = 'getVersion';

  static Future<int?> getVersion() {
    return _platform.invokeMethod<int>(_VERSION);
  }
}

class VERSION_CODES {
  static const BASE = 1;
  static const BASE_1_1 = 2;
  static const CUPCAKE = 3;
  static const CUR_DEVELOPMENT = 10000;
  static const DONUT = 4;
  static const ECLAIR = 5;
  static const ECLAIR_0_1 = 6;
  static const ECLAIR_MR1 = 7;
  static const FROYO = 8;
  static const GINGERBREAD = 9;
  static const GINGERBREAD_MR1 = 10;
  static const HONEYCOMB = 11;
  static const HONEYCOMB_MR1 = 12;
  static const HONEYCOMB_MR2 = 13;
  static const ICE_CREAM_SANDWICH = 14;
  static const ICE_CREAM_SANDWICH_MR1 = 15;
  static const JELLY_BEAN = 16;
  static const JELLY_BEAN_MR1 = 17;
  static const JELLY_BEAN_MR2 = 18;
  static const KITKAT = 19;
  static const KITKAT_WATCH = 20;
  static const LOLLIPOP = 21;
  static const LOLLIPOP_MR1 = 22;
  static const M = 23;
  static const N = 24;
  static const N_MR1 = 25;
  static const O = 26;
  static const O_MR1 = 27;
  static const P = 28;
  static const Q = 29;
  static const R = 30;
  static const S = 31;
  static const S_V2 = 32;
}

// Future<bool?> showPdfDialog(
//         BuildContext context, String range, String category, String payment) =>
//     showCustomDialog<bool>(
//       context: context,
//       title: 'Do you want to export as PDF ?',
//       content: '',
//       body: (style) => Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Range', style: style),
//                   Text('Category', style: style),
//                   Text('Mode', style: style),
//                 ],
//               ),
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(' :  ', style: style),
//                   Text(' :  ', style: style),
//                   Text(' :  ', style: style),
//                 ],
//               ),
//               Expanded(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         range,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: style,
//                         textAlign: TextAlign.start,
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         category,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: style,
//                         textAlign: TextAlign.start,
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         payment,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: style,
//                         textAlign: TextAlign.start,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text('Note : ', style: style),
//           Text(
//             'PDF will be saved under "Internal storage/ExpinBook/PDF"',
//             style: style.copyWith(fontSize: 14.5),
//             textAlign: TextAlign.start,
//           ),
//         ],
//       ),
//       actionsBuilder: (ctx) => [
//         CustomDialogAction(
//           onTap: () => Navigator.pop(ctx),
//           text: 'Cancel',
//         ),
//         CustomDialogAction(
//           text: 'Export',
//           onTap: () => Navigator.pop(ctx, true),
//         ),
//       ],
//     );
