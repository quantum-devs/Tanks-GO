//
//  FloorNode.m
//  Tanks Go
//
//  Created by Renz on 2/22/19.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "FloorNode.h"
#import "Floor.h"

@implementation FloorNode

- (id)initWithShader:(BaseEffect *)shader {
    if ((self = [super initWithName:"Floor"
                               mass:0.0f
                             convex:YES
                                tag:kFloorTag
                             shader:shader
                           vertices:(Vertex *)Floor_Cube_001_Floor_Vertices
                        vertexCount:sizeof(Floor_Cube_001_Floor_Vertices)/sizeof(Floor_Cube_001_Floor_Vertices[0])
                        textureName:@"Floor.png"
                     specularColour:Floor_Cube_001_Floor_specular
                      diffuseColour:Floor_Cube_001_Floor_diffuse
                          shininess:Floor_Cube_001_Floor_shininess])) {
    }
    return self;
}

@end
