//
//  XZGLKContext.h
//  GUPImageTest
//
//  Created by user on 2018/5/16.
//  Copyright © 2018年 Dnake. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface XZGLKContext : EAGLContext

@property (nonatomic, assign) GLKVector4 clearColor;

- (void)clear:(GLbitfield)mask;

@end
