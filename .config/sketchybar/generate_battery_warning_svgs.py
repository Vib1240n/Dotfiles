import os

def create_svg(filename, content):
    with open(filename, "w") as f:
        f.write(content)

def main():
    output_dir = "assets/battery_svgs"
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Common Dimensions
    width = 200
    height = 100
    stroke = 12
    
    body_width = 160
    body_height = 80
    body_x = 10
    body_y = 10
    rx = 18
    ry = 18
    
    # Terminal
    term_width = 12
    term_height = 30
    term_x = body_x + body_width
    term_y = body_y + (body_height - term_height) / 2
    
    # 1. Outer Body Rect
    path_body_outer = f"M{body_x+rx},{body_y} h{body_width-2*rx} a{rx},{ry} 0 0 1 {rx},{ry} v{body_height-2*ry} a{rx},{ry} 0 0 1 -{rx},{ry} h-{body_width-2*rx} a{rx},{ry} 0 0 1 -{rx},-{ry} v-{body_height-2*ry} a{rx},{ry} 0 0 1 {rx},-{ry} z"
    
    # 2. Inner Body Rect (Hole for stroke)
    ix = body_x + stroke
    iy = body_y + stroke
    iw = body_width - 2*stroke
    ih = body_height - 2*stroke
    irx = max(0, rx - stroke)
    path_body_inner = f"M{ix+irx},{iy} h{iw-2*irx} a{irx},{irx} 0 0 1 {irx},{irx} v{ih-2*irx} a{irx},{irx} 0 0 1 -{irx},{irx} h-{iw-2*irx} a{irx},{irx} 0 0 1 -{irx},-{irx} v-{ih-2*irx} a{irx},{irx} 0 0 1 {irx},-{irx} z"
    
    # 3. Terminal
    path_term = f"M{term_x},{term_y} v{term_height} c4,0 8,-4 8,-8 v-{term_height - 16} c0,-4 -4,-8 -8,-8 z"
    
    # Base Battery Path (Body Outer + Body Inner + Terminal)
    # Body Inner is "inside" Body Outer, so EvenOdd makes it a hole -> Stroke.
    base_path = f"{path_body_outer} {path_body_inner} {path_term}"

    # --- Warning Icon ---
    # Triangle Cutout (Larger)
    warn_cutout = "M90,15 L55,85 L125,85 Z"
    # Triangle Inner (Smaller - effectively the stroke of the triangle)
    # Actually, simpler: Triangle Cutout makes a hole in the battery.
    # Exclamation mark makes a solid inside the hole.
    # Wait, the triangle itself should be a stroke.
    # So:
    # 1. Triangle Outer (Cutout)
    # 2. Triangle Inner (Solid - fills back in)
    # 3. Exclamation Mark (Cutout - makes hole in triangle inner)
    
    # Let's align with the previous design:
    # Triangle stroke was black. Inside was empty?
    # No, usually warning is a symbol overlaid.
    # Let's just make a solid Triangle Cutout. And inside it, draw the Exclamation Mark.
    # So: Battery - Triangle = Hole.
    # Hole + Exclamation = Exclamation floating in hole.
    warn_excl = "M88,58 h4 v15 h-4 z M90,50 a3,3 0 1 0 0.001,0 z" # Exclamation + Dot
    
    warning_combined = f"{base_path} {warn_cutout} {warn_excl}"
    
    warning_svg = f'''<svg width="{width}" height="{height}" viewBox="0 0 {width} {height}" xmlns="http://www.w3.org/2000/svg">
    <path fill-rule="evenodd" d="{warning_combined}" fill="black" />
    </svg>'''
    create_svg(f"{output_dir}/battery_warning.svg", warning_svg)

    # --- Slow Charging Icon ---
    # Small Bolt Cutout
    slow_cutout = "M80,30 L65,55 L83,55 L78,80 L105,45 L88,45 Z" # Slightly larger
    # Question Mark or Text inside?
    # Previous code used text "?".
    # Text in SVG to Font is tricky (must be converted to path).
    # I will replace text with a simple path for "?" to be safe.
    # Or just use the small bolt as the cutout, and leave it empty?
    # "Slow" usually implies a problem or weak connection.
    # Let's just use the cutout of the bolt. 
    # So it looks like a hole in the shape of a bolt.
    
    slow_combined = f"{base_path} {slow_cutout}"
    
    slow_svg = f'''<svg width="{width}" height="{height}" viewBox="0 0 {width} {height}" xmlns="http://www.w3.org/2000/svg">
    <path fill-rule="evenodd" d="{slow_combined}" fill="black" />
    </svg>'''
    create_svg(f"{output_dir}/battery_charging_slow.svg", slow_svg)

    print(f"Generated warning SVGs in {output_dir}")

if __name__ == "__main__":
    main()
