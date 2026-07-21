
# thực hiện quá trình bốc tách và chuẩn hóa kích thước ảnh từ dải ảnh gốc sang các file ảnh riêng lẻ 32x32
# có thể dùng trực tiếp một file ảnh chứ nhiều frame khác nhau tạo một file mif để boot vào rom và thực hiện quá trình đọc theo kích thước 32 x32 
import os
from PIL import Image

def slice_and_resize_sprites(image_path, output_dir, num_frames=4, target_size=(32, 32)):
    # Tạo thư mục lưu ảnh đầu ra nếu chưa có
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
        
    try:
        # Mở dải ảnh gốc
        img = Image.open(image_path).convert("RGB")
        strip_width, strip_height = img.size
        
        # Tính toán chiều rộng trung bình của mỗi frame
        frame_width = strip_width / num_frames
        
        print(f"Kích thước ảnh gốc: {strip_width}x{strip_height}")
        print(f"Kích thước mỗi frame gốc: {frame_width:.1f}x{strip_height}")
        
        for i in range(num_frames):
            # Xác định tọa độ cắt
            left = int(i * frame_width)
            top = 0
            right = int((i + 1) * frame_width)
            bottom = strip_height
            
            # Cắt và resize về 32x32
            frame = img.crop((left, top, right, bottom))
            resized_frame = frame.resize(target_size, Image.Resampling.LANCZOS)
            
            # Lưu file ảnh đơn lẻ vào thư mục đầu ra
            output_path = os.path.join(output_dir, f"doraemon_{i}.png")
            resized_frame.save(output_path)
            print(f"Đã xuất thành công: {output_path}")
            
    except FileNotFoundError:
        print(f"Lỗi: Không tìm thấy file ảnh tại đường dẫn: {image_path}")
        print("Hãy chắc chắn rằng file doraemon_main.png đã nằm trong thư mục Downloads\\Image_create_bmp của bạn.")

# --- ĐƯỜNG DẪN THỰC TẾ TRÊN MÁY BẠN ---
# Sử dụng tiền tố 'r' trước chuỗi đường dẫn để tránh lỗi ký tự đặc biệt của Windows
input_image_path = r"C:\Users\ADMIN\Downloads\Image_create_bmp\doraemon_main.png"
output_folder = r"C:\Users\ADMIN\Downloads\Image_create_bmp\doraemon_sliced"

slice_and_resize_sprites(input_image_path, output_folder)