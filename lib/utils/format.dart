// ابزارهای فارسی‌سازی اعداد و قیمت
String toFaDigits(String input) {
  const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  var out = input;
  for (var i = 0; i < 10; i++) {
    out = out.replaceAll(en[i], fa[i]);
  }
  return out;
}

/// 3500000000 -> ۳٬۵۰۰٬۰۰۰٬۰۰۰ تومان
String formatPriceFa(int price) {
  final s = price.toString();
  final buf = StringBuffer();
  int count = 0;
  for (int i = s.length - 1; i >= 0; i--) {
    buf.write(s[i]);
    count++;
    if (count % 3 == 0 && i != 0) buf.write('٬');
  }
  final reversed = buf.toString().split('').reversed.join();
  return '${toFaDigits(reversed)} تومان';
}

String formatAreaFa(int area) => '${toFaDigits(area.toString())} متر';
