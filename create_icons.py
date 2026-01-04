#!/usr/bin/env python3
"""
Generate app icons for Sever app
Creates minimalist white square with black circle design
"""

import struct
import zlib

def create_png(width, height, pixels):
    """Create a PNG file from raw pixel data"""
    def png_chunk(chunk_type, data):
        chunk = chunk_type + data
        return struct.pack('>I', len(data)) + chunk + struct.pack('>I', zlib.crc32(chunk) & 0xffffffff)
    
    # PNG signature
    png = b'\x89PNG\r\n\x1a\n'
    
    # IHDR chunk
    ihdr = struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0)  # RGB
    png += png_chunk(b'IHDR', ihdr)
    
    # IDAT chunk (image data)
    raw_data = b''
    for row in pixels:
        raw_data += b'\x00' + row  # Filter type 0 (None)
    
    png += png_chunk(b'IDAT', zlib.compress(raw_data, 9))
    
    # IEND chunk
    png += png_chunk(b'IEND', b'')
    
    return png

def create_app_icon():
    """Create main app icon: white background with black circle"""
    size = 1024
    center = size // 2
    radius = 256
    
    pixels = []
    for y in range(size):
        row = b''
        for x in range(size):
            # Calculate distance from center
            dx = x - center
            dy = y - center
            dist = (dx * dx + dy * dy) ** 0.5
            
            # Black if inside circle, white otherwise
            if dist <= radius:
                row += b'\x00\x00\x00'  # Black
            else:
                row += b'\xff\xff\xff'  # White
        pixels.append(row)
    
    png_data = create_png(size, size, pixels)
    
    with open('assets/icon/app_icon.png', 'wb') as f:
        f.write(png_data)
    
    print(f"✅ Created app_icon.png ({size}x{size})")

def create_foreground_icon():
    """Create foreground icon with transparency"""
    size = 1024
    center = size // 2
    radius = 256
    
    # For RGBA PNG
    def create_png_rgba(width, height, pixels):
        def png_chunk(chunk_type, data):
            chunk = chunk_type + data
            return struct.pack('>I', len(data)) + chunk + struct.pack('>I', zlib.crc32(chunk) & 0xffffffff)
        
        png = b'\x89PNG\r\n\x1a\n'
        ihdr = struct.pack('>IIBBBBB', width, height, 8, 6, 0, 0, 0)  # RGBA
        png += png_chunk(b'IHDR', ihdr)
        
        raw_data = b''
        for row in pixels:
            raw_data += b'\x00' + row
        
        png += png_chunk(b'IDAT', zlib.compress(raw_data, 9))
        png += png_chunk(b'IEND', b'')
        return png
    
    pixels = []
    for y in range(size):
        row = b''
        for x in range(size):
            dx = x - center
            dy = y - center
            dist = (dx * dx + dy * dy) ** 0.5
            
            if dist <= radius:
                row += b'\x00\x00\x00\xff'  # Black, fully opaque
            else:
                row += b'\x00\x00\x00\x00'  # Transparent
        pixels.append(row)
    
    png_data = create_png_rgba(size, size, pixels)
    
    with open('assets/icon/app_icon_foreground.png', 'wb') as f:
        f.write(png_data)
    
    print(f"✅ Created app_icon_foreground.png ({size}x{size})")

if __name__ == '__main__':
    print("🎨 Generating Sever app icons...")
    print("Design: White square with black circle (minimalist)")
    create_app_icon()
    create_foreground_icon()
    print("\n✨ Icons generated successfully!")
    print("📁 Files saved to assets/icon/")
    print("\n🚀 Next step: Run 'flutter pub run flutter_launcher_icons'")
