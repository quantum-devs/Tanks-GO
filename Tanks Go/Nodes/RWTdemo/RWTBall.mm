//
//  RWTBall.m
//  HelloOpenGL
//
//  Created by Main Account on 3/24/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "RWTBall.h"
#import "ball.h"

@implementation RWTBall

- (id)initWithShader:(BaseEffect *)shader {
    if ((self = [super initWithName:"Ball"
                               mass:1.0f
                             convex:YES
                                tag:kBallTag
                             shader:shader
                           vertices:(Vertex *)Ball_Sphere_ball_Vertices
                        vertexCount:sizeof(Ball_Sphere_ball_Vertices)/sizeof(Ball_Sphere_ball_Vertices[0])
                        textureName:@"ball.png"
                     specularColour:Ball_Sphere_ball_specular
                      diffuseColour:Ball_Sphere_ball_diffuse
                          shininess:Ball_Sphere_ball_shininess])) {
        self.width = 1.0;
        self.height = 1.0;
    }
    return self;
}

@end
