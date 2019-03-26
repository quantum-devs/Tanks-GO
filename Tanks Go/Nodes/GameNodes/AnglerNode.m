//
//  AnglerNode.m
//  Tanks Go
//
//  Created by Renz on 3/25/19.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "AnglerNode.h"
#import "Angler.h"

@implementation AnglerNode

- (instancetype)initWithShader:(BaseEffect *)shader {
    if ((self = [super initWithName:"mushroom" shader:shader vertices:(Vertex*)Angler_Cube_Angler_Vertices vertexCount:sizeof(Angler_Cube_Angler_Vertices) / sizeof(Angler_Cube_Angler_Vertices[0])])){
        
        [self loadTexture:@"Angler.png"];
        self.scale = 5;
        self.width = 5;
        self.height = 5;
        //self.rotationY = M_PI;
        //self.rotationX = M_PI_2;
        //self.matColour = GLKVector4Make(1, 0, 0, 1);
    }
    return self;
}

- (void)updateWithDelta:(GLfloat)dt{
    self.rotationZ -= M_PI * dt;
}

@end
