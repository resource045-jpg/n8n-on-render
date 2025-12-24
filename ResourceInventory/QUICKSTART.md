# دليل البدء السريع - Resource Inventory

<div dir="rtl">

## خطوات سريعة للبدء (5 دقائق)

### 1️⃣ افتح Xcode وأنشئ مشروع جديد

```
1. افتح Xcode (تأكد من الإصدار 15+)
2. اختر: File → New → Project
3. اختر: iOS → App
4. املأ المعلومات:
   - Product Name: ResourceInventory
   - Team: اختر فريقك
   - Organization Identifier: com.yourname
   - Interface: SwiftUI
   - Language: Swift
   - Storage: SwiftData ✅
   - Include Tests: اختياري
5. اضغط Next واختر موقع الحفظ
```

### 2️⃣ انسخ الملفات إلى المشروع

```
1. افتح Finder وانتقل إلى مجلد ResourceInventory المرفق
2. احذف ملف ContentView.swift من مشروع Xcode
3. اسحب المجلدات التالية إلى مشروع Xcode:
   - Models/
   - Views/
   - Utilities/
   - Resources/
4. تأكد من تحديد:
   ✅ Copy items if needed
   ✅ Create groups
   ✅ Add to targets: ResourceInventory
```

### 3️⃣ حدّث ملف ResourceInventoryApp.swift

```
1. افتح ResourceInventoryApp.swift في Xcode
2. الملف جاهز - فقط تأكد من أنه المحتوى الصحيح
```

### 4️⃣ إعداد Info.plist (مهم جداً!)

```
1. في Xcode، افتح Info.plist
2. أضف مفتاح جديد:
   - Key: Privacy - Face ID Usage Description
   - Type: String
   - Value: نحتاج إلى Face ID لحماية بياناتك
3. احفظ الملف
```

### 5️⃣ شغّل التطبيق!

```
1. اختر محاكي: iPhone 15 Pro (iOS 17+)
2. اضغط Cmd+R أو زر ▶️
3. عند ظهور شاشة Face ID:
   - في المحاكي: Features → Face ID → Enrolled
   - ثم: Features → Face ID → Matching Face
```

## 🎉 تهانينا! التطبيق يعمل الآن

### جرّب الميزات:

#### إضافة منتج
1. اضغط زر ➕ في الأعلى
2. اختر نوع المنتج (كود أو حساب)
3. املأ المعلومات
4. فعّل الاشتراك إذا أردت (اختياري)
5. احفظ ✅

#### بيع منتج
1. اضغط على أي منتج متاح
2. اضغط "بيع المنتج"
3. أدخل اسم المشتري والسعر
4. تأكيد ✅

#### مشاركة/تصدير
1. افتح تفاصيل أي منتج
2. اضغط "مشاركة كنص" أو "تصدير PDF"
3. اختر التطبيق (WhatsApp, Telegram, إلخ)

#### تتبع الاشتراكات
1. اذهب إلى تبويب "الاشتراكات" ⏰
2. شاهد العدادات الملونة
3. الأخضر = أكثر من 7 أيام
4. الأصفر = 3-7 أيام
5. الأحمر = أقل من 3 أيام

## 🔧 حل المشاكل السريع

### "Cannot find 'DigitalProduct'"
```
الحل: تأكد من إضافة مجلد Models/ للمشروع
```

### Face ID لا يعمل
```
الحل في المحاكي:
Features → Face ID → Enrolled
Features → Face ID → Matching Face
```

### التطبيق يغلق عند الفتح
```
الحل: تأكد من إضافة NSFaceIDUsageDescription في Info.plist
```

### الواجهة معكوسة (LTR بدلاً من RTL)
```
الحل: التطبيق يطبق RTL تلقائياً عبر:
.environment(\.layoutDirection, .rightToLeft)
```

## 📱 الاختبار على جهاز حقيقي

```
1. وصّل iPhone بالكمبيوتر
2. في Xcode: Window → Devices and Simulators
3. اختر جهازك من القائمة
4. اضغط "Trust" على الـ iPhone
5. في Xcode، اختر جهازك من القائمة العلوية
6. اضغط Run (Cmd+R)
7. في أول مرة: اذهب للإعدادات → عام → VPN & Device Management
8. ثق بالمطور
```

## 🎨 تخصيص التطبيق

### تغيير اسم التطبيق
```
1. في Xcode: اختر المشروع (الأيقونة الزرقاء العليا)
2. في General → Identity
3. غيّر Display Name
```

### تغيير الألوان الأساسية
```
1. افتح Assets.xcassets
2. اختر AccentColor
3. غيّر اللون حسب رغبتك
```

### إضافة أيقونة التطبيق
```
1. افتح Assets.xcassets
2. اختر AppIcon
3. اسحب صورة 1024x1024 بكسل
4. Xcode سيولد باقي الأحجام تلقائياً
```

## 🚀 النشر على App Store

عندما تكون جاهزاً للنشر:

```
1. في Xcode: Product → Archive
2. انتظر حتى يكتمل الأرشفة
3. Window → Organizer
4. اختر Archive الأخير
5. Distribute App → App Store Connect
6. اتبع الخطوات
7. ارفع على App Store Connect
8. أضف Screenshots والمعلومات
9. أرسل للمراجعة
```

## 💡 نصائح إضافية

### لتحسين الأداء
- التطبيق يستخدم SwiftData للتخزين المحلي (سريع جداً)
- لا حاجة لإنترنت (العمل بدون اتصال)

### للمحترفين
- يمكنك إضافة Unit Tests في مجلد Tests/
- يمكنك استخدام Instruments لتحليل الأداء
- SwiftData يدعم iCloud Sync (يمكن إضافته لاحقاً)

## 📞 المساعدة

إذا واجهت أي مشكلة:
1. راجع الـ README.md الكامل
2. تأكد من استيفاء المتطلبات (Xcode 15+, iOS 17+)
3. حاول Clean Build Folder (Shift+Cmd+K)

---

## بالتوفيق! 🎉

الآن لديك تطبيق احترافي كامل لإدارة المنتجات الرقمية!

</div>
