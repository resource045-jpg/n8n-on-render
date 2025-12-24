# Resource Inventory - تطبيق إدارة المنتجات الرقمية

<div dir="rtl">

## نظرة عامة

تطبيق iOS متقدم لإدارة وتتبع المنتجات الرقمية (أكواد وحسابات) مع ميزات ذكية للبيع والمشاركة وتتبع الاشتراكات.

## المتطلبات التقنية

- **Xcode**: 15.0 أو أحدث
- **iOS**: 17.0+ (الحد الأدنى)
- **Swift**: 6.0
- **macOS**: Sonoma 14.0+ (لتطوير التطبيق)

## المميزات الرئيسية

### ✨ إدارة المخزون الذكية
- إضافة منتجات (أكواد أو حسابات) بواجهة تفاعلية
- تصنيف تلقائي وفلترة سريعة
- بحث متقدم في جميع الحقول
- تغيير حالة المنتج (متاح / تم البيع)

### 📊 تتبع الاشتراكات
- عداد تنازلي تلقائي
- نظام ألوان ديناميكي (أخضر → أصفر → أحمر)
- إشعارات قبل انتهاء الصلاحية

### 📤 التسليم الذكي
- مشاركة فورية عبر واتساب/تلجرام
- تصدير PDF احترافي بشعار Resource
- نسخ سريع للمحتوى

### 🔒 الأمان
- مصادقة بيومترية (Face ID / Touch ID)
- تخزين محلي آمن بدون سحابة
- حماية كاملة للبيانات

### 📈 الإحصائيات
- تحليلات شاملة للمخزون
- تتبع المبيعات والإيرادات
- رسوم بيانية تفاعلية

## هيكلة المشروع

```
ResourceInventory/
├── ResourceInventoryApp.swift          # نقطة البداية الرئيسية
├── Models/
│   └── DigitalProduct.swift           # نموذج البيانات (SwiftData)
├── Views/
│   ├── ContentView.swift              # الحاوية الرئيسية
│   ├── ProductListView.swift          # قائمة المنتجات
│   ├── ProductCardView.swift          # بطاقة المنتج
│   ├── AddProductView.swift           # نموذج إضافة منتج
│   ├── ProductDetailView.swift        # تفاصيل المنتج
│   ├── SellProductSheet.swift         # شاشة البيع
│   ├── SubscriptionsView.swift        # قائمة الاشتراكات
│   ├── StatisticsView.swift           # الإحصائيات
│   ├── SettingsView.swift             # الإعدادات
│   ├── BiometricAuthView.swift        # شاشة المصادقة
│   └── Components/
│       ├── FilterChip.swift           # شريحة الفلترة
│       └── EmptyStateView.swift       # حالة فارغة
├── Utilities/
│   ├── PDFGenerator.swift             # توليد PDF
│   ├── ShareSheet.swift               # مشاركة
│   └── BiometricAuthManager.swift     # إدارة المصادقة
└── Resources/
    └── Info.plist.md                  # إعدادات التطبيق
```

## خطوات الإعداد

### 1. إنشاء المشروع في Xcode

```bash
# افتح Xcode
# File → New → Project
# اختر: iOS → App
# Project Name: ResourceInventory
# Interface: SwiftUI
# Language: Swift
# Storage: SwiftData
# Minimum Deployments: iOS 17.0
```

### 2. نقل الملفات

انسخ جميع الملفات من مجلد `ResourceInventory` إلى مشروع Xcode الخاص بك مع الحفاظ على هيكل المجلدات:

1. احذف `ContentView.swift` الافتراضي
2. أضف جميع الملفات إلى المشروع (Drag & Drop)
3. تأكد من تفعيل "Copy items if needed"

### 3. إعداد Info.plist

1. افتح ملف `Info.plist` في Xcode
2. أضف المفاتيح المطلوبة من ملف `Resources/Info.plist.md`
3. أهم مفتاح: `NSFaceIDUsageDescription`

### 4. إعداد App Icon

1. افتح `Assets.xcassets`
2. أضف أيقونة التطبيق (1024×1024 بكسل)
3. يمكنك استخدام SF Symbol "cube.box.fill" كأساس

### 5. Build & Run

```bash
# اختر جهاز أو محاكي
# اضغط Cmd+R أو زر Play
```

## البنية المعمارية

### SwiftData Model
```swift
@Model
final class DigitalProduct {
    var id: UUID
    var productType: ProductType    // كود أو حساب
    var title: String
    var status: ProductStatus       // متاح أو مباع
    var hasSubscription: Bool
    var expirationDate: Date?
    // ... المزيد من الخصائص
}
```

### State Management
- **@Query**: لجلب البيانات من SwiftData
- **@Bindable**: لربط البيانات ثنائي الاتجاه
- **@StateObject**: لإدارة حالة المصادقة

### UI Components
- **SwiftUI**: واجهة تصريحية بالكامل
- **SF Symbols 6**: أيقونات آبل الرسمية
- **Material Effects**: خلفيات شفافة أنيقة
- **Haptic Feedback**: ردود فعل لمسية

## الاختبار

### على المحاكي
```bash
# اختر iPhone 15 Pro أو أحدث
# لاختبار Face ID:
# Features → Face ID → Enrolled
# Features → Face ID → Matching Face
```

### على الجهاز الفعلي
1. قم بتوصيل iPhone
2. في Xcode: Window → Devices and Simulators
3. اضغط "Trust" على الجهاز
4. اختر الجهاز من القائمة وشغل التطبيق

## التحسينات المستقبلية

- [ ] إضافة iCloud Sync
- [ ] Widget للشاشة الرئيسية
- [ ] Apple Watch Companion App
- [ ] Dark Mode Icons
- [ ] Siri Shortcuts
- [ ] Export/Import JSON
- [ ] Multi-language Support

## الامتثال لمتجر التطبيقات

### App Store Guidelines
✅ لا يحتوي على إعلانات
✅ لا يجمع بيانات شخصية
✅ يوفر قيمة نفعية واضحة
✅ يتبع Human Interface Guidelines
✅ يدعم جميع أحجام الشاشات
✅ يدعم Dark Mode

### Privacy Requirements
- جميع البيانات محلية (SwiftData)
- لا توجد اتصالات شبكية
- البيانات البيومترية لا تُخزن
- Privacy Manifest جاهز

### App Store Connect Checklist
1. ✅ App Icon (1024×1024)
2. ✅ Screenshots (جميع الأحجام)
3. ✅ Privacy Policy URL
4. ✅ Support URL
5. ✅ Age Rating: 4+
6. ✅ Category: Productivity
7. ✅ Keywords (AR & EN)

## الدعم الفني

### المشاكل الشائعة

**مشكلة**: لا يعمل Face ID في المحاكي
**الحل**: في المحاكي اذهب إلى Features → Face ID → Enrolled

**مشكلة**: خطأ في البناء "Cannot find type DigitalProduct"
**الحل**: تأكد من إضافة جميع الملفات إلى Target

**مشكلة**: PDF لا يظهر بشكل صحيح
**الحل**: تأكد من إضافة الخطوط العربية في Assets

## الترخيص

هذا المشروع مخصص للاستخدام الشخصي والتعليمي.

## المطور

**Resource Team**
Made with 💜 in Saudi Arabia

</div>

---

## English Summary

**Resource Inventory** is a comprehensive iOS app for managing digital products (codes & accounts) with:
- Smart inventory management
- Subscription tracking with countdown timers
- PDF generation & sharing
- Biometric authentication (Face ID/Touch ID)
- SwiftData local storage
- Beautiful SwiftUI interface
- Full Arabic support (RTL)

**Tech Stack**: Swift 6, SwiftUI, SwiftData, iOS 17+

**Ready for App Store submission** ✅
