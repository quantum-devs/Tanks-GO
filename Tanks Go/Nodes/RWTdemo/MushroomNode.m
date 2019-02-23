//
//  Mushroom.m
//  Tanks Go
//
//  Created by Jason Sekhon on 2019-02-18.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "MushroomNode.h"
#import "mushroom.h"

@implementation MushroomNode

- (instancetype)initWithShader:(BaseEffect *)shader {
    if ((self = [super initWithName:"mushroom" shader:shader vertices:(Vertex*)Mushroom_Cylinder_mushroom_Vertices vertexCount:sizeof(Mushroom_Cylinder_mushroom_Vertices) / sizeof(Mushroom_Cylinder_mushroom_Vertices[0])])){
        
        [self loadTexture:@"mushroom.png"];
        self.rotationY = M_PI;
        self.rotationX = M_PI_2;
        self.scale = .5;
        self.matColour = GLKVector4Make(1, 0, 0, 1);
    }
    return self;
}

- (void)updateWithDelta:(GLfloat)dt{
    self.rotationZ += M_PI * dt;
}

@end
