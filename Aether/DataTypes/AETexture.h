//
//  AEElement.h
//  Aether
//
//  Created by Allen on 2024/12/30.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>


@interface AETexture : NSObject

@property (nonatomic, strong) id<MTLTexture> texture;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) MTLPixelFormat pixelFormat;

- (instancetype)initWithDevice:(id<MTLDevice>)device
                       image:(NSString *)path;

@end
