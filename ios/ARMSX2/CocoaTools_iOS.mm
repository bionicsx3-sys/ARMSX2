#if ! __has_feature(objc_arc)
    #error "Compile this with -fobjc-arc"
#endif

#include "common/CocoaTools.h"
#include "common/Console.h"
#include "common/WindowInfo.h"
#include <UIKit/UIKit.h>
#include <QuartzCore/QuartzCore.h>

bool CocoaTools::CreateMetalLayer(WindowInfo* wi)
{
    CAMetalLayer* layer = [CAMetalLayer layer];
    if (!layer)
    {
        Console.Error("Failed to create Metal layer.");
        return false;
    }

    UIView* view = (__bridge UIView*)wi->window_handle;
    [view setWantsLayer:YES];
    [view setLayer:layer];
    [layer setContentsScale:[[UIScreen mainScreen] scale]];
    wi->surface_handle = (__bridge_retained void*)layer;
    return true;
}

void CocoaTools::DestroyMetalLayer(WindowInfo* wi)
{
    UIView* view = (__bridge UIView*)wi->window_handle;
    CAMetalLayer* layer = (__bridge_transfer CAMetalLayer*)wi->surface_handle;
    if (!layer)
        return;
    wi->surface_handle = nullptr;
    [view setLayer:nil];
    [view setWantsLayer:NO];
}

std::optional<float> CocoaTools::GetViewRefreshRate(const WindowInfo& wi)
{
    if (UIScreen* screen = [UIScreen mainScreen])
        return [screen maximumFramesPerSecond];
    return std::nullopt;
}

std::optional<std::string> CocoaTools::GetBundlePath()
{
    return std::string([[[NSBundle mainBundle] bundlePath] UTF8String]);
}

std::optional<std::string> CocoaTools::GetNonTranslocatedBundlePath()
{
    return GetBundlePath();
}

std::optional<std::string> CocoaTools::MoveToTrash(std::string_view file)
{
    return std::nullopt;
}

bool CocoaTools::DelayedLaunch(std::string_view file)
{
    return false;
}

bool CocoaTools::ShowInFinder(std::string_view file)
{
    return false;
}

std::optional<std::string> CocoaTools::GetResourcePath()
{
    if (NSBundle* bundle = [NSBundle mainBundle])
    {
        NSString* rsrc = [bundle resourcePath];
        NSString* root = [bundle bundlePath];
        if ([rsrc isEqualToString:root])
            rsrc = [rsrc stringByAppendingString:@"/resources"];
        return [rsrc UTF8String];
    }
    return std::nullopt;
}

void* CocoaTools::CreateWindow(std::string_view title, u32 width, u32 height)
{
    return nullptr;
}

void CocoaTools::DestroyWindow(void* window)
{
}

void CocoaTools::GetWindowInfoFromWindow(WindowInfo* wi, void* cf_window)
{
    if (cf_window)
    {
        UIView* view = (__bridge UIView*)cf_window;
        CGFloat scale = [[UIScreen mainScreen] scale];
        CGRect dims = [view frame];
        wi->type = WindowInfo::Type::MacOS;
        wi->window_handle = (__bridge void*)view;
        wi->surface_width = dims.size.width * scale;
        wi->surface_height = dims.size.height * scale;
        wi->surface_scale = scale;
    }
    else
    {
        wi->type = WindowInfo::Type::Surfaceless;
    }
}

void CocoaTools::RunCocoaEventLoop(bool forever)
{
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, forever ? 60.0 : 0.0, false);
}

void CocoaTools::StopMainThreadEventLoop()
{
    CFRunLoopStop(CFRunLoopGetMain());
}

void CocoaTools::AddThemeChangeHandler(void* ctx, void(handler)(void* ctx))
{
}

void CocoaTools::RemoveThemeChangeHandler(void* ctx)
{
}

void CocoaTools::MarkHelpMenu(void* menu)
{
}

bool Common::PlaySoundAsync(const char* path)
{
    return false;
}
