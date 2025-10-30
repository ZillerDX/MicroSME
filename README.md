# MicroSME - Point of Sale & Business Management System

[English](#english) | [ไทย](#thai)

---

<a name="english"></a>
## 🇬🇧 English

### 📱 What is MicroSME?

MicroSME is a comprehensive **Point of Sale (POS) and Business Management System** designed specifically for small and medium enterprises. Built with Flutter, it provides a modern, cross-platform solution for managing sales, inventory, customers, and business finances - all in one beautiful application.

### ✨ Key Features

#### 💰 Point of Sale (POS)
- **Fast Product Selection** - Quick-add products to cart with an intuitive interface
- **Multiple Payment Methods** - Support for cash and bank transfer payments
- **Customer Linking** - Associate sales with customers for loyalty tracking
- **Real-time Calculations** - Automatic subtotal, discount, and total calculations
- **Cart Management** - Easy quantity adjustments and item removal

#### 🏪 Inventory Management
- **Product Catalog** - Manage products with names, prices, and stock levels
- **Emoji Support** - Visual product identification with emoji icons
- **Low Stock Alerts** - Configurable threshold warnings for inventory replenishment
- **Stock Tracking** - Automatic stock deduction on sales
- **Quick Actions** - Add, edit, and delete products seamlessly

#### 👥 Customer Relationship Management (CRM)
- **Customer Database** - Store customer information (name, phone number)
- **Loyalty Points System** - Reward customers with points on every purchase
- **Purchase History** - Track total spent and number of sales per customer
- **Customer Insights** - View detailed statistics including average sale value
- **Quick Customer Creation** - Add new customers at POS checkout or CRM page

#### 📊 Dashboard & Analytics
- **Date Range Filtering** - View data for today, last 7 days, this month, or custom range
- **Financial Overview** - Track revenue, expenses, and net profit
- **Sales Metrics** - Monitor number of sales and average transaction values
- **Visual Statistics** - Beautiful cards displaying key performance indicators
- **Loyalty Program Settings** - Customize points earning and redemption rules

#### 💸 Expense Tracking
- **Record Expenses** - Log business expenses with title, amount, and category
- **Expense Categories** - Organize expenses for better financial tracking
- **Date-based Filtering** - View expenses for specific time periods
- **Net Profit Calculation** - Automatic profit calculation (Revenue - Expenses)

### 🎯 Who is it For?

MicroSME is perfect for:

- **Small Retail Shops** - Convenience stores, boutiques, gift shops
- **Cafés & Restaurants** - Coffee shops, bakeries, small eateries
- **Service Businesses** - Salons, repair shops, small service providers
- **Market Vendors** - Market stalls, pop-up shops, mobile vendors
- **Any Small Business** - Any SME needing efficient sales and inventory management

### 💡 Benefits & Value Proposition

#### For Business Owners
- **Increase Revenue** - Loyalty program encourages repeat purchases
- **Save Time** - Streamlined POS process speeds up checkout
- **Reduce Errors** - Automated calculations eliminate manual mistakes
- **Better Insights** - Data-driven decisions with analytics dashboard
- **Customer Retention** - Build relationships through customer tracking

#### For Staff
- **Easy to Learn** - Intuitive interface requires minimal training
- **Fast Operations** - Quick product selection and checkout process
- **Mobile-Ready** - Works on smartphones and tablets
- **Offline Capable** - Local database works without internet

#### Financial Impact
- **Low Cost** - No expensive hardware or subscription fees required
- **Prevent Loss** - Accurate inventory tracking prevents stock discrepancies
- **Optimize Stock** - Low stock alerts prevent lost sales
- **Track Profitability** - Clear view of revenue vs expenses

### 🛠️ Tech Stack

#### Frontend Framework
- **Flutter 3.5+** - Google's UI toolkit for cross-platform development
- **Dart** - Programming language optimized for building UIs

#### State Management
- **Provider** - Simple and scalable state management solution

#### Database
- **SQLite** - Local relational database for data persistence
- **sqflite** - Flutter plugin for SQLite database operations

#### Key Dependencies
- `provider` - State management
- `sqflite` - Local database
- `path` - File path manipulation
- `intl` - Internationalization and date formatting
- `uuid` - Unique identifier generation

#### Architecture
- **MVVM Pattern** - Model-View-ViewModel architecture
- **Responsive Design** - Adaptive layouts for different screen sizes
- **Material Design 3** - Modern UI following Google's design guidelines

### 📖 How to Use MicroSME

#### Getting Started
1. **Launch the App** - Open MicroSME on your device
2. **Explore Sample Data** - App comes with sample products to help you understand features
3. **Customize Products** - Navigate to Inventory to add your actual products
4. **Configure Loyalty** - Set up loyalty points rules in Dashboard settings

#### Daily Operations

**Making a Sale:**
1. Go to the **POS** tab (home screen)
2. Tap products to add them to the cart
3. Adjust quantities using + / - buttons if needed
4. Tap **Complete Sale** button
5. Search and select customer (optional) or create new customer
6. Choose payment method (Cash or Transfer)
7. Sale is completed! Customer points are awarded automatically

**Adding Products:**
1. Go to **Inventory** tab
2. Tap the **+** button
3. Enter product name, price, stock quantity, and low stock threshold
4. Select an emoji icon (optional)
5. Tap **Add Product**

**Managing Customers:**
1. Go to **Customers** tab
2. View all customers with their loyalty points and purchase history
3. Tap a customer to view detailed information
4. Edit or delete customers as needed
5. Add new customers using the **Add Customers** button

**Viewing Analytics:**
1. Go to **Dashboard** tab
2. Select date range (Today, Last 7 Days, This Month, or Custom)
3. View revenue, expenses, profit, and sales count
4. Customize loyalty program settings by tapping the settings icon

**Recording Expenses:**
1. In **Dashboard** tab, scroll to Expenses section
2. Tap **Add Expense** button
3. Enter expense title, amount, and category
4. Expense is recorded and included in profit calculations

### 🚀 Installation & Setup

#### Prerequisites
- Flutter SDK 3.5.0 or higher
- Dart SDK 3.5.0 or higher
- Android Studio / Xcode (for mobile development)
- Git

#### Step-by-Step Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/ZillerDX/MicroSME.git
   cd MicroSME/microsme_flutter
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Check Flutter Setup**
   ```bash
   flutter doctor
   ```
   Fix any issues reported by Flutter doctor.

4. **Run the Application**

   For Android:
   ```bash
   flutter run
   ```

   For iOS:
   ```bash
   flutter run -d ios
   ```

   For Web:
   ```bash
   flutter run -d chrome
   ```

5. **Build Release Version**

   Android APK:
   ```bash
   flutter build apk --release
   ```

   iOS:
   ```bash
   flutter build ios --release
   ```

### 📱 Platform Support

- ✅ **Android** - Fully supported (API 21+)
- ✅ **iOS** - Fully supported (iOS 12+)
- ✅ **Web** - Supported with sqflite_common_ffi_web
- ⚠️ **Windows/Mac/Linux** - Partially supported

### 📂 Project Structure

```
microsme_flutter/
├── lib/
│   ├── constants/          # App-wide constants and themes
│   ├── database/           # Database helper and queries
│   ├── models/             # Data models (Product, Sale, Customer, Expense)
│   ├── screens/            # UI screens (POS, Inventory, CRM, Dashboard)
│   ├── services/           # Business logic and state management
│   ├── widgets/            # Reusable widgets
│   └── main.dart           # Application entry point
├── android/                # Android-specific configuration
├── ios/                    # iOS-specific configuration
├── web/                    # Web-specific configuration
└── pubspec.yaml           # Project dependencies and configuration
```

### 🎨 Development Journey

MicroSME was developed to address the real needs of small business owners who struggle with:
- Manual cash register operations
- Paper-based inventory tracking
- Lack of customer insights
- Complex and expensive POS systems

#### Development Approach
1. **Research Phase** - Interviewed small business owners to understand pain points
2. **Design Phase** - Created intuitive UI/UX focusing on speed and simplicity
3. **Core Development** - Built POS, inventory, and database foundations
4. **Feature Expansion** - Added CRM, loyalty program, and analytics
5. **Optimization** - Improved performance and user experience
6. **Testing** - Extensive testing with real business scenarios

#### Design Principles
- **Simplicity First** - Easy to use without training
- **Speed Matters** - Fast checkout process is critical
- **Mobile-First** - Designed for smartphone and tablet use
- **Data-Driven** - Provide insights to help business decisions
- **Offline-Ready** - Works without internet connection

### 🤝 Contributing

Contributions are welcome! If you'd like to improve MicroSME:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### 📄 License

This project is open source and available under the MIT License.

### 📞 Support

For support, feature requests, or bug reports:
- Tel. : 0802648029
- Email: bostziller03x@gmail.com
- 
---

<a name="thai"></a>
## 🇹🇭 ไทย

### 📱 MicroSME คืออะไร?

MicroSME เป็นระบบ **ขายสินค้า (POS) และการจัดการธุรกิจ** ที่ออกแบบมาโดยเฉพาะสำหรับธุรกิจขนาดเล็กและขนาดกลาง สร้างด้วย Flutter เพื่อให้โซลูชันข้ามแพลตฟอร์มที่ทันสมัยสำหรับการจัดการยอดขาย สินค้าคงคลัง ลูกค้า และการเงินธุรกิจ - ทั้งหมดในแอปพลิเคชันเดียว

### ✨ ฟีเจอร์หลัก

#### 💰 จุดขาย (POS)
- **เลือกสินค้าได้อย่างรวดเร็ว** - เพิ่มสินค้าลงตะกร้าด้วยอินเทอร์เฟซที่ใช้งานง่าย
- **รองรับหลายช่องทางชำระเงิน** - รับชำระด้วยเงินสดและโอนเงิน
- **เชื่อมโยงกับลูกค้า** - บันทึกยอดขายกับลูกค้าเพื่อสะสมแต้ม
- **คำนวณแบบเรียลไทม์** - คำนวณยอดรวม ส่วนลด และราคาสุทธิอัตโนมัติ
- **จัดการตะกร้า** - ปรับจำนวนและลบสินค้าได้ง่าย

#### 🏪 การจัดการสินค้าคงคลัง
- **แคตตาล็อกสินค้า** - จัดการสินค้าพร้อมชื่อ ราคา และจำนวนคงคลัง
- **รองรับอิโมจิ** - ระบุสินค้าด้วยไอคอนอิโมจิ
- **แจ้งเตือนสินค้าใกล้หมด** - ตั้งค่าแจ้งเตือนเมื่อสินค้าเหลือน้อย
- **ติดตามสต็อก** - หักสต็อกอัตโนมัติเมื่อขายสินค้า
- **จัดการได้ง่าย** - เพิ่ม แก้ไข และลบสินค้าได้อย่างราบรื่น

#### 👥 การจัดการลูกค้า (CRM)
- **ฐานข้อมูลลูกค้า** - เก็บข้อมูลลูกค้า (ชื่อ, เบอร์โทร)
- **ระบบแต้มสะสม** - มอบแต้มให้ลูกค้าทุกครั้งที่ซื้อสินค้า
- **ประวัติการซื้อ** - ติดตามยอดซื้อรวมและจำนวนครั้งที่ซื้อของแต่ละลูกค้า
- **ข้อมูลเชิงลึก** - ดูสถิติโดยละเอียดรวมถึงมูลค่าการซื้อเฉลี่ย
- **เพิ่มลูกค้าได้ง่าย** - สร้างลูกค้าใหม่ได้ที่หน้าจุดขายหรือหน้า CRM

#### 📊 แดชบอร์ดและการวิเคราะห์
- **กรองตามช่วงวันที่** - ดูข้อมูลวันนี้, 7 วันที่แล้ว, เดือนนี้ หรือกำหนดเอง
- **ภาพรวมการเงิน** - ติดตามรายได้ รายจ่าย และกำไรสุทธิ
- **ตัวชี้วัดยอดขาย** - ติดตามจำนวนยอดขายและมูลค่าธุรกรรมเฉลี่ย
- **ตั้งค่าโปรแกรมสะสมแต้ม** - ปรับแต่งกฎการสะสมแต้มและการแลกแต้ม

#### 💸 การติดตามค่าใช้จ่าย
- **บันทึกรายจ่าย** - บันทึกค่าใช้จ่ายธุรกิจพร้อมหัวข้อ จำนวนเงิน และหมวดหมู่
- **หมวดหมู่รายจ่าย** - จัดระเบียบรายจ่ายเพื่อติดตามการเงินที่ดีขึ้น
- **กรองตามวันที่** - ดูรายจ่ายในช่วงเวลาที่กำหนด
- **คำนวณกำไรสุทธิ** - คำนวณกำไรอัตโนมัติ (รายได้ - รายจ่าย)

### 🎯 เหมาะสำหรับใคร?

MicroSME เหมาะอย่างยิ่งสำหรับ:

- **ร้านค้าปลีกขนาดเล็ก** - ร้านสะดวกซื้อ, บูติก, ร้านของขวัญ
- **คาเฟ่และร้านอาหาร** - ร้านกาแฟ, เบเกอรี่, ร้านอาหารขนาดเล็ก
- **ธุรกิจบริการ** - ร้านตัดผม, ร้านซ่อม, ผู้ให้บริการขนาดเล็ก
- **แผงลอยตลาดนัด** - ร้านค้าในตลาด, ร้านค้าชั่วคราว, พ่อค้าแม่ค้าเร่
- **ธุรกิจขนาดเล็กทุกประเภท** - SME ใดๆ ที่ต้องการระบบจัดการยอดขายและสต็อกที่มีประสิทธิภาพ

### 💡 ประโยชน์และคุณค่า

#### สำหรับเจ้าของธุรกิจ
- **เพิ่มรายได้** - โปรแกรมแต้มสะสมกระตุ้นให้ลูกค้ากลับมาซื้อซ้ำ
- **ประหยัดเวลา** - กระบวนการ POS ที่คล่องตัวช่วยเร่งการชำระเงิน
- **ลดข้อผิดพลาด** - การคำนวณอัตโนมัติขจัดข้อผิดพลาดจากการคำนวณด้วยมือ
- **ข้อมูลเชิงลึกที่ดีขึ้น** - ตัดสินใจโดยใช้ข้อมูลจากแดชบอร์ด
- **รักษาลูกค้า** - สร้างความสัมพันธ์ผ่านการติดตามลูกค้า

#### สำหรับพนักงาน
- **เรียนรู้ง่าย** - อินเทอร์เฟซที่ใช้งานง่ายไม่ต้องฝึกอบรมมาก
- **ใช้งานรวดเร็ว** - เลือกสินค้าและชำระเงินได้อย่างรวดเร็ว
- **พร้อมใช้บนมือถือ** - ทำงานได้บนสมาร์ทโฟนและแท็บเล็ต
- **ใช้งานได้แบบออฟไลน์** - ฐานข้อมูลในเครื่องทำงานได้โดยไม่ต้องใช้อินเทอร์เน็ต

#### ผลกระทบทางการเงิน
- **ต้นทุนต่ำ** - ไม่ต้องใช้ฮาร์ดแวร์ราคาแพงหรือค่าสมาชิกรายเดือน
- **ป้องกันการสูญเสีย** - การติดตามสต็อกที่แม่นยำป้องกันความคลาดเคลื่อน
- **เพิ่มประสิทธิภาพสต็อก** - แจ้งเตือนสินค้าใกล้หมดป้องกันการขาดสต็อก
- **ติดตามผลกำไร** - มองเห็นรายได้เทียบกับค่าใช้จ่ายอย่างชัดเจน

### 🛠️ เทคโนโลยีที่ใช้

#### เฟรมเวิร์ก
- **Flutter 3.5+** - UI toolkit ของ Google สำหรับพัฒนาข้ามแพลตฟอร์ม
- **Dart** - ภาษาโปรแกรมที่ออกแบบมาสำหรับสร้าง UI

#### การจัดการสถานะ
- **Provider** - โซลูชันการจัดการสถานะที่เรียบง่ายและขยายได้

#### ฐานข้อมูล
- **SQLite** - ฐานข้อมูลเชิงสัมพันธ์ในเครื่องสำหรับเก็บข้อมูล
- **sqflite** - ปลั๊กอิน Flutter สำหรับจัดการฐานข้อมูล SQLite

#### ไลบรารีหลัก
- `provider` - จัดการสถานะ
- `sqflite` - ฐานข้อมูลในเครื่อง
- `path` - จัดการ path ไฟล์
- `intl` - รองรับหลายภาษาและจัดรูปแบบวันที่
- `uuid` - สร้าง unique identifier

#### สถาปัตยกรรม
- **MVVM Pattern** - สถาปัตยกรรม Model-View-ViewModel
- **Responsive Design** - เลย์เอาต์ปรับตัวตามขนาดหน้าจอ
- **Material Design 3** - UI ทันสมัยตามแนวทางการออกแบบของ Google

### 📖 วิธีใช้งาน MicroSME

#### เริ่มต้นใช้งาน
1. **เปิดแอป** - เปิด MicroSME บนอุปกรณ์ของคุณ
2. **ทดลองใช้ข้อมูลตัวอย่าง** - แอปมีสินค้าตัวอย่างให้ทดลองใช้งาน
3. **ปรับแต่งสินค้า** - ไปที่หน้าสินค้าคงคลังเพื่อเพิ่มสินค้าจริงของคุณ
4. **ตั้งค่าแต้มสะสม** - กำหนดกฎแต้มสะสมในการตั้งค่าแดชบอร์ด

#### การใช้งานประจำวัน

**การขายสินค้า:**
1. ไปที่แท็บ **POS** (หน้าแรก)
2. แตะสินค้าเพื่อเพิ่มลงตะกร้า
3. ปรับจำนวนด้วยปุ่ม + / - ถ้าต้องการ
4. แตะปุ่ม **Complete Sale**
5. ค้นหาและเลือกลูกค้า (ถ้ามี) หรือสร้างลูกค้าใหม่
6. เลือกช่องทางชำระเงิน (เงินสดหรือโอน)
7. ขายสำเร็จ! ลูกค้าได้รับแต้มโดยอัตโนมัติ

**เพิ่มสินค้า:**
1. ไปที่แท็บ **Inventory**
2. แตะปุ่ม **+**
3. กรอกชื่อสินค้า ราคา จำนวนสต็อก และจุดแจ้งเตือนสต็อกต่ำ
4. เลือกไอคอนอิโมจิ (ถ้าต้องการ)
5. แตะ **Add Product**

**จัดการลูกค้า:**
1. ไปที่แท็บ **Customers**
2. ดูลูกค้าทั้งหมดพร้อมแต้มสะสมและประวัติการซื้อ
3. แตะลูกค้าเพื่อดูข้อมูลละเอียด
4. แก้ไขหรือลบลูกค้าได้ตามต้องการ
5. เพิ่มลูกค้าใหม่ด้วยปุ่ม **Add Customers**

**ดูการวิเคราะห์:**
1. ไปที่แท็บ **Dashboard**
2. เลือกช่วงวันที่ (วันนี้, 7 วันที่แล้ว, เดือนนี้, หรือกำหนดเอง)
3. ดูรายได้ รายจ่าย กำไร และจำนวนยอดขาย
4. ปรับแต่งการตั้งค่าแต้มสะสมโดยแตะไอคอนการตั้งค่า

**บันทึกค่าใช้จ่าย:**
1. ในแท็บ **Dashboard** เลื่อนไปที่ส่วน Expenses
2. แตะปุ่ม **Add Expense**
3. กรอกหัวข้อค่าใช้จ่าย จำนวนเงิน และหมวดหมู่
4. ค่าใช้จ่ายจะถูกบันทึกและรวมในการคำนวณกำไร

### 🚀 การติดตั้งและตั้งค่า

#### ข้อกำหนดเบื้องต้น
- Flutter SDK 3.5.0 หรือสูงกว่า
- Dart SDK 3.5.0 หรือสูงกว่า
- Android Studio / Xcode (สำหรับพัฒนาบนมือถือ)
- Git

#### ขั้นตอนการติดตั้ง

1. **โคลนโปรเจค**
   ```bash
   git clone https://github.com/ZillerDX/MicroSME.git
   cd MicroSME/microsme_flutter
   ```

2. **ติดตั้ง Dependencies**
   ```bash
   flutter pub get
   ```

3. **ตรวจสอบการติดตั้ง Flutter**
   ```bash
   flutter doctor
   ```
   แก้ไขปัญหาที่ Flutter doctor รายงาน

4. **รันแอปพลิเคชัน**

   สำหรับ Android:
   ```bash
   flutter run
   ```

   สำหรับ iOS:
   ```bash
   flutter run -d ios
   ```

   สำหรับ Web:
   ```bash
   flutter run -d chrome
   ```

5. **สร้างเวอร์ชัน Release**

   Android APK:
   ```bash
   flutter build apk --release
   ```

   iOS:
   ```bash
   flutter build ios --release
   ```

### 📱 แพลตฟอร์มที่รองรับ

- ✅ **Android** - รองรับเต็มรูปแบบ (API 21+)
- ✅ **iOS** - รองรับเต็มรูปแบบ (iOS 12+)
- ✅ **Web** - รองรับด้วย sqflite_common_ffi_web
- ⚠️ **Windows/Mac/Linux** - รองรับบางส่วน

### 📂 โครงสร้างโปรเจค

```
microsme_flutter/
├── lib/
│   ├── constants/          # ค่าคงที่และธีมของแอป
│   ├── database/           # database helper และ queries
│   ├── models/             # โมเดลข้อมูล (Product, Sale, Customer, Expense)
│   ├── screens/            # หน้าจอ UI (POS, Inventory, CRM, Dashboard)
│   ├── services/           # business logic และ state management
│   ├── widgets/            # widgets ที่ใช้ซ้ำได้
│   └── main.dart           # จุดเริ่มต้นของแอปพลิเคชัน
├── android/                # การตั้งค่าเฉพาะ Android
├── ios/                    # การตั้งค่าเฉพาะ iOS
├── web/                    # การตั้งค่าเฉพาะ Web
└── pubspec.yaml           # dependencies และการตั้งค่าโปรเจค
```

### 🎨 เส้นทางการพัฒนา

MicroSME ถูกพัฒนาขึ้นเพื่อแก้ไขปัญหาจริงของเจ้าของธุรกิจขนาดเล็กที่ประสบปัญหา:
- การใช้เครื่องคิดเงินแบบแมนนวล
- การติดตามสต็อกด้วยกระดาษ
- ขาดข้อมูลเชิงลึกของลูกค้า
- ระบบ POS ที่ซับซ้อนและราคาแพง

#### แนวทางการพัฒนา
1. **ระยะการศึกษา** - สัมภาษณ์เจ้าของธุรกิจขนาดเล็กเพื่อเข้าใจปัญหา
2. **ระยะออกแบบ** - สร้าง UI/UX ที่ใช้งานง่ายโดยเน้นความเร็วและความเรียบง่าย
3. **พัฒนาหลัก** - สร้างรากฐาน POS, สต็อก และฐานข้อมูล
4. **ขยายฟีเจอร์** - เพิ่ม CRM, โปรแกรมสะสมแต้ม และการวิเคราะห์
5. **ปรับปรุง** - เพิ่มประสิทธิภาพและประสบการณ์ผู้ใช้
6. **ทดสอบ** - ทดสอบอย่างละเอียดกับสถานการณ์ธุรกิจจริง

#### หลักการออกแบบ
- **ความเรียบง่ายมาก่อน** - ใช้งานง่ายโดยไม่ต้องฝึกอบรม
- **ความเร็วสำคัญ** - กระบวนการชำระเงินที่รวดเร็วเป็นสิ่งสำคัญ
- **Mobile-First** - ออกแบบสำหรับการใช้งานบนสมาร์ทโฟนและแท็บเล็ต
- **ขับเคลื่อนด้วยข้อมูล** - ให้ข้อมูลเชิงลึกเพื่อช่วยตัดสินใจ
- **พร้อมออฟไลน์** - ทำงานได้โดยไม่ต้องเชื่อมอินเทอร์เน็ต

### 🤝 การมีส่วนร่วม

ยินดีรับการมีส่วนร่วม! หากคุณต้องการปรับปรุง MicroSME:

1. Fork repository
2. สร้าง feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit การเปลี่ยนแปลง (`git commit -m 'Add some AmazingFeature'`)
4. Push ไปยัง branch (`git push origin feature/AmazingFeature`)
5. เปิด Pull Request

### 📄 ใบอนุญาต

โปรเจคนี้เป็น open source และใช้ใบอนุญาต MIT License

### 📞 ช่องทางติดต่อ

สำหรับการสนับสนุน คำขอฟีเจอร์ หรือรายงานบั๊ก:
- Tel. : 0802648029
- Email: bostziller03x@gmail.com

Made with ❤️ for Small Businesses | ❤️ สำหรับธุรกิจขนาดเล็ก
