#!/usr/bin/env python3
"""
Icon Preview Generator for Editor Jumper Mac App
Creates a preview image showing the icon at different sizes
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_preview():
    """Create a preview image showing the icon at different sizes"""
    # Load the largest icon
    icon_path = "EditorJumper-X/Assets.xcassets/AppIcon.appiconset/icon_512x512.png"
    
    if not os.path.exists(icon_path):
        print(f"Icon file not found: {icon_path}")
        return
    
    # Create preview canvas
    preview_width = 800
    preview_height = 600
    preview = Image.new('RGB', (preview_width, preview_height), (240, 240, 240))
    
    # Load the icon
    icon = Image.open(icon_path)
    
    # Define preview sizes and positions
    sizes_and_positions = [
        (256, 50, 50),    # Large icon
        (128, 350, 50),   # Medium icon
        (64, 520, 50),    # Small icon
        (32, 600, 50),    # Tiny icon
        (16, 650, 50),    # Mini icon
    ]
    
    # Paste icons at different sizes
    for size, x, y in sizes_and_positions:
        resized_icon = icon.resize((size, size), Image.Resampling.LANCZOS)
        preview.paste(resized_icon, (x, y), resized_icon)
        
        # Add size label
        draw = ImageDraw.Draw(preview)
        try:
            # Try to use a system font
            font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 16)
        except:
            # Fallback to default font
            font = ImageFont.load_default()
        
        label = f"{size}×{size}"
        draw.text((x, y + size + 10), label, fill=(60, 60, 60), font=font)
    
    # Add title
    draw = ImageDraw.Draw(preview)
    try:
        title_font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 24)
    except:
        title_font = ImageFont.load_default()
    
    title = "Editor Jumper - App Icon Preview"
    draw.text((50, 10), title, fill=(30, 30, 30), font=title_font)
    
    # Add description
    try:
        desc_font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 14)
    except:
        desc_font = ImageFont.load_default()
    
    description = "Icon design featuring circular arrows representing seamless jumping between Xcode and Cursor"
    draw.text((50, 380), description, fill=(80, 80, 80), font=desc_font)
    
    # Save preview
    preview.save("icon_preview.png", "PNG")
    print("Icon preview saved as 'icon_preview.png'")

if __name__ == "__main__":
    create_preview() 