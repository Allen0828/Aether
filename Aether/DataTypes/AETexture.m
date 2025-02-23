//
//  AEElement.m
//  Aether
//
//  Created by Allen on 2024/12/30.
//

#import "AETexture.h"
#import <QuartzCore/QuartzCore.h>
#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#endif
#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
#endif

@implementation AETexture

- (instancetype)initWithDevice:(id<MTLDevice>)device
                       image:(CGImageRef)image {
    self = [super init];
    if (self) {
        self.texture = [self createTextureWithDevice:device image:image];
#if TARGET_OS_OSX

#endif

#if TARGET_OS_IOS

#endif
        self.size = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
        self.pixelFormat = MTLPixelFormatBGRA8Unorm;
        
    }
    return self;
}

- (id<MTLTexture>)createTextureWithDevice:(id<MTLDevice>)device
                                  image:(CGImageRef)image {
    // 获取图像数据
    CGImageRef cgImage = image;
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    size_t bytesPerPixel = 4;
    size_t bytesPerRow = width * bytesPerPixel;
    size_t bitsPerComponent = 8;
    
    // 创建颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *data = malloc(height * bytesPerRow);
    
    // 创建上下文
    CGContextRef context = CGBitmapContextCreate(data, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    // 绘制图像
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    CGContextRelease(context);
    
    // 创建纹理描述符
    MTLTextureDescriptor *textureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatBGRA8Unorm
                                                                                              width:width
                                                                                             height:height
                                                                                          mipmapped:NO];
    id<MTLTexture> texture = [device newTextureWithDescriptor:textureDescriptor];
    
    // 将图像数据复制到纹理
    [texture replaceRegion:MTLRegionMake2D(0, 0, width, height)
                   mipmapLevel:0
                     withBytes:data
                      bytesPerRow:bytesPerRow];
    
    free(data);
    return texture;
}

@end
