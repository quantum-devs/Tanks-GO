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

- (instancetype)initWithShader:(BaseEffect *)shader {
    if ((self = [super initWithName:"background" shader:shader vertices:(Vertex *)vertices1 vertexCount:sizeof(vertices1)/sizeof(vertices1[0]) tag:0])) {
        [self loadTexture:@"landscape-min.png"];
        self.height = 50;
        self.width = 75;
    }
    return self;
}

@end
