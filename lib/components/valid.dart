import 'package:email_validator/email_validator.dart';
import 'package:explore_pc/constant/messagevalid.dart';

vaildInput(String val, int min, int max) {
  if (val.isEmpty) {
    return "$MessageInputEmpty";
  }
  if (val.length > max) {
    return "$MessageInputMax  $max";
  }
  if (val.length < min) {
    return "$MessageInputMin  $min";
  }
}

vaildInputemail(String val, int min, int max) {
  if (val.isEmpty) {
    return "$MessageInputEmpty";
  }
  if (val.length > max) {
    return "$MessageInputMax  $max";
  }
  if (val.length < min) {
    return "$MessageInputMin  $min";
  }
  if (!EmailValidator.validate(val)) {
    return "$MessageInputemail  $val";
  }
}

String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'حقل الهاتف مطلوب';
  }

  // التحقق من أن الرقم يبدأ بـ 77 أو 78 أو 73 أو 71 أو 70
  if (!RegExp(r'^(77|78|73|71|70)').hasMatch(value)) {
    return 'يجب أن يبدأ رقم الهاتف بـ 77, 78, 73، 70 , 71';
  }

  // التحقق من أن الرقم يحتوي على أرقام فقط
  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return 'يجب أن يحتوي رقم الهاتف على أرقام فقط';
  }

  // التحقق من طول الرقم (مثال: 10 أرقام)
  if (value.length != 9) {
    return 'يجب أن يتكون رقم الهاتف من 9 أرقام';
  }

  return null;
}
