//
//  ZXGLKView.h
//  GUPImageTest
//
//  Created by user on 2018/5/16.
//  Copyright © 2018年 Dnake. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZXGLKViewDelegate;

@interface ZXGLKView : UIView {
    EAGLContext *context;
    GLuint defaultFrameBuffer;
    GLuint colorRenderBuffer;
    GLuint drawableWidth;
    GLuint drawableHeight;
}

@property (nonatomic, weak) id<ZXGLKViewDelegate> delegate;

@property (nonatomic, strong) EAGLContext *context;

@property (nonatomic, readonly) NSInteger drawableWidth;

@property (nonatomic, readonly) NSInteger drawableHeight;

- (void)display;

@end


@protocol ZXGLKViewDelegate <NSObject>

- (void)glkview:(ZXGLKView *)view drawInRect:(CGRect)rect;

@end
