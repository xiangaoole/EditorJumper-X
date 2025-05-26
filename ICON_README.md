# Editor Jumper - App Icon

## Design Concept

The app icon designed for Editor Jumper Mac application embodies the core functionality of seamless jumping between Xcode and Cursor editors.

### Design Elements

1. **Blue Rounded Rectangle Background** - Modern macOS application design language
2. **Bidirectional Circular Arrows** - Represents bidirectional jumping between two editors
   - White primary arrow: Jump from Xcode to Cursor
   - Yellow secondary arrow: Jump from Cursor to Xcode
3. **Editor Identifier Dots** - Two small dots representing Xcode and Cursor editors

### Color Scheme

- **Primary Color**: Blue (#2D9CDB) - Professional, trustworthy
- **Accent Color**: White (#FFFFFF) - Clean, simple
- **Secondary Color**: Yellow (#FFC107) - Energetic, innovative

## Generated Files

Icons have been generated in the following sizes, compliant with macOS app icon specifications:

- 16×16 (1x, 2x)
- 32×32 (1x, 2x) 
- 128×128 (1x, 2x)
- 256×256 (1x, 2x)
- 512×512 (1x, 2x)
- 1024×1024

## File Location

All icon files are located at:
```
EditorJumper-X/Assets.xcassets/AppIcon.appiconset/
```

## Usage

1. Icon files are automatically configured in the Xcode project
2. `Contents.json` has been updated with all necessary file references
3. Icons will be automatically included in the app bundle when building the project in Xcode

## Preview

Run `python3 preview_icon.py` to generate an icon preview image `icon_preview.png`

## Regenerating Icons

To modify the icon design:

1. Edit the design parameters in the `generate_icon.py` file
2. Run `python3 generate_icon.py` to regenerate all icon sizes
3. Icons will automatically replace existing files

## Technical Specifications

- Format: PNG
- Color Space: RGBA
- Background: Transparent (blue within rounded rectangle)
- Resolution: High-resolution versions for Retina displays 