//
//  OpenGLES_ch2_3ViewController.m
//  GUPImageTest
//
//  Created by user on 2018/5/16.
//  Copyright © 2018年 Dnake. All rights reserved.
//

#import "OpenGLES_ch2_3ViewController.h"

#import "XZGLKContext.h"
#import "ZXGLKVertexAttribArrayBuffer.h"

typedef struct {
    GLKVector3 positionCoords;
} SceneVerTex;

typedef struct {
    GLKVector3 positionCoords;
} SceneVerTex2;

static const SceneVerTex vertices[] = {
    {{-1.0f, 0.0f, 0.0f}},
    {{1.0f, 0.0f, 0.0f}},
    {{0.0f, -1.0f, 0.0f}}
};

@interface OpenGLES_ch2_3ViewController ()

@property (nonatomic, strong) GLKBaseEffect *baseEffect;

@property (nonatomic, strong) ZXGLKVertexAttribArrayBuffer *glkVertexAttribArrayBuffer;

@end

@implementation OpenGLES_ch2_3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"此view不是GKLView类型");
    
    //设置view的上下文
    view.context = [[XZGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 0.0f, 1.0f, 1.0f);
     
    ((XZGLKContext *)view.context).clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    
    _glkVertexAttribArrayBuffer = [[ZXGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVerTex) numberOfVertices:3 data:vertices usageMode:GL_STATIC_DRAW];
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    [self.baseEffect prepareToDraw];
    
    [((XZGLKContext *)view.context) clear:GL_COLOR_BUFFER_BIT];
    
    [_glkVertexAttribArrayBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:0 shouldEnable:YES];

    [_glkVertexAttribArrayBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:3];
    
}

-  (void)dealloc {
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    view.context = nil;
    [EAGLContext setCurrentContext:nil];
}
@end
