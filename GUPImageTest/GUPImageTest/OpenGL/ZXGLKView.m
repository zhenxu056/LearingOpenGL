//
//  ZXGLKView.m
//  GUPImageTest
//
//  Created by user on 2018/5/16.
//  Copyright © 2018年 Dnake. All rights reserved.
//

#import "ZXGLKView.h"

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
 
@implementation ZXGLKView

- (instancetype)initWithFrame:(CGRect)frame
                      context:(EAGLContext *)aContext {
    
    if (self = [super initWithFrame:frame]) {
        
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        //告诉Core Animation 不要试图保留任何以前绘制的图像留作以后重用
        eaglLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking: @(NO),
                                         kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8};
        
        self.context = aContext;
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        //告诉Core Animation 不要试图保留任何以前绘制的图像留作以后重用
        eaglLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking: @(NO),
                                         kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8};
    }
    return self;
}

- (void)setContext:(EAGLContext *)aContext {
    if (context != aContext) {
        
        [EAGLContext setCurrentContext:context];
        
        if (0 != defaultFrameBuffer) {
            glDeleteBuffers(1, &defaultFrameBuffer);
            defaultFrameBuffer = 0;
        }
        if (9 != colorRenderBuffer) {
            glDeleteBuffers(1, &colorRenderBuffer);
            colorRenderBuffer = 0;
        }
        
        context = aContext;
        
        if (context) {
            context = aContext;
            [EAGLContext setCurrentContext:context];
            
            glGenBuffers(1, &colorRenderBuffer);
            glBindBuffer(GL_FRAMEBUFFER, defaultFrameBuffer);
            
            glGenBuffers(1, &colorRenderBuffer);
            glBindBuffer(GL_RENDERBUFFER, colorRenderBuffer);
            
            glFramebufferRenderbuffer(GL_FRAMEBUFFER,
                                      GL_COLOR_ATTACHMENT0,
                                      GL_RENDERBUFFER,
                                      colorRenderBuffer);
        }
    }
}

- (EAGLContext *)context {
    return context;
}

- (void)display {
    [EAGLContext setCurrentContext:self.context];
    
    glViewport(0, 0, self.drawableWidth, self.drawableHeight);
    
    [self drawRect:[self bounds]];
    
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)drawRect:(CGRect)rect {
    if (self.delegate) {
        [self.delegate glkview:self drawInRect:self.bounds];
    }
}

- (void)layoutSubviews {
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
    
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
    
    glBindBuffer(GL_RENDERBUFFER, colorRenderBuffer);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"创建编译缓存失败 %x",status);
    }
}

- (NSInteger)drawableWidth {
    GLint backingWidth;
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER,
                                 GL_RENDERBUFFER_WIDTH,
                                 &backingWidth);
    
    return (NSInteger)backingWidth;
}

- (NSInteger)drawableHeight {
    GLint backingHeight;
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER,
                                 GL_RENDERBUFFER_HEIGHT,
                                 &backingHeight);
    
    return (NSInteger)backingHeight;
}

- (void)dealloc {
    
    if ([EAGLContext currentContext]== context) {
        [EAGLContext setCurrentContext:nil];
    }
    context = nil;
}

/**
 每个View都有一个相关的的core Animation层，cocoa touch会调用+layerClass方法来确定要创建什么类型的层

 @return CAEAGLLayer 是Core Animation提供的标准层类之一（CAEAGLLayer会与一个OpenGL ES的帧缓存共享它的像素颜色库）
 */
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

@end
