//
//  OpenGLES_ch3_1ViewController.m
//  GUPImageTest
//
//  Created by user on 2018/5/17.
//  Copyright © 2018年 Dnake. All rights reserved.
//

#import "OpenGLES_ch3_1ViewController.h"

#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "XZGLKContext.h"
#import "ZXGLKVertexAttribArrayBuffer.h"
typedef struct {
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
} SceneVertex;

static const SceneVertex vertices[] = {
    {{-1.0f, -1.0f, 0.0}, {0.0f, 0.0f}},
    {{ 1.0f, -1.0f, 0.0}, {1.0f, 0.0f}},
    {{-1.0f,  1.0f, 0.0}, {0.0f, 1.0f}}
};

@interface OpenGLES_ch3_1ViewController ()

@property (nonatomic, strong) GLKBaseEffect *baseEffect;

@property (nonatomic, strong) ZXGLKVertexAttribArrayBuffer *vertexBuffer;

@end

@implementation OpenGLES_ch3_1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"此view不是GKLView类型");
    
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [AGLKContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    
    self.vertexBuffer = [[ZXGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices)/sizeof(SceneVertex) data:vertices usageMode:GL_STATIC_DRAW];
    
    /**
     创建纹理
     CGImageRef 是一个苹果封装的C数据类型
     */
    CGImageRef imageRef = [UIImage imageNamed:@"image.jpeg"].CGImage;
    
    /**
     接收一个 CGImageRef 数据并创建一个新的包含 CGImageRef 像素数据的纹理缓存。
     接收一个 CGImageRef 使得图像数据的源可以是任何Core graphics 支持的形式，从一个电影的单个帧到由一个应用绘制的自定义2D图像，再到一个图像文件内容。
     options：存储了用于指定GLKTextureLoader怎么解析加载图像数据的键值对的NSDictionary
     GLKTextureLoader 会自动调用 glTexParameteri()方法来为创建的纹理缓存设置OpenGL取样和缓存模式。
     GLKTextureInfo 类封装了与刚创建的纹理缓存相关的信息，包括尺寸以及是否包含MIP贴图
     */
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:nil error:NULL];
    
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [self.baseEffect prepareToDraw];
    
    [((AGLKContext *)view.context) clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, positionCoords)
                                  shouldEnable:YES];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SceneVertex, textureCoords)
                                  shouldEnable:YES];
    
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:3];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
