//
//  RWTBorder.m
//  HelloOpenGL
//
//  Created by Main Account on 3/24/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "RWTBorder.h"
#import "border.h"

@implementation RWTBorder

- (id)initWithShader:(BaseEffect *)shader {
    if ((self = [super initWithName:"Border"
                               mass:0.0f
                             convex:NO
                                tag:kBorderTag
                             shader:shader
                           vertices:(Vertex *)Border_Cube_Border_Vertices
                        vertexCount:sizeof(Border_Cube_Border_Vertices)/sizeof(Border_Cube_Border_Vertices[0])
                        textureName:@"border.png"
                     specularColour:Border_Cube_Border_specular
                      diffuseColour:Border_Cube_Border_diffuse
                          shininess:Border_Cube_Border_shininess])) {
        self.width = 27.0;
        self.height = 48.0;
    }
    return self;
}

@end
