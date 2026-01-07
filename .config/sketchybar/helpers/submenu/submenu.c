#include <Carbon/Carbon.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <ApplicationServices/ApplicationServices.h>
#include <libproc.h>

// Accessibility initialization
void ax_init() {
  const void *keys[] = { kAXTrustedCheckOptionPrompt };
  const void *values[] = { kCFBooleanTrue };

  CFDictionaryRef options;
  options = CFDictionaryCreate(kCFAllocatorDefault,
                               keys,
                               values,
                               sizeof(keys) / sizeof(*keys),
                               &kCFCopyStringDictionaryKeyCallBacks,
                               &kCFTypeDictionaryValueCallBacks);

  bool trusted = AXIsProcessTrustedWithOptions(options);
  CFRelease(options);
  
  if (!trusted) {
    fprintf(stderr, "Error: Accessibility permissions not granted.\n");
    fprintf(stderr, "Enable accessibility in System Settings > Privacy & Security > Accessibility\n");
    exit(1);
  }
}

// Check if string is a valid PID (all digits)
int is_pid(const char *str) {
  if (!str || *str == '\0') return 0;
  for (const char *p = str; *p != '\0'; p++) {
    if (*p < '0' || *p > '9') return 0;
  }
  return 1;
}

// Get menu bar extra item(s) for a process
AXUIElementRef ax_get_extra_menu_item(pid_t pid, int index, int verbose) {
  AXUIElementRef app = AXUIElementCreateApplication(pid);
  if (!app) {
    if (verbose) fprintf(stderr, "Error: Could not create AX element for PID %d\n", pid);
    return NULL;
  }

  AXUIElementRef extra_menus_ref = NULL;
  CFArrayRef children_ref = NULL;
  AXUIElementRef result = NULL;

  AXError error = AXUIElementCopyAttributeValue(app,
                                                kAXExtrasMenuBarAttribute,
                                                (CFTypeRef*)&extra_menus_ref);
  
  if (error != kAXErrorSuccess) {
    if (verbose) fprintf(stderr, "[DEBUG] Process %d has no menu bar extras (error=%d)\n", pid, error);
    CFRelease(app);
    return NULL;
  }

  error = AXUIElementCopyAttributeValue(extra_menus_ref,
                                        kAXVisibleChildrenAttribute,
                                        (CFTypeRef*)&children_ref);

  if (error == kAXErrorSuccess) {
    uint32_t count = CFArrayGetCount(children_ref);
    
    if (verbose) fprintf(stderr, "[DEBUG] Found %d menu bar extra(s) for PID %d\n", count, pid);

    if (count > 0) {
      if (index < 0 || index >= count) index = 0;
      result = (AXUIElementRef)CFRetain(CFArrayGetValueAtIndex(children_ref, index));
      if (verbose) fprintf(stderr, "[DEBUG] Selected item at index %d\n", index);
    }
    
    CFRelease(children_ref);
  }

  CFRelease(extra_menus_ref);
  CFRelease(app);
  
  return result;
}

// Get process name from PID
char* get_process_name(pid_t pid) {
  static char name[256];
  char pathbuf[PROC_PIDPATHINFO_MAXSIZE];
  
  if (proc_pidpath(pid, pathbuf, sizeof(pathbuf)) > 0) {
    char *last_slash = strrchr(pathbuf, '/');
    if (last_slash && *(last_slash + 1)) {
      strncpy(name, last_slash + 1, sizeof(name) - 1);
      name[sizeof(name) - 1] = '\0';
      return name;
    }
  }
  
  snprintf(name, sizeof(name), "Unknown");
  return name;
}

// Forward declarations
void click_menu_extra(pid_t pid, int index, int verbose);

// Find Stats index from sketchybar alias
int get_stats_index_from_sketchybar(const char *target_alias, int verbose) {
  FILE *fp = popen("sketchybar --query default_menu_items 2>/dev/null", "r");
  if (!fp) {
    if (verbose) fprintf(stderr, "[DEBUG] Failed to query sketchybar\n");
    return -1;
  }
  
  char line[512];
  int stats_index = 0;  // Counter for Stats items only
  
  // Build the full alias string to match: "Control Center,<target>"
  char full_alias[512];
  snprintf(full_alias, sizeof(full_alias), "Control Center,%s", target_alias);
  
  if (verbose) fprintf(stderr, "[DEBUG] Looking for sketchybar alias: %s\n", full_alias);
  
  // Stats-related aliases to count
  const char* stats_aliases[] = {
    "Battery", "RAM_mini", "CPU_mini", "Network_speed", 
    "Disk_mini", "Sensors_sensors", "GPU"
  };
  int num_stats_aliases = 7;
  
  while (fgets(line, sizeof(line), fp)) {
    // Only process Control Center aliases
    if (strstr(line, "Control Center,") != NULL) {
      
      // Check if this is a Stats-related alias
      int is_stats_alias = 0;
      for (int i = 0; i < num_stats_aliases; i++) {
        if (strstr(line, stats_aliases[i]) != NULL) {
          is_stats_alias = 1;
          break;
        }
      }
      
      if (is_stats_alias) {
        if (verbose) fprintf(stderr, "[DEBUG] Stats alias %d: %s", stats_index, line);
        
        // Check if this line contains our target alias
        if (strstr(line, full_alias) != NULL) {
          if (verbose) fprintf(stderr, "[DEBUG] Found target at Stats index %d\n", stats_index);
          pclose(fp);
          return stats_index;
        }
        stats_index++;
      }
    }
  }
  
  pclose(fp);
  if (verbose) fprintf(stderr, "[DEBUG] Alias not found in sketchybar output\n");
  return -1;
}

// Find and click by alias (Format: "Control Center,ItemName")
int click_by_alias(const char *alias, int verbose) {
  if (!alias) return 0;
  
  // Parse alias: "ProcessName,ItemName"
  const char *comma = strchr(alias, ',');
  if (!comma) {
    if (verbose) fprintf(stderr, "[DEBUG] Invalid alias format (expected 'Process,Item')\n");
    return 0;
  }
  
  char process_part[256];
  size_t proc_len = comma - alias;
  if (proc_len >= sizeof(process_part)) proc_len = sizeof(process_part) - 1;
  strncpy(process_part, alias, proc_len);
  process_part[proc_len] = '\0';
  
  char item_part[256];
  strncpy(item_part, comma + 1, sizeof(item_part) - 1);
  item_part[sizeof(item_part) - 1] = '\0';
  
  if (verbose) {
    fprintf(stderr, "[DEBUG] Searching for alias='%s'\n", alias);
  }
  
  // Special case: Control Center aliases in sketchybar map to Stats app
  if (strcmp(process_part, "Control Center") == 0) {
    if (verbose) fprintf(stderr, "[DEBUG] Control Center alias detected, using Stats process\n");
    
    // Get index from sketchybar
    int index = get_stats_index_from_sketchybar(item_part, verbose);
    if (index < 0) {
      if (verbose) fprintf(stderr, "[DEBUG] Could not find alias in sketchybar\n");
      return 0;
    }
    
    // Find Stats PID
    pid_t stats_pid = 0;
    CFArrayRef apps = CGWindowListCopyWindowInfo(kCGWindowListOptionAll, kCGNullWindowID);
    
    for (int i = 0; i < CFArrayGetCount(apps); i++) {
      CFDictionaryRef window = CFArrayGetValueAtIndex(apps, i);
      CFNumberRef pid_ref = CFDictionaryGetValue(window, kCGWindowOwnerPID);
      if (!pid_ref) continue;
      
      pid_t pid;
      CFNumberGetValue(pid_ref, kCFNumberIntType, &pid);
      
      char* proc_name = get_process_name(pid);
      if (strcmp(proc_name, "Stats") == 0) {
        stats_pid = pid;
        break;
      }
    }
    
    CFRelease(apps);
    
    if (stats_pid == 0) {
      if (verbose) fprintf(stderr, "[DEBUG] Could not find Stats process\n");
      return 0;
    }
    
    // Stats menu bar items are in different order than sketchybar aliases
    // Based on testing, here's the mapping:
    // Sketchybar → Stats
    // Battery (0) → 6
    // RAM (1) → 4
    // CPU (2) → 5
    // Network (3) → 1
    // Disk (4) → 3
    // Sensors (5) → 2
    
    int stats_index = -1;
    switch (index) {
      case 0: stats_index = 6; break; // Battery
      case 1: stats_index = 4; break; // RAM
      case 2: stats_index = 5; break; // CPU
      case 3: stats_index = 1; break; // Network
      case 4: stats_index = 3; break; // Disk
      case 5: stats_index = 2; break; // Sensors
      default: stats_index = index; break; // Fallback
    }
    
    if (verbose) {
      fprintf(stderr, "[DEBUG] Found Stats PID: %d\n", stats_pid);
      fprintf(stderr, "[DEBUG] Sketchybar index: %d → Stats index: %d (mapped)\n", index, stats_index);
    }
    
    // Click the Stats item at the mapped index
    click_menu_extra(stats_pid, stats_index, verbose);
    return 1;
  }
  
  // Original alias matching code for other processes
  if (verbose) {
    fprintf(stderr, "[DEBUG] Searching for process='%s', item='%s'\n", process_part, item_part);
  }
  
  // For non-Control Center aliases, do general search by process name and item description
  if (verbose) {
    fprintf(stderr, "[DEBUG] Searching for process='%s', item='%s'\n", process_part, item_part);
  }
  
  CFArrayRef apps = CGWindowListCopyWindowInfo(kCGWindowListOptionAll, kCGNullWindowID);
  pid_t checked_pids[1000];
  int checked_count = 0;
  int found = 0;
  
  // For non-Control Center aliases, search through processes
  for (int i = 0; i < CFArrayGetCount(apps); i++) {
    CFDictionaryRef window = CFArrayGetValueAtIndex(apps, i);
    CFNumberRef pid_ref = CFDictionaryGetValue(window, kCGWindowOwnerPID);
    if (!pid_ref) continue;
    
    pid_t pid;
    CFNumberGetValue(pid_ref, kCFNumberIntType, &pid);
    
    // Skip already checked PIDs
    int already_checked = 0;
    for (int j = 0; j < checked_count; j++) {
      if (checked_pids[j] == pid) {
        already_checked = 1;
        break;
      }
    }
    if (already_checked || checked_count >= 1000) continue;
    checked_pids[checked_count++] = pid;
    
    // Check if this process matches
    char* proc_name = get_process_name(pid);
    if (verbose) fprintf(stderr, "[DEBUG] Checking PID %d: %s\n", pid, proc_name);
    
    // Match process name
    int process_matches = 0;
    if (strstr(proc_name, process_part) != NULL) {
      process_matches = 1;
    }
    
    if (!process_matches) continue;
    
    if (verbose) fprintf(stderr, "[DEBUG] Process matched! Checking menu bar items...\n");
    
    // Get menu bar extras for this process
    AXUIElementRef app = AXUIElementCreateApplication(pid);
    if (!app) continue;
    
    AXUIElementRef extras = NULL;
    AXError error = AXUIElementCopyAttributeValue(app, kAXExtrasMenuBarAttribute, (CFTypeRef*)&extras);
    
    if (error == kAXErrorSuccess && extras) {
      CFArrayRef children = NULL;
      error = AXUIElementCopyAttributeValue(extras, kAXVisibleChildrenAttribute, (CFTypeRef*)&children);
      
      if (error == kAXErrorSuccess && children) {
        uint32_t count = CFArrayGetCount(children);
        
        // Search through items
        for (uint32_t idx = 0; idx < count; idx++) {
          AXUIElementRef item = CFArrayGetValueAtIndex(children, idx);
          
          CFTypeRef desc = NULL;
          AXUIElementCopyAttributeValue(item, kAXDescriptionAttribute, &desc);
          
          CFTypeRef title = NULL;
          AXUIElementCopyAttributeValue(item, kAXTitleAttribute, &title);
          
          char desc_buf[256] = {0};
          char title_buf[256] = {0};
          
          if (desc) {
            CFStringGetCString(desc, desc_buf, sizeof(desc_buf), kCFStringEncodingUTF8);
            CFRelease(desc);
          }
          
          if (title) {
            CFStringGetCString(title, title_buf, sizeof(title_buf), kCFStringEncodingUTF8);
            CFRelease(title);
          }
          
          if (verbose) {
            fprintf(stderr, "[DEBUG] Item %d: desc='%s', title='%s'\n", idx, desc_buf, title_buf);
          }
          
          // Check if item matches
          if (strstr(desc_buf, item_part) != NULL || strstr(title_buf, item_part) != NULL) {
            if (verbose) fprintf(stderr, "[DEBUG] Match found! Clicking...\n");
            
            // Click the item
            AXError click_err = AXUIElementPerformAction(item, kAXPressAction);
            if (click_err != kAXErrorSuccess) {
              click_err = AXUIElementPerformAction(item, kAXShowMenuAction);
            }
            
            found = 1;
            CFRelease(children);
            CFRelease(extras);
            CFRelease(app);
            CFRelease(apps);
            return 1;
          }
        }
        
        CFRelease(children);
      }
      
      CFRelease(extras);
    }
    
    CFRelease(app);
  }
  
  CFRelease(apps);
  
  if (verbose) fprintf(stderr, "[DEBUG] No match found\n");
  return found;
}

// List items for PID
void list_items_for_pid(pid_t pid) {
  AXUIElementRef app = AXUIElementCreateApplication(pid);
  if (!app) {
    fprintf(stderr, "Error: Could not create AX element for PID %d\n", pid);
    return;
  }

  AXUIElementRef extra_menus_ref = NULL;
  CFArrayRef children_ref = NULL;

  AXError error = AXUIElementCopyAttributeValue(app, kAXExtrasMenuBarAttribute, (CFTypeRef*)&extra_menus_ref);
  
  if (error != kAXErrorSuccess) {
    printf("Process %d has no menu bar extras\n", pid);
    CFRelease(app);
    return;
  }

  error = AXUIElementCopyAttributeValue(extra_menus_ref, kAXVisibleChildrenAttribute, (CFTypeRef*)&children_ref);

  if (error == kAXErrorSuccess) {
    uint32_t count = CFArrayGetCount(children_ref);
    printf("Process %d has %d menu bar extra(s):\n", pid, count);
    
    for (uint32_t i = 0; i < count; i++) {
      AXUIElementRef item = CFArrayGetValueAtIndex(children_ref, i);
      
      CFTypeRef desc = NULL;
      AXUIElementCopyAttributeValue(item, kAXDescriptionAttribute, &desc);
      
      CFTypeRef title = NULL;
      AXUIElementCopyAttributeValue(item, kAXTitleAttribute, &title);
      
      printf("  [%d] ", i);
      
      if (desc) {
        char buffer[256];
        CFStringGetCString(desc, buffer, sizeof(buffer), kCFStringEncodingUTF8);
        printf("Description: %s", buffer);
        CFRelease(desc);
      }
      
      if (title) {
        char buffer[256];
        CFStringGetCString(title, buffer, sizeof(buffer), kCFStringEncodingUTF8);
        printf("%sTitle: %s", desc ? ", " : "", buffer);
        CFRelease(title);
      }
      
      if (!desc && !title) {
        printf("(no description)");
      }
      
      printf("\n");
    }
    
    CFRelease(children_ref);
  }

  CFRelease(extra_menus_ref);
  CFRelease(app);
}

// List all processes with menu bar extras
void list_all_menu_extras() {
  printf("Scanning for processes with menu bar extras...\n");
  printf("=============================================\n\n");
  
  CFArrayRef apps = CGWindowListCopyWindowInfo(kCGWindowListOptionAll, kCGNullWindowID);
  pid_t checked_pids[1000];
  int checked_count = 0;
  int found_count = 0;
  
  for (int i = 0; i < CFArrayGetCount(apps); i++) {
    CFDictionaryRef window = CFArrayGetValueAtIndex(apps, i);
    CFNumberRef pid_ref = CFDictionaryGetValue(window, kCGWindowOwnerPID);
    if (!pid_ref) continue;
    
    pid_t pid;
    CFNumberGetValue(pid_ref, kCFNumberIntType, &pid);
    
    int already_checked = 0;
    for (int j = 0; j < checked_count; j++) {
      if (checked_pids[j] == pid) {
        already_checked = 1;
        break;
      }
    }
    if (already_checked || checked_count >= 1000) continue;
    checked_pids[checked_count++] = pid;
    
    AXUIElementRef app = AXUIElementCreateApplication(pid);
    if (!app) continue;
    
    AXUIElementRef extras = NULL;
    AXError error = AXUIElementCopyAttributeValue(app, kAXExtrasMenuBarAttribute, (CFTypeRef*)&extras);
    
    if (error == kAXErrorSuccess && extras) {
      CFArrayRef children = NULL;
      error = AXUIElementCopyAttributeValue(extras, kAXVisibleChildrenAttribute, (CFTypeRef*)&children);
      
      if (error == kAXErrorSuccess && children) {
        uint32_t count = CFArrayGetCount(children);
        if (count > 0) {
          char* proc_name = get_process_name(pid);
          printf("PID: %-6d  Name: %-30s  Items: %d\n", pid, proc_name, count);
          found_count++;
        }
        CFRelease(children);
      }
      CFRelease(extras);
    }
    CFRelease(app);
  }
  
  CFRelease(apps);
  printf("\nFound %d process(es) with menu bar extras\n", found_count);
}

// Click menu bar extra by PID
void click_menu_extra(pid_t pid, int index, int verbose) {
  if (verbose) fprintf(stderr, "[DEBUG] Attempting to click PID %d, index %d\n", pid, index);
  
  AXUIElementRef item = ax_get_extra_menu_item(pid, index, verbose);
  if (!item) {
    fprintf(stderr, "Error: Could not find menu bar extra for PID %d\n", pid);
    return;
  }
  
  AXError err = AXUIElementPerformAction(item, kAXPressAction);
  if (err != kAXErrorSuccess) {
    err = AXUIElementPerformAction(item, kAXShowMenuAction);
  }
  
  CFRelease(item);
}

int main(int argc, char **argv) {
  if (argc < 2) {
    printf("submenu - Menu Bar Extras Control\n");
    printf("==================================\n\n");
    printf("Usage:\n");
    printf("  %s -l              List all processes with menu bar extras\n", argv[0]);
    printf("  %s -p <PID>        List menu bar items for a specific PID\n", argv[0]);
    printf("  %s -c <PID|alias>  Click menu bar extra by PID or alias\n", argv[0]);
    printf("  %s -c <PID> [idx]  Click specific index when using PID\n", argv[0]);
    printf("  %s -v -c <target>  Click with verbose debug output\n", argv[0]);
    printf("\n");
    printf("Examples:\n");
    printf("  %s -l                                   # List all\n", argv[0]);
    printf("  %s -p 1234                              # List items for PID 1234\n", argv[0]);
    printf("  %s -c 1234                              # Click first item of PID 1234\n", argv[0]);
    printf("  %s -c 1234 2                            # Click third item (index 2)\n", argv[0]);
    printf("  %s -c \"Control Center,Battery\"          # Click by alias\n", argv[0]);
    printf("  %s -v -c \"Control Center,CPU_mini\"      # Click alias with debug\n", argv[0]);
    exit(0);
  }

  ax_init();

  // List all
  if (strcmp(argv[1], "-l") == 0 && argc == 2) {
    list_all_menu_extras();
  }
  // List items for PID
  else if (strcmp(argv[1], "-p") == 0 && argc >= 3) {
    pid_t pid = atoi(argv[2]);
    if (pid <= 0) {
      fprintf(stderr, "Error: Invalid PID\n");
      exit(1);
    }
    list_items_for_pid(pid);
  }
  // Click with verbose: -v -c <target> [index]
  else if (strcmp(argv[1], "-v") == 0 && strcmp(argv[2], "-c") == 0 && argc >= 4) {
    const char *target = argv[3];
    
    if (is_pid(target)) {
      pid_t pid = atoi(target);
      int index = (argc >= 5) ? atoi(argv[4]) : 0;
      click_menu_extra(pid, index, 1);
    } else {
      if (!click_by_alias(target, 1)) {
        exit(1);
      }
    }
  }
  // Click with verbose: -c -v <target> [index]
  else if (strcmp(argv[1], "-c") == 0 && strcmp(argv[2], "-v") == 0 && argc >= 4) {
    const char *target = argv[3];
    
    if (is_pid(target)) {
      pid_t pid = atoi(target);
      int index = (argc >= 5) ? atoi(argv[4]) : 0;
      click_menu_extra(pid, index, 1);
    } else {
      if (!click_by_alias(target, 1)) {
        exit(1);
      }
    }
  }
  // Click (non-verbose): -c <target> [index]
  else if (strcmp(argv[1], "-c") == 0 && argc >= 3) {
    const char *target = argv[2];
    
    if (is_pid(target)) {
      pid_t pid = atoi(target);
      int index = (argc >= 4) ? atoi(argv[3]) : 0;
      click_menu_extra(pid, index, 0);
    } else {
      if (!click_by_alias(target, 0)) {
        exit(1);
      }
    }
  }
  else {
    fprintf(stderr, "Error: Invalid arguments. Use without args for help.\n");
    exit(1);
  }

  return 0;
}
