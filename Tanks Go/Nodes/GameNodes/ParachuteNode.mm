//
//  ParachuteNode.m
//  Tanks Go
//
//  Created by Renz on 3/26/19.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "ParachuteNode.h"
#import "Parachute.h"
@implementation ParachuteNode

- (id)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super initWithName:"Parachute"
                               mass:100.0f
                             convex:YES
                                tag:kParachuteTag
                             shader:shader
                           vertices:(Vertex *)Parachute_Icosphere_Parachute_Vertices
                        vertexCount:sizeof(Parachute_Icosphere_Parachute_Vertices)/sizeof(Parachute_Icosphere_Parachute_Vertices[0])
                        textureName:@"Parachute.png"
                     specularColour:Parachute_Icosphere_Parachute_specular
                      diffuseColour:Parachute_Icosphere_Parachute_diffuse
                          shininess:Parachute_Icosphere_Parachute_shininess])) {
        self.height = 3;
        self.width = 3;
        self.scale = 3;
    }
    return self;
}

@end
