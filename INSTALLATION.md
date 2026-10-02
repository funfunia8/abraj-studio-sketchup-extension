# ABRAJ STUDIO - SketchUp Extension Installation Guide

## Installation Steps

### Windows
1. Open File Explorer
2. Navigate to: `C:\Users\YourUsername\AppData\Roaming\SketchUp\SketchUp 2026\SketchUp\Plugins\`
3. Create a new folder named `abraj_studio`
4. Copy all files from this repository into that folder
5. Restart SketchUp

### Mac
1. Open Finder
2. Navigate to: `~/Library/Application Support/SketchUp 2026/SketchUp/Plugins/`
3. Create a new folder named `abraj_studio`
4. Copy all files from this repository into that folder
5. Restart SketchUp

## File Structure

The extension folder should look like this:

```
abraj_studio/
├── loader.rb
├── main.rb
└── ui.html
```

## Usage

1. Open SketchUp
2. Go to Plugins > ABRAJ STUDIO
3. Click "New Base Cabinet"
4. Enter dimensions (width, height, depth)
5. Select material and options
6. Click "Generate Cabinet"
7. The 3D model will be created in your SketchUp project

## Features

- Parametric cabinet design
- Automatic 3D model generation
- Cut list export (CSV)
- BOM export (CSV)
- DXF export for manufacturing

## Requirements

- SketchUp 2026 or later
- Ruby support enabled in SketchUp
