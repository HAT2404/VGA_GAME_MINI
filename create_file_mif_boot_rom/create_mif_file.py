from PIL import Image
import os

# Danh sách 4 file ảnh đã cắt và chuẩn hóa kích thước (ví dụ 32x32)
image_dir = "doraemon_sliced"
image_files = [os.path.join(image_dir, f"doraemon_{i}.png") for i in range(4)]
width, height = 32, 32
num_frames = len(image_files)
total_words = width * height * num_frames # 32 * 32 * 4 = 4096 words

mif_filename = "doraemon_rom.mif"

with open(mif_filename, "w") as f:
    # 1. Ghi phần Header định nghĩa cho file MIF
    f.write(f"WIDTH=24;\n")             # Độ rộng dữ liệu là 24-bit (RGB 8:8:8)
    f.write(f"DEPTH={total_words};\n")  # Tổng số ô nhớ
    f.write("ADDRESS_RADIX=DEC;\n")     # Địa chỉ biểu diễn dạng Thập phân
    f.write("DATA_RADIX=HEX;\n\n")      # Dữ liệu màu biểu diễn dạng HEX
    f.write("CONTENT BEGIN\n")

    addr = 0
    for frame_idx, img_path in enumerate(image_files):
        # Mở ảnh và chuyển về hệ màu RGB
        img = Image.open(img_path).convert("RGB")
        img = img.resize((width, height)) # Đảm bảo đúng kích thước
        
        for y in range(height):
            for x in range(width):
                r, g, b = img.getpixel((x, y))
                
                # Dùng trực tiếp RGB 8-bit (24-bit tổng)
                color_24bit = (r << 16) | (g << 8) | b
                
                # Ghi vào file MIF:  Địa chỉ : Mã_Màu_Hex;
                f.write(f"    {addr} : {color_24bit:06X};\n")
                addr += 1

    f.write("END;\n")

print(f"Đã tạo thành công file {mif_filename} với {addr} pixel!")