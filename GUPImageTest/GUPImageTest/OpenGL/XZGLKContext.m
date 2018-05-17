//
//  XZGLKContext.m
//  GUPImageTest
//
//  Created by user on 2018/5/16.
//  Copyright © 2018年 Dnake. All rights reserved.
//

#import "XZGLKContext.h"

@implementation XZGLKContext

- (void)setClearColor:(GLKVector4)clearColor {
    _clearColor = clearColor;
    
    NSAssert([[self class] currentContext] == self, @"获取的上下文相同");
    
    glClearColor(_clearColor.r,
                 _clearColor.g,
                 _clearColor.b,
                 _clearColor.a);
}

- (void)clear:(GLbitfield)mask {
    
    NSAssert(self== [[self class] currentContext], @"获取的上下文相同");
    
    glClear(mask);
}

@end
