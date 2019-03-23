//
//  TankerNode.m
//  Tanks Go
//
//  Created by Renz on 2/23/19.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "TankerNode.h"
#import "Tanker.h"

@implementation TankerNode

- (id)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super initWithName:"Tanker"
                               mass:50.0f
                             convex:YES
                                tag:kTankerTag
                             shader:shader
                           vertices:(Vertex *)Tanker_Cube_002_Tanker_Vertices
                        vertexCount:sizeof(Tanker_Cube_002_Tanker_Vertices)/sizeof(Tanker_Cube_002_Tanker_Vertices[0])
                        textureName:@"camo1.jpg"
                     specularColour:Tanker_Cube_002_Tanker_specular
                      diffuseColour:Tanker_Cube_002_Tanker_diffuse
                          shininess:Tanker_Cube_002_Tanker_shininess])) {
        
    }
    return self;
}

@end
