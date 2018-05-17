//
//  OpenGLES_Ch2_1.m
//  GUPImageTest
//
//  Created by user on 2018/5/15.
//  Copyright © 2018年 Dnake. All rights reserved.
//

#import "OpenGLES_Ch2_1.h"


/**
 
 1.生成: glGenBuffers()
 2.绑定缓存数据: glBindBuffer()
 3.缓存数据:glBufferData()
 4.启用:glEnableVertexAttribArray()
 5.设置指针:glVertexAttribPointer()
 6.绘图:glDrawArrays()
 7.删除:glDeleteBuffers()
 
 */

typedef struct {
    GLKVector3 positionCoords;
} SceneVerTex;

static const SceneVerTex vertices[] = {
    {{-0.5f, -0.5f, 0.0}},
    {{0.5f, -0.5f, 0.0}},
    {{-0.5f, 0.5f, 0.0}}
};

@interface OpenGLES_Ch2_1 () {
    GLuint vertexBufferID;
}

@property (nonatomic, strong) GLKBaseEffect *baseEffect;

@end

@implementation OpenGLES_Ch2_1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"此view不是GKLView类型");
    
    //设置view的上下文
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    //设置新的当前上下文
    [EAGLContext setCurrentContext:view.context];
    
     /* GLKBaseEffect类提供了不依赖于所使用的OpenGL中的渲染方法 */
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);//渲染一个恒定不变的白色三角形。保存4个颜色数值C数据结构GLKVector4
    
    //清除当前颜色（用于在上下文的帧缓存被清除时初始化每个像素的颜色值）
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    /*
     创建，绑定一个VAO：用于定义要绘制的三角形的顶点位置数据，创建并使用一个用于保存顶点数据的顶点属性数组缓存
     
     1.为缓存生成一个独一无二的标识符
     2.为接下来的运算绑定缓存
     3.复制数据到缓存中
     
     */
    glGenBuffers(1, &vertexBufferID);
    
    glBindBuffer(GL_ARRAY_BUFFER,  //常量，用于指定要绑定那一种类型的缓存
                 vertexBufferID);  //要绑定的标识符
    
    glBufferData(GL_ARRAY_BUFFER,   //缓冲器复制
                 sizeof(vertices),  //顶点数据的字节数复制
                 vertices,          //顶点位置复制
                 GL_STATIC_DRAW);  //在GPU内存中缓存起来（复制到内存中，并很少对其做修改）
    
    /**
     
     第一步：glGenBuggers()函数的第一个参数用于指定要生成的缓存标识数量，第二参数是一个指针，指向生成的标识符的内存保存位置（在当前情况，一个标识符被生成，并保存在了 vertexBufferID 的实例变量中）
     第二步：glBingBuffer()函数绑定用于指定标识符的缓存到当前缓存中，在任意时刻每种类型只能绑定一个缓存。（如果这个例子中使用两个顶点属性数组缓存，那么同一时刻它们不能都被绑定）
     第三步：glBUfferData()函数复制应用的顶点数据到当前上下文所绑定的顶点缓存中
     
     */
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    /**
     
     第七步：删除不在需要的顶点缓存和上下文
     
     */
    
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    if (vertexBufferID != 0) {
        glDeleteBuffers(1, &vertexBufferID);
        vertexBufferID = 0;
    }
    
    view.context = nil;
    [EAGLContext setCurrentContext:nil];
}


/**
 每当一个GLKView实例需要被重绘时，它都会让保存在视图中的上下文属性中的OpenGL的上下文当成当前的上下文。
 调用这个方法的刷新频率我们是可以设置，通过preferredFramesPerSecond属性来设置
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    
    [self.baseEffect prepareToDraw];
    
    //设置当前绑定的帧缓存的像素颜色值渲染缓存中的每一个像素的颜色为前面使用glClearColor()函数设定的值
    //glClear()函数会有效设置帧缓存中的每一个像素的颜色为背景色
    glClear(GL_COLOR_BUFFER_BIT);
    
    /**
     
     第四步：启动
     第五步：设置指针
     第六步：绘图
     
     在帧缓存被清除后，是时候用存储在当前绑定的OpenGL的GL_ARRAY_BUFFER类型缓存中的顶点数据绘制一个三角形。
     */
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);//启动顶点缓存渲染操作
    
    glVertexAttribPointer(GLKVertexAttribPosition,//指示当前绑定的缓存包含每个顶点的位置信息
                          3,//指示每个位置有3个部分
                          GL_FLOAT,//告诉OpenGL每个部分都保存为一个浮点数的值
                          GL_FALSE,//告诉OpenGL小数点固定数据是否可以被改变
                          sizeof(SceneVerTex),//叫“步幅”，指定每个顶点的保存需要多少个字节（步幅指定了GPU从一个顶点的内存开始位置转到下一个顶点的内存开始位置需要跳过多少个字节）
                          NULL);//告诉OpenGL可以从当前绑定的顶点缓存的开始位置访问顶点数据
    
    //执行绘制
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    
}


@end
