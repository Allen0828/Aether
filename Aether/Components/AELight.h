//
//  AELight.h
//  Aether-swift
//
//  Created by Allen on 2025/4/14.
//

#import "AEComponent.h"

typedef enum {
    DirectionalLight = 0,
    PointLight,
    SpotLight,
    SizeLight
} ELigheType;

typedef struct {
    float r;
    float g;
    float b;
} LightColor;

@interface AELight : AEComponent

@property (nonatomic,assign) ELigheType lightType;
@property (nonatomic,assign) LightColor diffuse;
@property (nonatomic,assign) LightColor specular;
@property (nonatomic,assign) CGFloat specularScale;


@end


