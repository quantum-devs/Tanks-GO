//
//  ViewController.m
//  Tanks Go
//
//  Created by Jason Sekhon on 2019-02-08.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "ViewController.h"
#import "Vertex.h"
#import "BaseEffect.h"
#import "GameScene.h"

@interface ViewController ()

@end

@implementation ViewController {
    BaseEffect *_shader;
    GameScene *_scene;
}

- (void) setupScene{
    _shader = [[BaseEffect alloc] initWithVertexShader:@"SimpleVertex.glsl"
                                        fragmentShader:@"SimpleFragment.glsl"];
    _scene = [[GameScene alloc] initWithShader:_shader];
    _shader.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0), self.view.bounds.size.width / self.view.bounds.size.height, 1, 150);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    [EAGLContext setCurrentContext:view.context];
    
    [self setupScene];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    GLKMatrix4 viewMatrix = GLKMatrix4Identity;
    [_scene renderWithParentModelViewMatrix:viewMatrix];
}

- (void)update {
    [_scene updateWithDelta:self.timeSinceLastUpdate];
}


@end
