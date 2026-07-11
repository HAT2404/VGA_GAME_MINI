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
Cơ sở tính toán dựa trên VESA (Hiệp hội Điện tử Video Quốc tế) Coordinated Video Timings hoặc DMT Discrete Video Timings

- Vùng trống ngang (H_banking) = Front_Porch + Sync_Pulse + Back_Porch = >= 20% width_screen.

Chú thích: 
  + Front_Porch:là thời gian sau khi truyền xong vùng hiển thị và trước khi phát xung đồng bộ (Sync Pulse).
  + Sync_Pulse: thời gian ra lệnh xuống dòng 
  + Back_Porch: thời gian chờ để phần cứng ổn định để chuyển hàng.

  





