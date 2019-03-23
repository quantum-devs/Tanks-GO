//
//  Tank2Node.m
//  Tanks Go
//
//  Created by Renz on 3/22/19.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "Tank2Node.h"
#import "Tank2.h"

@implementation Tank2Node

- (id)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super initWithName:"Tank2"
                               mass:50.0f
                             convex:YES
                                tag:kTank2Tag
                             shader:shader
                           vertices:(Vertex *)Tank2_Cube_Tank2_Vertices
                        vertexCount:sizeof(Tank2_Cube_Tank2_Vertices)/sizeof(Tank2_Cube_Tank2_Vertices[0])
                        textureName:@"Tank2.png"
                     specularColour:Tank2_Cube_Tank2_specular
                      diffuseColour:Tank2_Cube_Tank2_diffuse
                          shininess:Tank2_Cube_Tank2_shininess])) {
        
    }
    return self;
}

@end
