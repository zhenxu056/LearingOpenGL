//
//  ZXGLKVertexAttribArrayBuffer.h
//  GUPImageTest
//
//  Created by user on 2018/5/16.
//  Copyright © 2018年 Dnake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface ZXGLKVertexAttribArrayBuffer : NSObject

@property (nonatomic, readonly) GLuint glName;

@property (nonatomic, readonly) GLsizeiptr bufferSizeBytes;

@property (nonatomic, readonly) GLsizeiptr stride;

- (id)initWithAttribStride:(GLsizeiptr)stride
          numberOfVertices:(GLint)count
                      data:(const GLvoid *)dataPtr
                 usageMode:(GLenum)usageMode;

- (void)prepareToDrawWithAttrib:(GLuint)index
            numberOfCoordinates:(GLint)count
                   attribOffset:(GLsizeiptr)offset
                   shouldEnable:(BOOL)shouldEnable;

- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)first
         numberOfVertices:(GLsizei)count;
@end
