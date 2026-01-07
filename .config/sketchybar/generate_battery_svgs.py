import os

def create_battery_svg(percentage, charging, filename):
    # Dimensions
    width = 200
    height = 100
    stroke = 12
    
    # Battery Geometry
    body_width = 160
    body_height = 80
    body_x = 10
    body_y = 10
    rx = 18
    ry = 18
    
    # Terminal Geometry
    term_width = 12
    term_height = 30
    term_x = body_x + body_width
    term_y = body_y + (body_height - term_height) / 2
    
    # Fill Geometry
    fill_max_width = body_width - (2 * stroke) - 8
    fill_width = (percentage / 100.0) * fill_max_width
    fill_height = body_height - (2 * stroke) - 8
    fill_x = body_x + stroke + 4
    fill_y = body_y + stroke + 4
    
    # Bolt Geometry
    # "Cutout" is the larger shape that creates the gap
    # "Inner" is the actual bolt
    # Note: These paths must be closed (Z)
    
    # Coordinates for the Bolt
    # Center approx (100, 50)
    # Original: M95,20 L70,60 H95 L85,90 L125,45 H100 L110,20 Z
    # We need to scale these relative to center
    
    # Inner Bolt Path
    bolt_inner = "M95,20 L70,60 L95,60 L85,90 L125,45 L100,45 L110,20 Z"
    
    # Cutout Bolt Path (Expanded by ~6px in all directions manually estimated)
    # This acts as the "eraser"
    bolt_cutout = "M90,12 L60,58 L85,58 L75,98 L133,42 L108,42 L118,12 Z"

    # SVG Construction
    # We use fill-rule="evenodd".
    # All shapes that should be "filled" are added.
    # If shapes overlap, even-odd rule handles the holes.
    # 1. Battery Body (Outer Rect)
    # 2. Battery Body (Inner Rect - to make the stroke) -> subtracted
    # 3. Fill Rect -> added
    # 4. Bolt Cutout -> subtracted (if we manage order correctly or use distinct paths)
    
    # Actually, easier way for evenodd:
    # Everything is in one path.
    # "Holes" are just subpaths.
    
    # 1. Outer Body Rect
    path_body_outer = f"M{body_x+rx},{body_y} h{body_width-2*rx} a{rx},{ry} 0 0 1 {rx},{ry} v{body_height-2*ry} a{rx},{ry} 0 0 1 -{rx},{ry} h-{body_width-2*rx} a{rx},{ry} 0 0 1 -{rx},-{ry} v-{body_height-2*ry} a{rx},{ry} 0 0 1 {rx},-{ry} z"
    
    # 2. Inner Body Rect (Hole for the body stroke)
    # Inset by stroke width
    ix = body_x + stroke
    iy = body_y + stroke
    iw = body_width - 2*stroke
    ih = body_height - 2*stroke
    irx = max(0, rx - stroke)
    path_body_inner = f"M{ix+irx},{iy} h{iw-2*irx} a{irx},{irx} 0 0 1 {irx},{irx} v{ih-2*irx} a{irx},{irx} 0 0 1 -{irx},{irx} h-{iw-2*irx} a{irx},{irx} 0 0 1 -{irx},-{irx} v-{ih-2*irx} a{irx},{irx} 0 0 1 {irx},-{irx} z"
    
    # 3. Terminal
    # Just a solid shape
    path_term = f"M{term_x},{term_y} v{term_height} c4,0 8,-4 8,-8 v-{term_height - 16} c0,-4 -4,-8 -8,-8 z"
    
    # 4. Fill Rect (Solid)
    # Only draw if > 0
    path_fill = ""
    if percentage > 0:
        path_fill = f"M{fill_x+6},{fill_y} h{max(0, fill_width-12)} a6,6 0 0 1 6,6 v{fill_height-12} a6,6 0 0 1 -6,6 h-{max(0, fill_width-12)} a6,6 0 0 1 -6,-6 v-{fill_height-12} a6,6 0 0 1 6,-6 z"

    # SVG Output
    # We combine all "Black" parts into one path definition
    # And "Holes" (Bolt Cutout) into the same definition
    
    # For EvenOdd to work as "A minus B":
    # We draw Positive Shape (Body + Fill + Inner Bolt)
    # We draw Negative Shape (Bolt Cutout)
    # If they are in the same <path d="..."> tag, EvenOdd will subtract the cutout from the underlying positive shapes.
    
    combined_path = f"{path_body_outer} {path_body_inner} {path_term} {path_fill}"
    
    if charging:
        # Add the Bolt logic
        # We need the "Cutout" to create a hole in the Battery/Fill
        # And the "Inner" to fill that hole back in partially
        # With EvenOdd:
        # (Body + Fill) = Black
        # (Cutout) overlaps (Body+Fill) -> Becomes White (Hole)
        # (Inner) overlaps (Cutout) -> Becomes Black (Filled again)
        # This works perfectly!
        combined_path += f" {bolt_cutout} {bolt_inner}"
        
    svg_content = f'''<svg width="{width}" height="{height}" viewBox="0 0 {width} {height}" xmlns="http://www.w3.org/2000/svg">
    <path fill-rule="evenodd" d="{combined_path}" fill="black" />
</svg>'''
    
    with open(filename, "w") as f:
        f.write(svg_content)

def main():
    output_dir = "assets/battery_svgs"
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
        
    # Generate 0 to 100 in steps of 10
    for i in range(0, 101, 10):
        # Normal
        create_battery_svg(i, False, f"{output_dir}/battery_{i}.svg")
        # Charging
        create_battery_svg(i, True, f"{output_dir}/battery_charging_{i}.svg")
        
    print(f"Generated battery SVGs in {output_dir}")

if __name__ == "__main__":
    main()
