## 1. Project Overview

- **Project Name:** SaViCam Relap (Companion App).
- **Role:** Trạm kiểm soát từ xa (Remote control station) trong hệ sinh thái SaViCam T-Mod, dành riêng cho người thân hoặc người giám hộ của người khiếm thị.
- **Core Responsibilities:** Nhận tín hiệu khẩn cấp (SOS Red Alert) và ghi đè màn hình để cảnh báo.
  - Theo dõi trạng thái di chuyển (Live Tracking) và thông số phần cứng (Telemetry) theo thời gian thực.
  - Hỗ trợ thiết lập Từ điển vị trí (UserMacros) để đồng bộ xuống thiết bị biên (Edge) của người khiếm thị.

## 2. Tech Stack & Infrastructure

- **Frontend Framework:** Flutter (Tái sử dụng mã nguồn và quản lý đa nền tảng iOS/Android).
- **Backend & Realtime:** Supabase (PostgreSQL) kết hợp WebSockets cho kết nối realtime.
- **Cloud Infrastructure:** Môi trường đám mây triển khai trên Oracle Cloud.
- **Push Notifications:** Firebase Cloud Messaging (FCM) / APNs qua Cloud cho các thông báo đẩy.

## 3. Architecture Pattern

Áp dụng **Feature-Driven Architecture** với cấu trúc thư mục tiêu chuẩn:

- `lib/core/`: Chứa các service dùng chung (Auth, Supabase Network, FCM Service, VoIP Service).
- `lib/features/`: Phân chia theo từng tính năng cốt lõi (Dashboard, Live Tracking, Telemetry Monitor, User Macros, SOS Alert).
- `lib/ui/`: Chứa các component giao diện dùng chung (Widgets).

## 4. Cloud Database Schema (Supabase)

Dự án sử dụng 4 bảng chính có quan hệ khóa ngoại (FK) liên kết qua `paired_device_id`:

1. **device_pairs** (Ghép nối thiết bị):

   - id (uuid, PK)
   - tmod_mac_address (varchar)
   - relap_user_id (uuid)
   - pairing_code (varchar)
   - status (varchar)
   - created_at (timestamptz)

2. **device_telemetry** (Thông số thiết bị - Cần lắng nghe Realtime):

   - tmod_device_id (uuid, PK)
   - paired_device_id (uuid, FK)
   - battery_level (int2)
   - network_status (varchar)
   - is_headless_mode (bool)
   - current_lat (float8), current_lng (float8)
   - last_ping_at (timestamptz)

3. **emergency_alerts** (Cảnh báo khẩn cấp - Cần lắng nghe Realtime):

   - id (uuid, PK)
   - paired_device_id (uuid, FK)
   - status (varchar)
   - latitude (float8), longitude (float8)
   - message (text)
   - created_at (timestamptz)

4. **user_macros** (Từ điển vị trí):

   - id (uuid, PK)
   - paired_device_id (uuid, FK)
   - keyword (varchar)
   - action_type (varchar)
   - data_value (jsonb) -&gt; Dùng để lưu tọa độ linh hoạt
   - updated_at, created_at (timestamptz)

## 5. Core Features & UX Requirements

- **Màn hình Cảnh báo Khẩn cấp (SOS Red Alert):** Phải là một pop-up ghi đè lên các ứng dụng khác (cảnh báo đỏ cường độ cao).

  - Hiển thị tọa độ GPS, tích hợp bản đồ nhỏ và nút "Kết nối đàm thoại ưu tiên" gọi VoIP/Viễn thông thẳng đến T-Mod.
  - Khi người dùng xác nhận "Đã xử lý", update trường `status` thành `resolved`.

- **Màn hình Giám sát Thiết bị (Telemetry):**

  - Cập nhật dữ liệu dạng realtime bằng Supabase Realtime Client.
  - Hiển thị trực quan Pin, Mạng, Headless mode.

- **Quản lý Từ điển vị trí (UserMacros):**

  - Giao diện CRUD để tạo, sửa, xóa từ khóa và thả ghim lấy tọa độ (Lat/Lng) trên bản đồ.
  - Thực hiện đồng bộ dữ liệu lên Oracle Cloud để đẩy cờ sync xuống SQLite của T-Mod.

- **UI/UX Guidelines:**

  - Giao diện tinh gọn, dạng bảng điều khiển (Dashboard).
  - Khu vực cảnh báo thiết kế tương phản cao để đảm bảo người lớn tuổi thao tác kịp thời.

## 6. Structures

savicam_relap/

├── lib/

│ ├── main.dart

│ ├── core/

│ │ ├── auth/ # Xác thực & Ghép nối (QR Code / E2EE) \[cite: 285\]

│ │ ├── network/ # Supabase Realtime Client, REST API \[cite: 286\]

│ │ ├── services/

│ │ │ ├── fcm_service.dart # Lắng nghe Push Notification từ Cloud \[cite: 288\]

│ │ │ └── voip_service.dart # Khởi tạo cuộc gọi ưu tiên \[cite: 289\]

│ │ ├── theme/ # Cấu hình màu sắc, typography theo UI

│ │ └── utils/ # Các hàm hỗ trợ (format ngày, tính khoảng cách)

│ ├── features/

│ │ ├── dashboard/ # UI Bảng điều khiển chính (Screen 1) \[cite: 291\]

│ │ ├── live_tracking/ # Bản đồ theo dõi vị trí thực tế (Screen 1) \[cite: 292\]

│ │ ├── telemetry_monitor/ # Giám sát Pin, Mạng, Headless (Screen 5) \[cite: 293\]

│ │ ├── user_macros/ # Màn hình CRUD Từ điển vị trí (Screen 3, 4) \[cite: 294\]

│ │ ├── sos_alert/ # Màn hình Red Alert ghi đè (Screen 2) \[cite: 295\]

│ │ ├── settings/ # Cài đặt chung, Thông báo, Geofence (Screen 6, 8, 9)

│ │ └── family_access/ # Quản lý thành viên & Ghép nối thiết bị (Screen 7, 10)

│ ├── ui/ # Chứa các component giao diện dùng chung \[cite: 296\]

│ │ ├── widgets/ # Các widget tái sử dụng (Custom Button, Card)

│ │ └── animations/ # Hiệu ứng nhấp nháy cho màn hình SOS

└── pubspec.yaml