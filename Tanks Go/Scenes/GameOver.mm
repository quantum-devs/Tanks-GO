//
//  GameOver.m
//  Tanks Go
//
//  Created by Jason Sekhon on 2019-02-21.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "GameOver.h"
#import "Player1WinsNode.h"
#import "Player2WinsNode.h"
#import "GameScene.h"
#import "Director.h"

@implementation GameOver {
    GLfloat _timeSinceStart;
}

-(instancetype)initWithShader:(BaseEffect *)shader win:(BOOL)win {
    if ((self = [super initWithName:"GameOver" shader:shader vertices:nil vertexCount:0])) {
        CGSize _gameArea = CGSizeMake(27, 48);
        float _sceneOffset = _gameArea.height/2/tanf(GLKMathDegreesToRadians(85/2));
        self.position = GLKVector3Make(-_gameArea.width/2, -_gameArea.height/2, -_sceneOffset);
        self.rotationX = GLKMathDegreesToRadians(-45);
        Node *message;
        if (win) {
            glClearColor(1, .5, .5, 1);
            message = [[Player1WinsNode alloc] initWithShader:self.shader];
            message.matColour = GLKVector4Make(1, 0, 0, 1);
        } else {
            glClearColor(.5, 1, .5, 1);
            message = [[Player2WinsNode alloc] initWithShader:self.shader];
            message.matColour = GLKVector4Make(0, 1, 0, 1);
        }
        message.position = GLKVector3Make(13.5, 24, 0);
        [self.children addObject:message];
    }
    return self;
}

- (void)updateWithDelta:(GLfloat)dt {
    [super updateWithDelta:dt];
    _timeSinceStart += dt;
    _storeEnabled = NO;
    if (_timeSinceStart > 5) {
        _storeEnabled = YES;
    }
}

@end
