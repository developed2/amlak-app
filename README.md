# اپ املاک (Amlak App) — Flutter فارسی، آفلاین

اپ اندروید املاک با Flutter، راست‌چین و فارسی، بدون نیاز به سرور.

## امکانات
- لیست ملک‌ها + جستجو (عنوان/شهر/آدرس) + فیلتر (شهر، فروش/اجاره، نوع ملک، متراژ، سقف قیمت)
- صفحه جزئیات: گالری عکس، قیمت فارسی، متراژ، تماس با مالک (`tel:`)، دکمه نقشه
- ثبت آگهی جدید با عکس گالری یا لینک عکس — ذخیره لوکال با `shared_preferences`
- علاقه‌مندی‌ها (قلب) با ذخیره دائمی لوکال + امکان حذف آگهی‌های خودم
- نقشه OpenStreetMap با `flutter_map` (بدون API Key) — مارکر همه آگهی‌های فیلترشده
- ۱۰ آگهی نمونه واقعی‌نما: تهران، کرج، اصفهان، شیراز، مشهد، تبریز، رشت

## ساختار
```
lib/
  main.dart                 # نقطه شروع + تب‌ها (خانه/نقشه/ثبت/علاقه‌مندی)
  models/property.dart      # مدل + enum + toJson/fromJson
  data/sample_data.dart     # ۱۰ ملک نمونه + لیست شهرها
  providers/app_state.dart  # state با Provider + فیلتر + persistence
  screens/home_screen.dart
  screens/detail_screen.dart
  screens/add_screen.dart
  screens/favorites_screen.dart
  screens/map_screen.dart
  widgets/property_card.dart
  widgets/filter_sheet.dart
  utils/format.dart         # اعداد فارسی + فرمت قیمت
```

## اجرا (روی سیستم خودت — چون اینجا Flutter مسدود/نصب نیست)

۱. نصب Flutter (3.22 به بالا) + Android Studio + JDK 17:
   - https://docs.flutter.dev/get-started/install/windows
   - با VPN/شکن چون `storage.googleapis.com` در ایران تحریم است.
۲. بررسی:
```powershell
flutter doctor
```
۳. اجرای اپ:
```powershell
cd C:\Users\parsi\Desktop\007\amlak_app
flutter pub get
flutter run
```
۴. ساخت APK:
```powershell
flutter build apk --release
# خروجی: build\app\outputs\flutter-apk\app-release.apk
```

## نکات
- داده‌ها لوکال‌اند: آگهی‌های شما + علاقه‌مندی‌ها در `shared_preferences` می‌ماند.
- عکس‌ها از `picsum.photos` می‌آیند (اگر آفلاین باشی آیکون جایگزین نمایش داده می‌شود). عکس گالری با `image_picker` از حافظه گوشی خوانده می‌شود.
- نقشه آنلاین است (تایل OSM) ولی بقیه اپ آفلاین کار می‌کند.
- برای تغییر نام پکیج: `com.example.amlak_app` را در `android/app/build.gradle` و `AndroidManifest.xml` و پوشه kotlin عوض کن.
