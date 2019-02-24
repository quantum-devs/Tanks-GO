//
//  PanzerNode.m
//  Tanks Go
//
//  Created by Renz on 2/22/19.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "PanzerNode.h"
#import "Panzer.h"
@implementation PanzerNode

- (id)initWithShader:(BaseEffect *)shader {

    if ((self = [super initWithName:"Panzer"
                               mass:1.0f
                             convex:YES
                                tag:kPanzerTag
                             shader:shader
                           vertices:(Vertex *)Panzer_Cube_001_Panzer_Vertices
                        vertexCount:sizeof(Panzer_Cube_001_Panzer_Vertices)/sizeof(Panzer_Cube_001_Panzer_Vertices[0])
                        textureName:@"Panzer.png"
                     specularColour:Panzer_Cube_001_Panzer_specular
                      diffuseColour:Panzer_Cube_001_Panzer_diffuse
                          shininess:Panzer_Cube_001_Panzer_shininess])) {
        
    }
    return self;
}




@end
