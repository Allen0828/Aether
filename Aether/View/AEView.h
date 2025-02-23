//
//  AEView.h
//  Aether
//
//  Created by Allen on 2025/1/1.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/CAMetalLayer.h>

typedef enum : NSUInteger {
    Disabled,
    X2,         // def
    X4,
    // It is recommended to use it on Mac devices
    X8,
    X16     
} EMSAAQuality;

@interface AEView : NSObject

- (instancetype)initWithLayer:(CAMetalLayer *)layer;

- (CAMetalLayer*)getLayer;

- (void)setOffscreenMsaaType:(EMSAAQuality)msaaType;

- (void)render;

@end


