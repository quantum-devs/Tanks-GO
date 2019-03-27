//
//  AnglerNode.m
//  Tanks Go
//
//  Created by Renz on 3/26/19.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "AnglerNode.h"
#import "Angler.h"

@implementation AnglerNode

- (id)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super initWithName:"Angler"
                               mass:0.0f
                             convex:YES
                                tag:kAnglerTag
                             shader:shader
                           vertices:(Vertex *)Angler_Cube_Angler_Vertices
                        vertexCount:sizeof(Angler_Cube_Angler_Vertices)/sizeof(Angler_Cube_Angler_Vertices[0])
                        textureName:@"Angler.png"
                     specularColour:Angler_Cube_Angler_specular
                      diffuseColour:Angler_Cube_Angler_diffuse
                          shininess:Angler_Cube_Angler_shininess])) {
        
    }
    return self;
}

@end
