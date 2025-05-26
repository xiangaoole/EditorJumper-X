#!/usr/bin/env python3
"""
Icon Generator for Editor Jumper Mac App
Generates app icons in all required sizes for macOS
"""

from PIL import Image, ImageDraw, ImageFont
import os
import math

def create_icon(size):
    """Create an icon with the specified size"""
    # Create a new image with transparent background
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Define colors
    bg_color = (45, 156, 219)  # Blue background
    accent_color = (255, 255, 255)  # White for arrows
    secondary_color = (255, 193, 7)  # Yellow/orange for accent
    
    # Calculate dimensions based on size
    margin = size * 0.1
    inner_size = size - 2 * margin
    
    # Draw rounded rectangle background
    corner_radius = size * 0.15
    draw.rounded_rectangle(
        [margin, margin, size - margin, size - margin],
        radius=corner_radius,
        fill=bg_color
    )
    
    # Draw the main icon elements - two curved arrows forming a cycle
    center_x = size // 2
    center_y = size // 2
    arrow_radius = inner_size * 0.25
    arrow_width = max(2, size // 20)
    
    # Draw circular arrows to represent "jumping" between editors
    # First arrow (clockwise) - White - 上半部分
    arrow1_start_angle = -45
    arrow1_end_angle = 135
    arrow1_bbox = [
        center_x - arrow_radius,
        center_y - arrow_radius,
        center_x + arrow_radius,
        center_y + arrow_radius
    ]
    
    # Draw the arc
    draw.arc(arrow1_bbox, arrow1_start_angle, arrow1_end_angle, 
             fill=accent_color, width=arrow_width)
    
    # Draw arrowhead for first arrow
    arrow1_head_x = center_x + arrow_radius * math.cos(math.radians(arrow1_end_angle))
    arrow1_head_y = center_y + arrow_radius * math.sin(math.radians(arrow1_end_angle))
    head_size = size * 0.08
    
    # Calculate arrowhead points
    angle_rad = math.radians(arrow1_end_angle + 90)
    head_points = [
        (arrow1_head_x, arrow1_head_y),
        (arrow1_head_x - head_size * math.cos(angle_rad - 0.5),
         arrow1_head_y - head_size * math.sin(angle_rad - 0.5)),
        (arrow1_head_x - head_size * math.cos(angle_rad + 0.5),
         arrow1_head_y - head_size * math.sin(angle_rad + 0.5))
    ]
    draw.polygon(head_points, fill=accent_color)
    
    # Second arrow (counter-clockwise) - Yellow/Orange - 下半部分
    # 修复：使用相同的半径和连接的角度
    arrow2_start_angle = 135  # 从白色箭头结束的地方开始
    arrow2_end_angle = 315    # 到白色箭头开始的地方结束（-45 + 360 = 315）
    arrow2_radius = arrow_radius  # 使用相同的半径
    arrow2_bbox = [
        center_x - arrow2_radius,
        center_y - arrow2_radius,
        center_x + arrow2_radius,
        center_y + arrow2_radius
    ]
    
    draw.arc(arrow2_bbox, arrow2_start_angle, arrow2_end_angle, 
             fill=secondary_color, width=arrow_width)
    
    # Draw arrowhead for second arrow
    arrow2_head_x = center_x + arrow2_radius * math.cos(math.radians(arrow2_end_angle))
    arrow2_head_y = center_y + arrow2_radius * math.sin(math.radians(arrow2_end_angle))
    
    # 修复箭头方向计算
    angle_rad2 = math.radians(arrow2_end_angle + 90)  # 改为 +90 使箭头指向正确方向
    head_points2 = [
        (arrow2_head_x, arrow2_head_y),
        (arrow2_head_x - head_size * math.cos(angle_rad2 - 0.5),
         arrow2_head_y - head_size * math.sin(angle_rad2 - 0.5)),
        (arrow2_head_x - head_size * math.cos(angle_rad2 + 0.5),
         arrow2_head_y - head_size * math.sin(angle_rad2 + 0.5))
    ]
    draw.polygon(head_points2, fill=secondary_color)
    
    # Add small dots to represent editors - 调整位置使其更对称
    dot_radius = size * 0.04
    # 重新计算点的位置，使其更好地配合循环箭头设计
    dot1_x = center_x - arrow_radius * 1.3
    dot1_y = center_y - arrow_radius * 0.2
    dot2_x = center_x + arrow_radius * 1.3
    dot2_y = center_y + arrow_radius * 0.2
    
    # Xcode dot (left)
    draw.ellipse([dot1_x - dot_radius, dot1_y - dot_radius,
                  dot1_x + dot_radius, dot1_y + dot_radius],
                 fill=accent_color)
    
    # Cursor dot (right)
    draw.ellipse([dot2_x - dot_radius, dot2_y - dot_radius,
                  dot2_x + dot_radius, dot2_y + dot_radius],
                 fill=secondary_color)
    
    return img

def generate_all_icons():
    """Generate all required icon sizes for macOS"""
    # Required sizes for macOS app icons
    sizes = [16, 32, 64, 128, 256, 512, 1024]
    
    # Create output directory
    output_dir = "EditorJumper-X/Assets.xcassets/AppIcon.appiconset"
    os.makedirs(output_dir, exist_ok=True)
    
    # Generate icons for each size
    for size in sizes:
        # 1x version
        icon = create_icon(size)
        icon.save(f"{output_dir}/icon_{size}x{size}.png", "PNG")
        print(f"Generated icon_{size}x{size}.png")
        
        # 2x version (for retina displays)
        if size <= 512:  # Don't create 2x for 1024px
            icon_2x = create_icon(size * 2)
            icon_2x.save(f"{output_dir}/icon_{size}x{size}@2x.png", "PNG")
            print(f"Generated icon_{size}x{size}@2x.png")
    
    print("\nAll icons generated successfully!")
    print(f"Icons saved to: {output_dir}")

if __name__ == "__main__":
    generate_all_icons() 