cmake_minimum_required(VERSION 3.25)

project(ARMSX2 LANGUAGES C CXX OBJC OBJCXX Swift)

#----------------------------------------------------------------------
# iOS Configuration
#----------------------------------------------------------------------
set(CMAKE_SYSTEM_NAME iOS)
set(CMAKE_OSX_DEPLOYMENT_TARGET 16.0 CACHE STRING "Minimum iOS version")
set(CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "16.0")
set(CMAKE_XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1,2")
set(CMAKE_XCODE_ATTRIBUTE_ENABLE_BITCODE NO)
set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_ALLOWED NO)
set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "")
set(CMAKE_XCODE_ATTRIBUTE_SWIFT_VERSION "5.0")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_MACOSX_BUNDLE YES)

add_definitions(-DIOS -D__IOS__ -D_M_ARM64=1 -D__ARM_ARCH_8A__ -DARM64 -D__POSIX__)
add_compile_options(-fobjc-arc -fvisibility=hidden -pthread)
add_compile_options($<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions>)
add_compile_options(-ffp-contract=fast -fno-strict-aliasing)

#----------------------------------------------------------------------
# Paths
#----------------------------------------------------------------------
set(PCSX2_CPP_DIR "${CMAKE_CURRENT_SOURCE_DIR}/cpp")
set(PCSX2_SRC_DIR "${PCSX2_CPP_DIR}/pcsx2")
set(CMAKE_MODULE_PATH "${PCSX2_CPP_DIR}/cmake")

#----------------------------------------------------------------------
# Helper: disable warnings on a target
#----------------------------------------------------------------------
function(disable_compiler_warnings_for_target target)
    target_compile_options(${target} PRIVATE "-w")
endfunction()

#----------------------------------------------------------------------
# Third-party dependencies
#----------------------------------------------------------------------
# Common helpers
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/fast_float" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/fast_float" EXCLUDE_FROM_ALL)
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/fmt" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/fmt" EXCLUDE_FROM_ALL)
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/rapidyaml" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/rapidyaml" EXCLUDE_FROM_ALL)
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/lzma" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/lzma" EXCLUDE_FROM_ALL)
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/libchdr" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/libchdr" EXCLUDE_FROM_ALL)
disable_compiler_warnings_for_target(libchdr)
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/soundtouch" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/soundtouch" EXCLUDE_FROM_ALL)
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/simpleini" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/simpleini" EXCLUDE_FROM_ALL)
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/imgui" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/imgui" EXCLUDE_FROM_ALL)
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/cpuinfo" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/cpuinfo" EXCLUDE_FROM_ALL)
disable_compiler_warnings_for_target(cpuinfo)
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/libzip" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/libzip" EXCLUDE_FROM_ALL)
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/rcheevos" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/rcheevos" EXCLUDE_FROM_ALL)
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/rapidjson" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/rapidjson" EXCLUDE_FROM_ALL)
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/freesurround" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/freesurround" EXCLUDE_FROM_ALL)
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/cubeb" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/cubeb" EXCLUDE_FROM_ALL)
disable_compiler_warnings_for_target(cubeb)
disable_compiler_warnings_for_target(speex)

# ARM64-specific
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/vixl" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/vixl" EXCLUDE_FROM_ALL)
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/demangler" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/demangler" EXCLUDE_FROM_ALL)
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/ccc" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/ccc" EXCLUDE_FROM_ALL)

# SDL3 for input/audio
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/SDL3" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/SDL3" EXCLUDE_FROM_ALL)

# glslang (for SPIRV cross)
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/glslang" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/glslang" EXCLUDE_FROM_ALL)

# zlib (ZLIB::ZLIB) - needed by libchdr
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/zlib" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/zlib" EXCLUDE_FROM_ALL)

# zstd (Zstd::Zstd) - needed by libzip
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/zstd" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/zstd" EXCLUDE_FROM_ALL)

# lz4
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/lz4" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/lz4" EXCLUDE_FROM_ALL)

# harfbuzz + freetype - needed by imgui
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/harfbuzz" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/harfbuzz" EXCLUDE_FROM_ALL)
set(FT_DISABLE_HARFBUZZ OFF CACHE BOOL "")
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/freetype" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/freetype" EXCLUDE_FROM_ALL)

# libwebp
set(WEBP_BUILD_ANIM_UTILS OFF CACHE BOOL "")
set(WEBP_BUILD_CWEBP OFF CACHE BOOL "")
set(WEBP_BUILD_DWEBP OFF CACHE BOOL "")
set(WEBP_BUILD_GIF2WEBP OFF CACHE BOOL "")
set(WEBP_BUILD_IMG2WEBP OFF CACHE BOOL "")
set(WEBP_BUILD_VWEBP OFF CACHE BOOL "")
set(WEBP_BUILD_WEBPINFO OFF CACHE BOOL "")
set(WEBP_BUILD_EXTRAS OFF CACHE BOOL "")
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/libwebp" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/libwebp" EXCLUDE_FROM_ALL)

# plutosvg1 - vector SVG rendering, needed by imgui
set(plutovg_BUILD_EXAMPLES OFF CACHE BOOL "")
add_subdirectory("${PCSX2_CPP_DIR}/3rdparty/plutosvg1" "${CMAKE_CURRENT_BINARY_DIR}/3rdparty/plutosvg1" EXCLUDE_FROM_ALL)



# iOS system frameworks
find_library(UIKIT_LIB UIKit)
find_library(METAL_LIB Metal)
find_library(METALKIT_LIB MetalKit)
find_library(COREGRAPHICS_LIB CoreGraphics)
find_library(COREFOUNDATION_LIB CoreFoundation)
find_library(QUARTZCORE_LIB QuartzCore)
find_library(IOKIT_LIB IOKit)
if(NOT IOKIT_LIB)
    set(IOKIT_LIB "")
endif()
find_library(AUDIOTOOLBOX_LIB AudioToolbox)
find_library(AVFAUDIO_LIB AVFAudio)
find_library(GAMECONTROLLER_LIB GameController)
find_library(CFNETWORK_LIB CFNetwork)
find_library(FOUNDATION_LIB Foundation)
find_library(UIFOUNDATION_LIB UIKit)

#----------------------------------------------------------------------
# Common library (PCSX2 utility code)
#----------------------------------------------------------------------
add_library(common STATIC)

target_sources(common PRIVATE
    "${PCSX2_CPP_DIR}/common/AlignedMalloc.cpp"
    "${PCSX2_CPP_DIR}/common/Assertions.cpp"
    "${PCSX2_CPP_DIR}/common/Console.cpp"
    "${PCSX2_CPP_DIR}/common/CrashHandler.cpp"
    "${PCSX2_CPP_DIR}/common/DynamicLibrary.cpp"
    "${PCSX2_CPP_DIR}/common/Error.cpp"
    "${PCSX2_CPP_DIR}/common/FastJmp.cpp"
    "${PCSX2_CPP_DIR}/common/FileSystem.cpp"
    "${PCSX2_CPP_DIR}/common/HostSys.cpp"
    "${PCSX2_CPP_DIR}/common/HTTPDownloader.cpp"
    "${PCSX2_CPP_DIR}/common/MemorySettingsInterface.cpp"
    "${PCSX2_CPP_DIR}/common/MD5Digest.cpp"
    "${PCSX2_CPP_DIR}/common/Perf.cpp"
    "${PCSX2_CPP_DIR}/common/ProgressCallback.cpp"
    "${PCSX2_CPP_DIR}/common/ReadbackSpinManager.cpp"
    "${PCSX2_CPP_DIR}/common/Semaphore.cpp"
    "${PCSX2_CPP_DIR}/common/SettingsWrapper.cpp"
    "${PCSX2_CPP_DIR}/common/SmallString.cpp"
    "${PCSX2_CPP_DIR}/common/StringUtil.cpp"
    "${PCSX2_CPP_DIR}/common/Timer.cpp"
    "${PCSX2_CPP_DIR}/common/WAVWriter.cpp"
    "${PCSX2_CPP_DIR}/common/WindowInfo.cpp"
    "${PCSX2_CPP_DIR}/common/CocoaTools.mm"
)

target_sources(common PRIVATE
    "${PCSX2_CPP_DIR}/common/emitter/x86emitter.cpp"
)

target_include_directories(common PUBLIC
    "${PCSX2_CPP_DIR}/common"
    "${PCSX2_CPP_DIR}"
    "${PCSX2_CPP_DIR}/3rdparty/include"
    "${PCSX2_CPP_DIR}/3rdparty/vixl/include"
    "${CMAKE_CURRENT_BINARY_DIR}/common/include"
)

target_compile_definitions(common PUBLIC _M_ARM64=1 __POSIX__)
target_compile_features(common PUBLIC cxx_std_20)
target_compile_options(common PRIVATE -w)

target_link_libraries(common PUBLIC
    fmt::fmt
    fast_float
    ${FOUNDATION_LIB}
    ${IOKIT_LIB}
)

#----------------------------------------------------------------------
# PCSX2 Core (static library)
#----------------------------------------------------------------------
add_library(PCSX2_FLAGS INTERFACE)

target_compile_features(PCSX2_FLAGS INTERFACE cxx_std_20)
target_compile_definitions(PCSX2_FLAGS INTERFACE
    _M_ARM64=1
    __POSIX__
    PCSX2_CORE=1
    DISABLE_RECORDING
)

target_include_directories(PCSX2_FLAGS INTERFACE
    "${PCSX2_SRC_DIR}"
    "${PCSX2_CPP_DIR}"
    "${PCSX2_CPP_DIR}/common"
    "${PCSX2_CPP_DIR}/3rdparty/include"
    "${PCSX2_CPP_DIR}/3rdparty/vixl/include"
    "${CMAKE_CURRENT_BINARY_DIR}/pcsx2"
    "${CMAKE_CURRENT_BINARY_DIR}/common/include"
    "${PCSX2_CPP_DIR}/3rdparty/SDL3/include"
)

add_library(PCSX2 STATIC)

target_link_libraries(PCSX2 PRIVATE PCSX2_FLAGS)
target_link_libraries(PCSX2_FLAGS INTERFACE
    common
    imgui
    fmt::fmt
    rapidyaml::rapidyaml
    libchdr
    libzip::zip
    cpuinfo
    cubeb
    rcheevos
    simpleini
    freesurround
    SDL3::SDL3
    SoundTouch::SoundTouch
    vixl
    demanglegnu
    ccc
    glslang
    ZLIB::ZLIB
    LZMA::LZMA
    Zstd::Zstd
    LZ4::LZ4
    Freetype::Freetype
    plutosvg::plutosvg
    ${UIKIT_LIB}
    ${METAL_LIB}
    ${METALKIT_LIB}
    ${COREGRAPHICS_LIB}
    ${COREFOUNDATION_LIB}
    ${QUARTZCORE_LIB}
    ${IOKIT_LIB}
    ${AUDIOTOOLBOX_LIB}
    ${AVFAUDIO_LIB}
    ${GAMECONTROLLER_LIB}
    ${CFNETWORK_LIB}
    ${FOUNDATION_LIB}
)

# Collect all PCSX2 sources
set(pcsx2_core_sources
    Achievements.cpp
    BuildVersion.cpp
    Cache.cpp
    COP0.cpp COP2.cpp
    Counters.cpp Dmac.cpp
    GameDatabase.cpp Elfheader.cpp FW.cpp FiFo.cpp FPU.cpp
    GameList.cpp Gif.cpp Gif_Logger.cpp Gif_Unit.cpp
    GS.cpp GSDumpReplayer.cpp Host.cpp Hw.cpp HwRead.cpp HwWrite.cpp
    LayeredSettingsInterface.cpp INISettingsInterface.cpp Interpreter.cpp
    IopBios.cpp IopCounters.cpp IopDma.cpp IopGte.cpp IopHw.cpp
    IopIrq.cpp IopMem.cpp PINE.cpp Mdec.cpp Memory.cpp MMI.cpp
    MTGS.cpp MTVU.cpp Patch.cpp Pcsx2Config.cpp PerformanceMetrics.cpp
    PrecompiledHeader.cpp R3000A.cpp R3000AInterpreter.cpp R3000AOpcodeTables.cpp
    R5900.cpp R5900OpcodeImpl.cpp R5900OpcodeTables.cpp
    ShiftJisToUnicode.cpp Sif.cpp Sif0.cpp Sif1.cpp sif2.cpp
    SourceLog.cpp SPR.cpp StateWrapper.cpp
    Vif0_Dma.cpp Vif1_Dma.cpp Vif1_MFIFO.cpp Vif.cpp
    Vif_Codes.cpp Vif_Transfer.cpp Vif_Unpack.cpp
    VMManager.cpp vtlb.cpp
    VU0.cpp VUmicro.cpp VU0micro.cpp VU0microInterp.cpp
    VU1micro.cpp VU1microInterp.cpp VUflags.cpp VUmicroMem.cpp VUops.cpp
)

set(pcsx2_cdvd_sources
    CDVD/BlockdumpFileReader.cpp CDVD/Ps1CD.cpp CDVD/CDVDcommon.cpp CDVD/CDVD.cpp
    CDVD/CDVDdiscReader.cpp CDVD/CDVDisoReader.cpp CDVD/CDVDdiscThread.cpp
    CDVD/FlatFileReader.cpp CDVD/InputIsoFile.cpp CDVD/IsoHasher.cpp CDVD/IsoReader.cpp
    CDVD/OutputIsoFile.cpp CDVD/ChdFileReader.cpp CDVD/CsoFileReader.cpp
    CDVD/GzippedFileReader.cpp CDVD/ThreadedFileReader.cpp
)

set(pcsx2_spu2_sources
    SPU2/ADSR.cpp SPU2/Debug.cpp SPU2/Dma.cpp SPU2/Mixer.cpp
    SPU2/spu2.cpp SPU2/ReadInput.cpp SPU2/RegTable.cpp
    SPU2/Reverb.cpp SPU2/spu2freeze.cpp SPU2/spu2sys.cpp SPU2/Wavedump_wav.cpp
)

set(pcsx2_gs_sources
    GS/GS.cpp GS/GSCapture.cpp GS/GSClut.cpp GS/GSDrawingContext.cpp
    GS/GSDump.cpp GS/GSLocalMemory.cpp GS/GSLzma.cpp GS/GSPerfMon.cpp
    GS/GSRingHeap.cpp GS/GSState.cpp GS/GSTables.cpp
    GS/GSUtil.cpp GS/GSVector.cpp GS/MultiISA.cpp
    GS/Renderers/Common/GSDevice.cpp GS/Renderers/Common/GSDirtyRect.cpp
    GS/Renderers/Common/GSFunctionMap.cpp GS/Renderers/Common/GSGPUProfile.cpp
    GS/Renderers/Common/GSRenderer.cpp GS/Renderers/Common/GSTexture.cpp
    GS/Renderers/Common/GSVertexTrace.cpp
    GS/Renderers/Null/GSRendererNull.cpp
    GS/Renderers/HW/GSHwHack.cpp GS/Renderers/HW/GSRendererHW.cpp
    GS/Renderers/HW/GSTextureCache.cpp
    GS/Renderers/HW/GSTextureReplacements.cpp
    GS/Renderers/SW/GSTextureCacheSW.cpp
    GS/Renderers/SW/GSDrawScanline.cpp GS/Renderers/SW/GSRasterizer.cpp GS/Renderers/SW/GSRendererSW.cpp
    GS/Renderers/SW/GSDrawScanlineCodeGenerator.arm64.cpp
    GS/Renderers/SW/GSSetupPrimCodeGenerator.arm64.cpp
)

set(pcsx2_gs_metal_sources
    GS/Renderers/Metal/GSDeviceMTL.mm
    GS/Renderers/Metal/GSMTLDeviceInfo.mm
    GS/Renderers/Metal/GSTextureMTL.mm
)

set(pcsx2_metal_shaders
    GS/Renderers/Metal/cas.metal
    GS/Renderers/Metal/convert.metal
    GS/Renderers/Metal/present.metal
    GS/Renderers/Metal/merge.metal
    GS/Renderers/Metal/misc.metal
    GS/Renderers/Metal/interlace.metal
    GS/Renderers/Metal/tfx.metal
    GS/Renderers/Metal/fxaa.metal
)

set(pcsx2_dev9_sources
    DEV9/AdapterUtils.cpp
    DEV9/ATA/Commands/ATA_Command.cpp DEV9/ATA/Commands/ATA_CmdDMA.cpp
    DEV9/ATA/Commands/ATA_CmdExecuteDeviceDiag.cpp DEV9/ATA/Commands/ATA_CmdNoData.cpp
    DEV9/ATA/Commands/ATA_CmdPIOData.cpp DEV9/ATA/Commands/ATA_CmdSMART.cpp
    DEV9/ATA/Commands/ATA_SCE.cpp DEV9/ATA/ATA_Info.cpp DEV9/ATA/ATA_State.cpp
    DEV9/ATA/ATA_Transfer.cpp DEV9/ATA/HddCreate.cpp
    DEV9/InternalServers/DHCP_Logger.cpp DEV9/InternalServers/DHCP_Server.cpp
    DEV9/InternalServers/DNS_Logger.cpp DEV9/InternalServers/DNS_Server.cpp
    DEV9/PacketReader/ARP/ARP_Packet.cpp DEV9/PacketReader/ARP/ARP_PacketEditor.cpp
    DEV9/PacketReader/IP/ICMP/ICMP_Packet.cpp
    DEV9/PacketReader/IP/TCP/TCP_Options.cpp DEV9/PacketReader/IP/TCP/TCP_Packet.cpp
    DEV9/PacketReader/IP/UDP/DHCP/DHCP_Options.cpp DEV9/PacketReader/IP/UDP/DHCP/DHCP_Packet.cpp
    DEV9/PacketReader/IP/UDP/DNS/DNS_Classes.cpp DEV9/PacketReader/IP/UDP/DNS/DNS_Packet.cpp
    DEV9/PacketReader/IP/UDP/UDP_Packet.cpp
    DEV9/PacketReader/IP/IP_Options.cpp DEV9/PacketReader/IP/IP_Packet.cpp
    DEV9/PacketReader/EthernetFrame.cpp DEV9/PacketReader/EthernetFrameEditor.cpp
    DEV9/Sessions/BaseSession.cpp
    DEV9/Sessions/ICMP_Session/ICMP_Session.cpp
    DEV9/Sessions/TCP_Session/TCP_Session.cpp DEV9/Sessions/TCP_Session/TCP_Session_In.cpp DEV9/Sessions/TCP_Session/TCP_Session_Out.cpp
    DEV9/Sessions/UDP_Session/UDP_Common.cpp DEV9/Sessions/UDP_Session/UDP_FixedPort.cpp DEV9/Sessions/UDP_Session/UDP_Session.cpp
    DEV9/smap.cpp DEV9/sockets.cpp DEV9/DEV9.cpp DEV9/flash.cpp DEV9/pcap_io.cpp DEV9/net.cpp
)

set(pcsx2_usb_sources
    USB/USB.cpp USB/deviceproxy.cpp
    USB/qemu-usb/bus.cpp USB/qemu-usb/core.cpp USB/qemu-usb/desc.cpp
    USB/qemu-usb/hid.cpp USB/qemu-usb/input-keymap-qcode-to-qnum.cpp USB/qemu-usb/usb-ohci.cpp
    USB/shared/ringbuffer.cpp
    USB/usb-eyetoy/jo_mpeg.cpp USB/usb-eyetoy/usb-eyetoy-webcam.cpp
    USB/usb-hid/usb-hid.cpp USB/usb-lightgun/guncon2.cpp
    USB/usb-mic/audiodev-cubeb.cpp USB/usb-mic/usb-headset.cpp USB/usb-mic/usb-mic.cpp
    USB/usb-msd/usb-msd.cpp
    USB/usb-pad/lg/lg_ff.cpp USB/usb-pad/usb-buzz.cpp USB/usb-pad/usb-gametrak.cpp
    USB/usb-pad/usb-realplay.cpp USB/usb-pad/usb-pad-ff.cpp USB/usb-pad/usb-pad-sdl-ff.cpp
    USB/usb-pad/usb-pad.cpp USB/usb-pad/usb-seamic.cpp USB/usb-pad/usb-train.cpp
    USB/usb-pad/usb-trance-vibrator.cpp USB/usb-pad/usb-turntable.cpp
    USB/usb-printer/usb-printer.cpp
    USB/usb-eyetoy/cam-noop.cpp
)

set(pcsx2_pad_sources
    SIO/Pad/Pad.cpp SIO/Pad/PadBase.cpp SIO/Pad/PadDualshock2.cpp
    SIO/Pad/PadGuitar.cpp SIO/Pad/PadJogcon.cpp SIO/Pad/PadNegcon.cpp
    SIO/Pad/PadPopn.cpp SIO/Pad/PadNotConnected.cpp
    SIO/Sio.cpp SIO/Sio2.cpp SIO/Sio0.cpp
    SIO/Multitap/MultitapProtocol.cpp
    SIO/Memcard/MemoryCardFile.cpp SIO/Memcard/MemoryCardFolder.cpp SIO/Memcard/MemoryCardProtocol.cpp
)

set(pcsx2_ipu_sources
    IPU/IPU.cpp IPU/IPU_Fifo.cpp IPU/IPUdma.cpp
    IPU/IPU_MultiISA.cpp IPU/IPUdither.cpp IPU/yuv2rgb.cpp
)

set(pcsx2_debug_sources
    DebugTools/DebugInterface.cpp DebugTools/DisassemblyManager.cpp
    DebugTools/ExpressionParser.cpp DebugTools/MIPSAnalyst.cpp
    DebugTools/MipsAssembler.cpp DebugTools/MipsAssemblerTables.cpp
    DebugTools/MipsStackWalk.cpp DebugTools/Breakpoints.cpp
    DebugTools/SymbolGuardian.cpp DebugTools/SymbolImporter.cpp
    DebugTools/DisR3000A.cpp DebugTools/DisR5900asm.cpp
    DebugTools/DisVU0Micro.cpp DebugTools/DisVU1Micro.cpp
    DebugTools/BiosDebugData.cpp
)

set(pcsx2_host_sources
    Host/AudioStream.cpp Host/CubebAudioStream.cpp Host/SDLAudioStream.cpp
)

set(pcsx2_imgui_sources
    ImGui/FullscreenUI.cpp ImGui/ImGuiFullscreen.cpp
    ImGui/ImGuiManager.cpp ImGui/ImGuiOverlays.cpp
)

set(pcsx2_input_sources
    Input/InputManager.cpp Input/InputSource.cpp Input/SDLInputSource.cpp
)

set(pcsx2_ps2_sources
    ps2/BiosTools.cpp ps2/pgif.cpp
    ps2/Iop/IopHwRead.cpp ps2/Iop/IopHwWrite.cpp ps2/Iop/PsxBios.cpp
)

set(pcsx2_arm64_sources
    arm64/Vif_Dynarec.cpp arm64/Vif_UnpackNEON.cpp arm64/VixlHelpers.cpp
)

set(pcsx2_recording_sources
    Recording/InputRecording.cpp Recording/InputRecordingControls.cpp
    Recording/InputRecordingFile.cpp Recording/PadData.cpp
    Recording/Utilities/InputRecordingLogger.cpp
)

set(pcsx2_osx_sources
    # CDVD/Darwin/DriveUtility.cpp CDVD/Darwin/IOCtlSrc.cpp (IOKit is macOS only; iOS has no optical drives)
)

# Add all sources to PCSX2 target
foreach(src ${pcsx2_core_sources} ${pcsx2_cdvd_sources} ${pcsx2_spu2_sources}
           ${pcsx2_gs_sources} ${pcsx2_gs_metal_sources}
           ${pcsx2_dev9_sources} ${pcsx2_usb_sources} ${pcsx2_pad_sources}
           ${pcsx2_ipu_sources} ${pcsx2_debug_sources} ${pcsx2_host_sources}
           ${pcsx2_imgui_sources} ${pcsx2_input_sources} ${pcsx2_ps2_sources}
           ${pcsx2_arm64_sources} ${pcsx2_recording_sources} ${pcsx2_osx_sources})
    target_sources(PCSX2 PRIVATE "${PCSX2_SRC_DIR}/${src}")
endforeach()

# Metal shaders as source files (Xcode handles compilation)
foreach(src ${pcsx2_metal_shaders})
    target_sources(PCSX2 PRIVATE "${PCSX2_SRC_DIR}/${src}")
    set_source_files_properties("${PCSX2_SRC_DIR}/${src}" PROPERTIES
        LANGUAGE METAL
        XCODE_EXPLICIT_FILE_TYPE sourcecode.metal
    )
endforeach()

# Fixup: skip PCH for Objective-C++ files
foreach(src ${pcsx2_gs_metal_sources})
    set_source_files_properties("${PCSX2_SRC_DIR}/${src}" PROPERTIES SKIP_PRECOMPILE_HEADERS ON)
endforeach()

set_source_files_properties("${PCSX2_CPP_DIR}/common/CocoaTools.mm" PROPERTIES SKIP_PRECOMPILE_HEADERS ON)

# Create svnrev.h for version info
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/common/include/svnrev.h"
    "#define GIT_TAG \"ios-dev\"\n"
    "#define GIT_TAGGED_COMMIT 0\n"
    "#define GIT_TAG_HI 0\n"
    "#define GIT_TAG_MID 0\n"
    "#define GIT_TAG_LO 0\n"
    "#define GIT_REV \"ios-dev\"\n"
    "#define GIT_HASH \"0000000\"\n"
    "#define GIT_DATE \"unknown\"\n"
)

#----------------------------------------------------------------------
# iOS App Target
#----------------------------------------------------------------------
add_executable(ARMSX2
    ARMSX2/ARMSX2App.swift
    ARMSX2/ContentView.swift
    ARMSX2/MetalBridge.h
    ARMSX2/MetalBridge.m
)

target_sources(ARMSX2 PRIVATE
    ARMSX2/Host_iOS.mm
)

target_include_directories(ARMSX2 PRIVATE ARMSX2)
target_link_libraries(ARMSX2 PRIVATE PCSX2 ${METAL_LIB} ${METALKIT_LIB} ${UIKIT_LIB})

set_target_properties(ARMSX2 PROPERTIES
    MACOSX_BUNDLE TRUE
    MACOSX_BUNDLE_GUI_IDENTIFIER "com.armsx2.emulator"
    MACOSX_BUNDLE_BUNDLE_VERSION "1.0"
    MACOSX_BUNDLE_SHORT_VERSION_STRING "1.0"
    MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/ARMSX2/Info.plist"
    XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1,2"
    XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "16.0"
    XCODE_ATTRIBUTE_ENABLE_BITCODE "NO"
    XCODE_ATTRIBUTE_CODE_SIGNING_ALLOWED "NO"
    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY ""
    XCODE_ATTRIBUTE_SWIFT_VERSION "5.0"
    XCODE_ATTRIBUTE_ASSETCATALOG_COMPILER_APPICON_NAME "AppIcon"
    XCODE_ATTRIBUTE_GENERATE_INFOPLIST_FILE "NO"
    XCODE_ATTRIBUTE_INFOPLIST_FILE "ARMSX2/Info.plist"
    XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "com.armsx2.emulator"
    XCODE_ATTRIBUTE_DEVELOPMENT_ASSET_PATHS ""
    XCODE_ATTRIBUTE_ENABLE_PREVIEWS "NO"
)

# Resource copying - assets into bundle
file(GLOB_RECURSE ASSETS "${CMAKE_CURRENT_SOURCE_DIR}/../app/src/main/assets/resources/*")
foreach(asset ${ASSETS})
    file(RELATIVE_PATH rel_path "${CMAKE_CURRENT_SOURCE_DIR}/../app/src/main/assets/resources" "${asset}")
    get_filename_component(subdir "${rel_path}" DIRECTORY)
    set_source_files_properties("${asset}" PROPERTIES
        MACOSX_PACKAGE_LOCATION "Resources/${subdir}"
    )
    target_sources(ARMSX2 PRIVATE "${asset}")
endforeach()

message(STATUS "=== ARMSX2 iOS Build Configuration ===")
message(STATUS "PCSX2 source: ${PCSX2_SRC_DIR}")
message(STATUS "Metal shaders included: ${pcsx2_metal_shaders}")
message(STATUS "Swift app: ARMSX2App.swift")
message(STATUS "Assets: ${ASSETS}")
