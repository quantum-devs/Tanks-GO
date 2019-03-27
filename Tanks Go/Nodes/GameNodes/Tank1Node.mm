//
//  Tank1Node.m
//  Tanks Go
//
//  Created by Renz on 3/22/19.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "Tank1Node.h"
#import "Tank1.h"
@implementation Tank1Node

- (id)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super initWithName:"Tank1"
                               mass:500.0f
                             convex:YES
                                tag:kTank1Tag
                             shader:shader
                           vertices:(Vertex *)Tank1_Cube_Tank1_Vertices
                        vertexCount:sizeof(Tank1_Cube_Tank1_Vertices)/sizeof(Tank1_Cube_Tank1_Vertices[0])
                        textureName:@"Tank1.png"
                     specularColour:Tank1_Cube_Tank1_specular
                      diffuseColour:Tank1_Cube_Tank1_diffuse
                          shininess:Tank1_Cube_Tank1_shininess])) {
        
    }
    return self;
}


@end
