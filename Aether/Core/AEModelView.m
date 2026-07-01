//
//  AEModelView.m
//  Aether
//

#import "AEModelView.h"
#import "AEEngine.h"
#import "AECamera.h"
#import "AERenderer.h"
#import "../Model/AEGltfLoader.h"

@interface AEModelView ()
@property (nonatomic, strong, readwrite) AEEngine *engine;
@property (nonatomic, strong, readwrite) AECamera *camera;
@property (nonatomic, strong, nullable, readwrite) AEMesh *model;
@end

@implementation AEModelView

+ (Class)layerClass {
    return [CAMetalLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = UIColor.clearColor;
    self.contentScaleFactor = UIScreen.mainScreen.scale;
    self.framesPerSecond = 60;

    CAMetalLayer *metalLayer = (CAMetalLayer *)self.layer;
    metalLayer.contentsScale = UIScreen.mainScreen.scale;

    self.engine = [[AEEngine alloc] initWithLayer:metalLayer];
    self.camera = [[AECamera alloc] initWithPosition:simd_make_float3(0.9, 0.6, 1.2)
                                             target:simd_make_float3(0, 0, 0)];
    self.engine.renderer.camera = self.camera;

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self addGestureRecognizer:pan];
    [self addGestureRecognizer:pinch];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CAMetalLayer *metalLayer = (CAMetalLayer *)self.layer;
    metalLayer.frame = self.bounds;
    metalLayer.contentsScale = UIScreen.mainScreen.scale;
    metalLayer.drawableSize = CGSizeMake(self.bounds.size.width * metalLayer.contentsScale,
                                         self.bounds.size.height * metalLayer.contentsScale);
    [self.camera updateProjectionWithSize:self.bounds.size];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.window) {
        [self startRenderingWithFPS:self.framesPerSecond];
    } else {
        [self stopRendering];
    }
}

- (BOOL)loadModelNamed:(NSString *)name inBundle:(NSBundle *)bundle error:(NSError *__autoreleasing  _Nullable *)error {
    NSString *path = [bundle pathForResource:name ofType:@"gltf"];
    if (!path) {
        if (error) {
            NSString *description = [NSString stringWithFormat:@"%@.gltf not found in bundle", name];
            *error = [NSError errorWithDomain:@"AEModelView" code:-1 userInfo:@{NSLocalizedDescriptionKey: description}];
        }
        return NO;
    }
    return [self loadModelAtPath:path error:error];
}

- (BOOL)loadModelAtPath:(NSString *)path error:(NSError *__autoreleasing  _Nullable *)error {
    AEGltfLoader *loader = [[AEGltfLoader alloc] init];
    AEMesh *mesh = [loader loadMeshFromGLTFAtPath:path error:error];
    if (!mesh) {
        return NO;
    }

    self.model = mesh;
    self.engine.model = mesh;
    return YES;
}

- (void)startRenderingWithFPS:(NSInteger)fps {
    self.framesPerSecond = fps;
    [self.engine startWithFPS:fps];
}

- (void)stopRendering {
    [self.engine stop];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self];
        [self.camera orbitWithDelta:CGSizeMake(translation.x, translation.y)];
        [gesture setTranslation:CGPointZero inView:self];
    }
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateChanged) {
        [self.camera zoomWithDelta:(1.0 - gesture.scale)];
        gesture.scale = 1.0;
    }
}

@end