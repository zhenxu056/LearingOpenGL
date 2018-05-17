//
//  ZXGLKVertexAttribArrayBuffer.m
//  GUPImageTest
//
//  Created by user on 2018/5/16.
//  Copyright © 2018年 Dnake. All rights reserved.
//

#import "ZXGLKVertexAttribArrayBuffer.h"

@interface ZXGLKVertexAttribArrayBuffer ()

@property (nonatomic, assign) GLsizeiptr bufferSizeBytes;

@property (nonatomic, assign) GLsizeiptr stride;

@end

@implementation ZXGLKVertexAttribArrayBuffer

- (id)initWithAttribStride:(GLsizeiptr)stride
          numberOfVertices:(GLint)count
                      data:(const GLvoid *)dataPtr
                     usageMode:(GLenum)usageMode
{
    NSParameterAssert(0<stride);
    NSParameterAssert(0<count);
    NSParameterAssert(NULL != dataPtr);
    
    if (nil != (self = [super init])) {
        _stride = stride;
        _bufferSizeBytes = stride * count;
        
        glGenBuffers(1, &_glName);
        glBindBuffer(GL_ARRAY_BUFFER, _glName);
        glBufferData(GL_ARRAY_BUFFER, _bufferSizeBytes, dataPtr, usageMode);
        
        NSAssert(0 != _glName, @"创建失败");
    }
    return self;
}

- (void)prepareToDrawWithAttrib:(GLuint)index
            numberOfCoordinates:(GLint)count
                   attribOffset:(GLsizeiptr)offset
                   shouldEnable:(BOOL)shouldEnable
{
    
    NSParameterAssert((0 < count) && (count < 4));
    NSParameterAssert(offset < _stride);
    NSParameterAssert(0 != _glName);
    
    if (shouldEnable) {
        glEnableVertexAttribArray(index);
    }
    
    glVertexAttribPointer(index,
                          count,
                          GL_FLOAT,
                          GL_FALSE,
                          _stride,
                          NULL+offset);
    
    
}

- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)first
         numberOfVertices:(GLsizei)count
{
    
    NSAssert(_bufferSizeBytes >= (first +count) *_stride, @"失败");
    
    glDrawArrays(mode, first, count);
    
}

- (void)dealloc {
    if (0 != _glName) {
        glDeleteBuffers(1, &_glName);
        _glName = 0;
    }
}

@end
