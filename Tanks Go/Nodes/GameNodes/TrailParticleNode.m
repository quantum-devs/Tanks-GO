//
//  TrailParticleNode.m
//  Tanks Go
//
//  Created by Jason Sekhon on 2019-04-01.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "TrailParticleNode.h"

const Vertex vertices2[] = {
    // Front
    {{1, -1, 1}, {1, 0, 0, 1}, {1, 0}, {0, 0, 1}}, // 0
    {{1, 1, 1}, {0, 1, 0, 1}, {1, 1}, {0, 0, 1}}, // 1
    {{-1, 1, 1}, {0, 0, 1, 1}, {0, 1}, {0, 0, 1}}, // 2
    
    {{-1, 1, 1}, {0, 0, 1, 1}, {0, 1}, {0, 0, 1}}, // 2
    {{-1, -1, 1}, {0, 0, 0, 1}, {0, 0}, {0, 0, 1}}, // 3
    {{1, -1, 1}, {1, 0, 0, 1}, {1, 0}, {0, 0, 1}}, // 0
};

@implementation TrailParticleNode {
    float time;
}

- (instancetype)initWithShader:(BaseEffect *)shader {
    if ((self = [super initWithName:"particleTrail" shader:shader vertices:(Vertex *)vertices2 vertexCount:sizeof(vertices2)/sizeof(vertices2[0]) tag:kTrailParticle])) {
        self.width = .2;
        self.height = .2;
        self.specularColor = GLKVector4Make(1, 1, 1, 1);
        self.diffuseColor = GLKVector4Make(1, 1, 1, 1);
    }
    return self;
}

- (void)updateWithDelta:(GLfloat)aDelta {
    
    time += aDelta;
    if (time < 3)
        self.matColour = GLKVector4Make(1, 1, 1, 3-time);
    
    // Increase the amount of rotation
    self.rotationY += M_PI_4 * aDelta;
    self.rotationZ+= M_PI_4 * aDelta;
    
    [super updateWithDelta:aDelta];
    
}

@end
