#import <UIKit/UIKit.h>

/// Set the Metal view for rendering.
void HostSetMetalView(UIView* view, CGFloat width, CGFloat height, CGFloat scale);

/// Get the current view scale factor.
CGFloat HostGetViewScale(void);
