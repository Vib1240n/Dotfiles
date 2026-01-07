import os
from shapely.geometry import Polygon, MultiPolygon, box, Point
from shapely.ops import unary_union
from shapely.affinity import translate, scale

# --- Configuration ---
OUTPUT_DIR = "assets/battery_svgs"
CANVAS_W, CANVAS_H = 200, 100
STROKE = 12
CORNER_RADIUS = 18

BODY_W, BODY_H = 160, 80
BODY_X, BODY_Y = 10, 10

TERM_W, TERM_H = 12, 30

# Colors
COLOR = "black"

def create_rounded_rect(x, y, w, h, r):
    """
    Creates a rounded rectangle using Shapely by buffering a smaller inner box.
    """
    inner_w = w - 2*r
    inner_h = h - 2*r
    inner_x = x + r
    inner_y = y + r
    
    if inner_w < 0 or inner_h < 0:
        return box(x, y, x+w, y+h)
        
    b = box(inner_x, inner_y, inner_x + inner_w, inner_y + inner_h)
    return b.buffer(r, resolution=16)

def create_bolt_shape():
    """Returns the charging bolt Polygon centered approx at 97, 55"""
    points = [
        (95, 20), (70, 60), (95, 60), 
        (85, 90), (125, 45), (100, 45), (110, 20)
    ]
    return Polygon(points)

def create_plug_shape():
    """Returns a Plug Polygon (Power Adapter icon)"""
    # A simple 2-prong plug head
    # Body of plug (centered roughly)
    # Box approx 40x30
    plug_body = box(80, 35, 120, 65)
    
    # Prongs (sticking out left)
    # prong 1
    p1 = box(70, 40, 80, 46)
    # prong 2
    p2 = box(70, 54, 80, 60)
    
    # Cord (sticking out right) - stylized as a small nub or line
    cord = box(120, 45, 130, 55)
    
    return unary_union([plug_body, p1, p2, cord])

def create_warning_shape():
    """Returns Exclamation Mark Polygon"""
    rect = box(88, 58, 92, 73)
    dot_circle = Point(90, 52).buffer(2.5)
    return unary_union([rect, dot_circle])

def create_triangle_shape():
    """Returns Warning Triangle Polygon"""
    points = [(90, 25), (60, 80), (120, 80)]
    return Polygon(points)

def poly_to_svg_path(geom):
    """Converts a Shapely geometry to an SVG path string."""
    if geom.is_empty:
        return ""
    
    path_data = []
    
    def process_polygon(p):
        # Exterior
        coords = list(p.exterior.coords)
        if not coords: return
        path_data.append(f"M {coords[0][0]:.2f} {coords[0][1]:.2f}")
        for x, y in coords[1:]:
            path_data.append(f"L {x:.2f} {y:.2f}")
        path_data.append("Z")
        
        # Interiors (Holes)
        for interior in p.interiors:
            coords = list(interior.coords)
            if not coords: continue
            path_data.append(f"M {coords[0][0]:.2f} {coords[0][1]:.2f}")
            for x, y in coords[1:]:
                path_data.append(f"L {x:.2f} {y:.2f}")
            path_data.append("Z")

    if geom.geom_type == 'Polygon':
        process_polygon(geom)
    elif geom.geom_type == 'MultiPolygon':
        for poly in geom.geoms:
            process_polygon(poly)
            
    return " ".join(path_data)

def generate_svg(filename, final_geom):
    path_d = poly_to_svg_path(final_geom)
    svg_content = f'''<svg width="{CANVAS_W}" height="{CANVAS_H}" viewBox="0 0 {CANVAS_W} {CANVAS_H}" xmlns="http://www.w3.org/2000/svg">
    <path fill-rule="evenodd" d="{path_d}" fill="{COLOR}" />
</svg>'''
    with open(filename, "w") as f:
        f.write(svg_content)

def main():
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)

    # 1. Base Battery Shapes
    body_outer = create_rounded_rect(BODY_X, BODY_Y, BODY_W, BODY_H, CORNER_RADIUS)
    body_inner = create_rounded_rect(
        BODY_X + STROKE, BODY_Y + STROKE, 
        BODY_W - 2*STROKE, BODY_H - 2*STROKE, 
        max(0, CORNER_RADIUS - STROKE)
    )
    
    term_x = BODY_X + BODY_W
    term_y = BODY_Y + (BODY_H - TERM_H) / 2
    terminal = create_rounded_rect(term_x, term_y, TERM_W, TERM_H, 4)
    
    battery_frame = body_outer.difference(body_inner).union(terminal)

    # 2. Fill Logic
    fill_max_w = BODY_W - 2*STROKE - 8
    fill_max_h = BODY_H - 2*STROKE - 8
    fill_x_start = BODY_X + STROKE + 4
    fill_y_start = BODY_Y + STROKE + 4
    
    # Pre-calculate Bolt
    bolt = create_bolt_shape()
    bolt_cutout = bolt.buffer(8, join_style=2)
    
    # Pre-calculate Plug
    plug = create_plug_shape()
    plug_cutout = plug.buffer(8, join_style=2)

    # Pre-calculate Warning
    triangle = create_triangle_shape()
    triangle_cutout = triangle.buffer(8, join_style=2)
    excl_box = box(88, 58, 92, 73)
    excl_dot = Point(90, 52).buffer(2.5)
    excl = unary_union([excl_box, excl_dot])

    small_bolt = scale(bolt, xfact=0.7, yfact=0.7, origin=(100, 50))
    small_bolt_cutout = small_bolt.buffer(6)

    # --- Generation Loop ---
    for i in range(0, 101, 10):
        # Calculate Fill Shape
        if i == 0:
            fill_shape = Polygon()
        else:
            current_fill_w = (i / 100.0) * fill_max_w
            fill_shape = create_rounded_rect(fill_x_start, fill_y_start, current_fill_w, fill_max_h, 6)
        
        base = battery_frame.union(fill_shape)
        
        # --- Normal Battery ---
        generate_svg(f"{OUTPUT_DIR}/battery_{i}.svg", base)
        
        # --- Charging Battery ---
        cut_chg = base.difference(bolt_cutout)
        final_charging = cut_chg.union(bolt)
        generate_svg(f"{OUTPUT_DIR}/battery_charging_{i}.svg", final_charging)
        
        # --- Plugged (Not Charging) ---
        cut_plug = base.difference(plug_cutout)
        final_plugged = cut_plug.union(plug)
        generate_svg(f"{OUTPUT_DIR}/battery_plugged_{i}.svg", final_plugged)

    # --- Warning ---
    tri_stroke_width = 6
    tri_inner = triangle.buffer(-tri_stroke_width)
    tri_shape = triangle.difference(tri_inner)
    warn_symbol = tri_shape.union(excl)
    final_warning = battery_frame.difference(triangle_cutout).union(warn_symbol)
    generate_svg(f"{OUTPUT_DIR}/battery_warning.svg", final_warning)

    # --- Slow ---
    base_slow = battery_frame 
    final_slow = base_slow.difference(small_bolt_cutout).union(small_bolt)
    generate_svg(f"{OUTPUT_DIR}/battery_charging_slow.svg", final_slow)
    
    print(f"Robust SVGs (including Plugged) generated in {OUTPUT_DIR}")

if __name__ == "__main__":
    main()
