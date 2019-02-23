//
//  RWTPaddle.m
//  HelloOpenGL
//
//  Created by Main Account on 3/24/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "RWTPaddle.h"
#import "paddle.h"

@implementation RWTPaddle

- (id)initWithShader:(BaseEffect *)shader {
    if ((self = [super initWithName:"Ball"
                               mass:0.0f
                             convex:YES
                                tag:kPaddleTag
                             shader:shader
                           vertices:(Vertex *)Paddle_Cube_paddle_Vertices
                        vertexCount:sizeof(Paddle_Cube_paddle_Vertices)/sizeof(Paddle_Cube_paddle_Vertices[0])
                        textureName:@"paddle.png"
                     specularColour:Paddle_Cube_paddle_specular
                      diffuseColour:Paddle_Cube_paddle_diffuse
                          shininess:Paddle_Cube_paddle_shininess])) {
        self.width = 5.0;
        self.height = 1.0;
    }
    return self;
}

@end
