#import "MetalBridge.h"

@implementation MetalBridge

- (instancetype)initWithView:(MTKView *)view {
    self = [super init];
    if (self) {
        _metalView = view;
        _device = MTLCreateSystemDefaultDevice();
        _metalView.device = _device;
        _metalView.colorPixelFormat = MTLPixelFormatBGRA8Unorm_sRGB;
        _metalView.depthStencilPixelFormat = MTLPixelFormatDepth32Float;
        _metalView.clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 1.0);
        _commandQueue = [_device newCommandQueue];
    }
    return self;
}

- (void)render {
    @autoreleasepool {
        id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
        MTLRenderPassDescriptor *passDescriptor = self.metalView.currentRenderPassDescriptor;
        if (passDescriptor) {
            id<MTLRenderCommandEncoder> encoder = [commandBuffer renderCommandEncoderWithDescriptor:passDescriptor];
            [encoder endEncoding];
            [commandBuffer presentDrawable:self.metalView.currentDrawable];
        }
        [commandBuffer commit];
    }
}

@end
