//
//  BackgroundNode.m
//  Tanks Go
//
//  Created by Jason Sekhon on 2019-03-24.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "BackgroundNode.h"

const Vertex vertices1[] = {
    // Front
    {{1, -1, 1}, {1, 0, 0, 1}, {1, 0}, {0, 0, 1}}, // 0
    {{1, 1, 1}, {0, 1, 0, 1}, {1, 1}, {0, 0, 1}}, // 1
    {{-1, 1, 1}, {0, 0, 1, 1}, {0, 1}, {0, 0, 1}}, // 2
    
    {{-1, 1, 1}, {0, 0, 1, 1}, {0, 1}, {0, 0, 1}}, // 2
    {{-1, -1, 1}, {0, 0, 0, 1}, {0, 0}, {0, 0, 1}}, // 3
    {{1, -1, 1}, {1, 0, 0, 1}, {1, 0}, {0, 0, 1}}, // 0
};

@implementation BackgroundNode

- (id)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super initWithName:"BackgroundNode"
                               mass:0.0f
                             convex:YES
                                tag:kTank2Tag
                             shader:shader
                           vertices:(Vertex *)vertices1
                        vertexCount:sizeof(vertices1)/sizeof(vertices1[0])
                        textureName:@"landscape.png"
                     specularColour:GLKVector4Make(0.640000, 0.640000, 0.640000, 1.000000)
                      diffuseColour:GLKVector4Make(0.500000, 0.500000, 0.500000, 1.000000)
                          shininess:1])) {
        self.width = 60;
        self.height = 35;
        
    }
    return self;
}

@end
