//
//  TestScene.m
//  Tanks Go
//
//  Created by Jason Sekhon on 2019-02-18.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "TestScene.h"
#import "MushroomNode.h"
#import "Cube.h"

@implementation TestScene {
    MushroomNode *_mushroom;
    Cube *_cube;
}

- (instancetype)initWithShader:(BaseEffect *)shader {
    if ((self = [super initWithName:"TestScene" shader:shader vertices:nil vertexCount:0])) {
        
        _mushroom = [[MushroomNode alloc] initWithShader:shader];
        _cube = [[Cube alloc] initWithShader:shader];
        [self.children addObject:_mushroom];
        [self.children addObject:_cube];
        self.position = GLKVector3Make(0, -1, -5);
        
    }
    return self;
}

@end
