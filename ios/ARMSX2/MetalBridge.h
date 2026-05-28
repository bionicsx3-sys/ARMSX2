#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

@interface MetalBridge : NSObject
@property (nonatomic, strong) MTKView *metalView;
@property (nonatomic, strong) id<MTLDevice> device;
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;

- (instancetype)initWithView:(MTKView *)view;
- (void)render;
@end
