#ifdef __OBJC__
#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// Bridge NSView (macOS) to UIView on iOS.
// PCSX2 Metal code uses NSView* for the Metal layer host view.
// On iOS, this is UIView* (same root class hierarchy in ObjC runtime).
// Both inherit from UIResponder, and the usage is limited to
// storing a pointer and passing to/from CAMetalLayer APIs.
#define NSView UIView
#endif
#endif
