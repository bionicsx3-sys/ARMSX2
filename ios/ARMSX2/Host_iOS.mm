#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Host_iOS.h"
#include <mutex>
#include <thread>
#include <functional>
#include <optional>
#include "Host.h"
#include "VMManager.h"
#include "MTGS.h"
#include "GS.h"
#include "Config.h"
#include "common/WindowInfo.h"
#include "common/Console.h"
#include "common/FileSystem.h"
#include "common/StringUtil.h"
#include "common/Path.h"
#include "INISettingsInterface.h"

static INISettingsInterface* s_settings_interface = nullptr;

static UIView* g_view = nil;
static CGFloat g_view_width = 320;
static CGFloat g_view_height = 480;
static CGFloat g_view_scale = 2.0f;

void HostSetMetalView(UIView* view, CGFloat width, CGFloat height, CGFloat scale) {
    g_view = view;
    g_view_width = width;
    g_view_height = height;
    g_view_scale = scale;
}

CGFloat HostGetViewScale(void) {
    return g_view_scale;
}

std::optional<WindowInfo> Host::AcquireRenderWindow(bool recreate_window) {
    WindowInfo wi;
    wi.type = WindowInfo::Type::MacOS;
    wi.surface_width = static_cast<u32>(g_view_width);
    wi.surface_height = static_cast<u32>(g_view_height);
    wi.surface_scale = static_cast<float>(g_view_scale);
    wi.window_handle = (__bridge void*)g_view;
    return wi;
}

void Host::ReleaseRenderWindow() {}
void Host::BeginPresentFrame() {}
void Host::OnGameChanged(const std::string&, const std::string&, const std::string&,
                         const std::string&, u32, u32) {}
void Host::PumpMessagesOnCPUThread() {}

void Host::CommitBaseSettingChanges() {
    if (s_settings_interface)
        s_settings_interface->Save();
}

void Host::LoadSettings(SettingsInterface& si, std::unique_lock<std::mutex>& lock) {
    if (s_settings_interface)
        s_settings_interface->Save();
    auto ini = std::make_unique<INISettingsInterface>(
        Path::Combine(EmuFolders::DataRoot, "PCSX2-iOS.ini"));
    s_settings_interface = ini.get();
    Host::Internal::SetBaseSettingsLayer(ini.release());
    Host::Internal::GetBaseSettingsLayer()->Load();
    VMManager::Internal::LoadStartupSettings();
}

void Host::CheckForSettingsChanges(const Pcsx2Config&) {}
bool Host::RequestResetSettings(bool, bool, bool, bool, bool) { return true; }
void Host::SetDefaultUISettings(SettingsInterface&) {}

void Host::ReportErrorAsync(const std::string_view title, const std::string_view message) {
    Console::Error("%.*s: %.*s", (int)title.size(), title.data(), (int)message.size(), message.data());
}

bool Host::ConfirmMessage(const std::string_view title, const std::string_view message) {
    Console::Error("%.*s: %.*s", (int)title.size(), title.data(), (int)message.size(), message.data());
    return true;
}

bool Host::ConfirmFormattedMessage(const std::string_view, const char*, ...) { return true; }

void Host::OpenURL(const std::string_view url) {
    NSString* nsurl = [NSString stringWithUTF8String:std::string(url).c_str()];
    if (nsurl)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsurl] options:@{} completionHandler:nil];
}

bool Host::CopyTextToClipboard(const std::string_view text) {
    NSString* nsstr = [NSString stringWithUTF8String:std::string(text).c_str()];
    if (nsstr) { [UIPasteboard generalPasteboard].string = nsstr; return true; }
    return false;
}

void Host::BeginTextInput() {}
void Host::EndTextInput() {}
void Host::OnInputDeviceConnected(const std::string_view, const std::string_view) {}
void Host::OnInputDeviceDisconnected(const InputBindingKey, const std::string_view) {}
void Host::SetMouseMode(bool, bool) {}
void Host::RequestResizeHostDisplay(s32, s32) {}
void Host::OnVMStarting() {}
void Host::OnVMStarted() {}
void Host::OnVMDestroyed() {}
void Host::OnVMPaused() {}
void Host::OnVMResumed() {}
void Host::OnPerformanceMetricsUpdated() {}
void Host::OnSaveStateLoading(const std::string_view) {}
void Host::OnSaveStateLoaded(const std::string_view, bool) {}
void Host::OnSaveStateSaved(const std::string_view) {}

void Host::RunOnCPUThread(std::function<void()> function, bool block) {
    if (block) { function(); }
    else { std::thread t(std::move(function)); t.detach(); }
}

void Host::RefreshGameListAsync(bool) {}
void Host::CancelGameListRefresh() {}
bool Host::IsFullscreen() { return true; }
void Host::SetFullscreen(bool) {}
void Host::OnCaptureStarted(const std::string&) {}
void Host::OnCaptureStopped() {}
void Host::RequestExitApplication(bool) {}
void Host::RequestExitBigPicture() {}
void Host::RequestVMShutdown(bool, bool, bool) {}
void Host::OnAchievementsLoginSuccess(const char*, u32, u32, u32) {}
void Host::OnAchievementsLoginRequested(Achievements::LoginRequestReason) {}
void Host::OnAchievementsHardcoreModeChanged(bool) {}
void Host::OnAchievementsRefreshed() {}
void Host::OnCoverDownloaderOpenRequested() {}
void Host::OnCreateMemoryCardOpenRequested() {}
bool Host::ShouldPreferHostFileSelector() { return true; }

void Host::OpenHostFileSelectorAsync(std::string_view, bool, FileSelectorCallback, void*) {
    Console::Warn("Host file selector not implemented on iOS");
}

s32 Host::Internal::GetTranslatedStringImpl(const char*, const char*, char*, u32) { return 0; }
void Host::ReportInfoAsync(const std::string_view, const std::string_view) {}
bool Host::LocaleCircleConfirm() { return false; }
bool Host::InNoGUIMode() { return false; }
void Host::ClearTranslationCache() {}
