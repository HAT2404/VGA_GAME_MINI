# VGA_GAME_MINI
Thực hiện viết module vga controller, module game controller.

<img width="1597" height="391" alt="image" src="https://github.com/user-attachments/assets/60954120-dbba-4dfd-9c34-f06afff0f43f" />

# Thông số tính màn hình:
Loại màn hình: LED Samsung LS19F350HNEXXV.
Kích thước màn hình: 19 inch.
Độ phân giải: 1366 x 768.
Tần số quét: 60 Hz.

# Thông số kit Cyclone® IV FPGA
<img width="773" height="401" alt="Screenshot 2026-07-11 084103" src="https://github.com/user-attachments/assets/2d4bbb35-9b31-438e-9bd7-53160ba011af" />

# Tính toán thông số hoạt động 

<img width="662" height="511" alt="image" src="https://github.com/user-attachments/assets/49676d8b-aedf-494e-8c5d-19b74394b061" />
Horizontal_timing_scan:
<img width="752" height="754" alt="image" src="https://github.com/user-attachments/assets/5355b41c-bc6a-4af7-8cdf-012026112097" />
Vertical_timing_scan:
<img width="749" height="419" alt="image" src="https://github.com/user-attachments/assets/cc968542-1abe-42a3-bf5f-368b2a9a0b48" />

Cơ sở tính toán dựa trên VESA (Hiệp hội Điện tử Video Quốc tế) Coordinated Video Timings hoặc DMT Discrete Video Timings
- Vùng trống ngang (H_banking) = Front_Porch + Sync_Pulse + Back_Porch = >= 20% width_screen.
- Horizontal:
    + Font Porch: 48 pixels
    + Sync Pulse = retrace = 112 pixels
    + Back Porch = 216 pixels
    + H_total = 1366 + 48 + 112 + 216 = 1742 pixels.
- Vertical:
    + Font Porch: 3 lines
    + Sync Pulse = retrace = 6 lines
    + Back Porch = 13 lines 
    + V_total = 768 + 3 + 6 + 13 = 790 lines.
- Pixel Clock:
    + pixel rate = H_total x V_total x S = 1742 x 790 x 60(Hz)  = 82.5 Mhz
      -> S: the number of the screens per second (tần số quét màn hình) 
Chú thích: 
  + Front_Porch:là thời gian sau khi truyền xong vùng hiển thị và trước khi phát xung đồng bộ (Sync Pulse).
  + Sync_Pulse: thời gian ra lệnh xuống dòng 
  + Back_Porch: thời gian chờ để phần cứng ổn định để chuyển hàng.

  





