//
//  ParachuteNode.m
//  Tanks Go
//
//  Created by Renz on 3/25/19.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "ParachuteNode.h"
#import "Parachute.h"

@implementation ParachuteNode

- (instancetype)initWithShader:(BaseEffect *)shader {
    if ((self = [super initWithName:"Parachute" shader:shader vertices:(Vertex*)Parachute_Icosphere_Parachute_Vertices vertexCount:sizeof(Parachute_Icosphere_Parachute_Vertices) / sizeof(Parachute_Icosphere_Parachute_Vertices[0])])){
        
        [self loadTexture:@"Parachute.png"];
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
