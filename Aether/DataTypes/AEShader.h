//
//  AEElement.h
//  Aether
//
//  Created by Allen on 2024/12/30.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

@interface AEShader : NSObject

@property (nonatomic, strong) id<MTLFunction> vertexFunction;
@property (nonatomic, strong) id<MTLFunction> fragmentFunction;

- (instancetype)initWithDevice:(id<MTLDevice>)device
                  vertexShader:(NSString *)vertexShader
                 fragmentShader:(NSString *)fragmentShader;

@end

