#include <Carbon/Carbon.h>
#include <CoreGraphics/CoreGraphics.h>
#include <ApplicationServices/ApplicationServices.h>
#include <stdio.h>
#include <unistd.h>

// Private SkyLight framework functions for menu bar manipulation
extern int SLSMainConnectionID();
extern void SLSSetMenuBarVisibilityOverrideOnDisplay(int cid, int did, bool enabled);
extern void SLSSetMenuBarInsetAndAlpha(int cid, double u1, double u2, float alpha);

// Get menu bar extra item by PID and index
AXUIElementRef get_menu_item(pid_t pid, int index) {
  AXUIElementRef app = AXUIElementCreateApplication(pid);
  if (!app) return NULL;

  AXUIElementRef extra_menus_ref = NULL;
  AXUIElementCopyAttributeValue(app, kAXExtrasMenuBarAttribute, (CFTypeRef*)&extra_menus_ref);
  
  if (!extra_menus_ref) {
    CFRelease(app);
    return NULL;
  }

  CFArrayRef children_ref = NULL;
  AXUIElementCopyAttributeValue(extra_menus_ref, kAXVisibleChildrenAttribute, (CFTypeRef*)&children_ref);
  
  if (!children_ref) {
    CFRelease(extra_menus_ref);
    CFRelease(app);
    return NULL;
  }

  uint32_t count = CFArrayGetCount(children_ref);
  
  if (index >= count) {
    CFRelease(children_ref);
    CFRelease(extra_menus_ref);
    CFRelease(app);
    return NULL;
  }

  AXUIElementRef item = CFArrayGetValueAtIndex(children_ref, index);
  CFRetain(item);
  
  CFRelease(children_ref);
  CFRelease(extra_menus_ref);
  CFRelease(app);
  
  return item;
}

// Get position of menu bar item
bool get_item_position(AXUIElementRef item, CGPoint *position) {
  CFTypeRef pos_ref = NULL;
  AXError error = AXUIElementCopyAttributeValue(item, kAXPositionAttribute, &pos_ref);
  
  if (error != kAXErrorSuccess || !pos_ref) {
    return false;
  }
  
  AXValueGetValue(pos_ref, kAXValueCGPointType, position);
  CFRelease(pos_ref);
  return true;
}

// Get size of menu bar item
bool get_item_size(AXUIElementRef item, CGSize *size) {
  CFTypeRef size_ref = NULL;
  AXError error = AXUIElementCopyAttributeValue(item, kAXSizeAttribute, &size_ref);
  
  if (error != kAXErrorSuccess || !size_ref) {
    return false;
  }
  
  AXValueGetValue(size_ref, kAXValueCGSizeType, size);
  CFRelease(size_ref);
  return true;
}

// Simulate mouse click at coordinates
void simulate_click(CGPoint location, bool verbose) {
  if (verbose) {
    printf("[DEBUG] Simulating mouse click at (%.0f, %.0f)\n", location.x, location.y);
  }
  
  // Move mouse to location
  CGEventRef moveEvent = CGEventCreateMouseEvent(NULL, kCGEventMouseMoved, location, kCGMouseButtonLeft);
  CGEventPost(kCGHIDEventTap, moveEvent);
  CFRelease(moveEvent);
  
  usleep(50000); // 50ms delay
  
  // Mouse down
  CGEventRef downEvent = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseDown, location, kCGMouseButtonLeft);
  CGEventPost(kCGHIDEventTap, downEvent);
  CFRelease(downEvent);
  
  usleep(100000); // 100ms delay
  
  // Mouse up
  CGEventRef upEvent = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseUp, location, kCGMouseButtonLeft);
  CGEventPost(kCGHIDEventTap, upEvent);
  CFRelease(upEvent);
  
  if (verbose) {
    printf("[DEBUG] Click completed\n");
  }
}

int main(int argc, char *argv[]) {
  if (argc < 3) {
    printf("Usage: %s <PID> <index> [-v]\n", argv[0]);
    printf("Example: %s 61741 0 -v\n", argv[0]);
    return 1;
  }
  
  pid_t pid = atoi(argv[1]);
  int index = atoi(argv[2]);
  bool verbose = (argc > 3 && strcmp(argv[3], "-v") == 0);
  
  if (verbose) {
    printf("[DEBUG] Attempting to click menu item for PID %d, index %d\n", pid, index);
  }
  
  // Get the menu bar item FIRST (while hidden)
  AXUIElementRef item = get_menu_item(pid, index);
  if (!item) {
    fprintf(stderr, "Error: Could not find menu bar item\n");
    return 1;
  }
  
  // Show the menu bar FIRST
  if (verbose) {
    printf("[DEBUG] Showing menu bar temporarily\n");
  }
  
  int cid = SLSMainConnectionID();
  SLSSetMenuBarInsetAndAlpha(cid, 0, 1, 0.0);
  SLSSetMenuBarVisibilityOverrideOnDisplay(cid, 0, true);
  SLSSetMenuBarInsetAndAlpha(cid, 0, 1, 0.0);
  
  // Wait longer for menu bar to appear and items to settle
  usleep(800000); // 800ms delay - gives menu bar time to fully appear
  
  // NOW get the position AFTER the menu bar is visible
  CGPoint position;
  CGSize size;
  
  if (!get_item_position(item, &position)) {
    fprintf(stderr, "Error: Could not get item position\n");
    CFRelease(item);
    return 1;
  }
  
  if (!get_item_size(item, &size)) {
    if (verbose) {
      fprintf(stderr, "[DEBUG] Warning: Could not get item size, using defaults\n");
    }
    size.width = 30;
    size.height = 22;
  }
  
  // Calculate center of the item
  CGPoint clickPoint;
  clickPoint.x = position.x + (size.width / 2);
  clickPoint.y = position.y + (size.height / 2);
  
  if (verbose) {
    printf("[DEBUG] Item position: (%.0f, %.0f)\n", position.x, position.y);
    printf("[DEBUG] Item size: (%.0f, %.0f)\n", size.width, size.height);
    printf("[DEBUG] Click point: (%.0f, %.0f)\n", clickPoint.x, clickPoint.y);
  }
  
  // Simulate the click
  simulate_click(clickPoint, verbose);
  
  // Wait for popup to appear
  usleep(300000); // 300ms
  
  if (verbose) {
    printf("[DEBUG] Menu bar interaction complete\n");
  }
  
  CFRelease(item);
  return 0;
}
