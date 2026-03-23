# تطبيق القرآن الكريم

تطبيق Flutter للقرآن الكريم — عصري، متعدد اللغات، قابل للتوسع.

## المتطلبات
- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- Android Studio / VS Code

## التشغيل السريع

```bash
# 1. تثبيت الحزم
flutter pub get

# 2. توليد الترجمات
flutter gen-l10n

# 3. توليد الكود التلقائي
dart run build_runner build --delete-conflicting-outputs

# 4. تشغيل التطبيق
flutter run
```

## هيكل المشروع

```
lib/
  core/                    # المشترك بين جميع الميزات
    constants/             # الثوابت والإعدادات
    di/                    # Dependency Injection
    errors/                # نماذج الأخطاء
    extensions/            # Context extensions
    l10n/                  # مزودو اللغة والثيم
    router/                # التنقل (GoRouter)
    theme/                 # الألوان والخطوط والثيم
    widgets/               # Widgets مشتركة

  features/                # كل ميزة مستقلة (Feature-first)
    quran/                 # قراءة وتصفح القرآن
    audio/                 # التلاوة الصوتية
    search/                # البحث
    bookmarks/             # الإشارات المرجعية
    tafseer/               # التفسير
    statistics/            # إحصائيات القراءة
    settings/              # الإعدادات

  l10n/                    # ملفات الترجمة ARB
    app_ar.arb             # العربية (افتراضي)
    app_en.arb             # الإنجليزية
    app_fr.arb             # الفرنسية
    app_zh.arb             # الصينية
    app_zgh.arb            # الأمازيغية

  main.dart                # نقطة الدخول
```

## المعمارية
**Clean Architecture + Feature-first**

كل ميزة تحتوي على 3 طبقات:
- `domain/` — entities, use cases, repository interfaces (لا اعتماد خارجي)
- `data/`   — تنفيذ repositories, API, قاعدة البيانات
- `presentation/` — screens, widgets, controllers (Riverpod)

## اللغات المدعومة
| الكود | اللغة | الاتجاه |
|-------|-------|---------|
| ar | العربية | RTL |
| en | English | LTR |
| fr | Français | LTR |
| zgh | ⵜⴰⵎⴰⵣⵉⵖⵜ | RTL |
| zh | 中文 | LTR |

## الألوان
- Primary: `#C9A84C` — ذهبي دافئ
- Secondary: `#1D9E75` — أخضر زمردي

## الحزم الرئيسية
| الحزمة | الاستخدام |
|--------|-----------|
| flutter_riverpod | إدارة الحالة |
| go_router | التنقل |
| just_audio | مشغل التلاوة |
| sqflite + hive | التخزين المحلي |
| dio | HTTP |
| freezed | نماذج البيانات |
| injectable | Dependency Injection |

## الميزات المخططة
- [x] هيكل المشروع الكامل
- [x] نظام الثيم (ليلي/نهاري)
- [x] تعدد اللغات (5 لغات)
- [x] شاشة الإطلاق
- [x] الرئيسية مع إحصائيات
- [x] قائمة السور
- [x] شاشة القراءة مع Tabs
- [ ] مشغل التلاوة الكامل
- [ ] البحث الكامل
- [ ] التفسير من API
- [ ] الترجمة من API
- [ ] الإشارات المرجعية
- [ ] إحصائيات مفصلة
- [ ] التذكيرات
- [ ] تحميل أوفلاين
# quran_app
