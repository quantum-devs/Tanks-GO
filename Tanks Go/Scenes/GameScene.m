//
//  GameScene.m
//  Tanks Go
//
//  Created by Jason Sekhon on 2019-02-20.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "GameScene.h"
#import "RWTPaddle.h"
#import "RWTBall.h"
#import "RWTBorder.h"
#import "RWTBrick.h"

static const int BRICKS_PER_COL = 8;
static const int BRICKS_PER_ROW = 9;

@implementation GameScene {
    CGSize _gameArea;
    float _sceneOffset;
    RWTPaddle *_paddle;
    RWTBall *_ball;
    RWTBorder *_border;
    RWTBrick *_brick;
    NSMutableArray *_bricks;
}

- (instancetype)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super  initWithName:"GameScene" shader:shader vertices:nil vertexCount:0])) {
        
        //Create the initial camera position
        _gameArea = CGSizeMake(27, 48);
        _sceneOffset = _gameArea.height/2/tanf(GLKMathDegreesToRadians(85/2));
        self.position = GLKVector3Make(-_gameArea.width/2, -_gameArea.height/2, -_sceneOffset);
        
        //Create paddle and add to scene
        _paddle = [[RWTPaddle alloc] initWithShader:shader];
        _paddle.position = GLKVector3Make(_gameArea.width/2, _gameArea.height * .05, 0);
        _paddle.matColour = GLKVector4Make(1, 0, 0, 1);
        [self.children addObject:_paddle];
        
        //Create ball and add to scene
        _ball = [[RWTBall alloc] initWithShader:shader];
        _ball.position = GLKVector3Make(_gameArea.width/2, _gameArea.height * .1, 0);
        _ball.matColour = GLKVector4Make(.5, 1, .5, 1);
        [self.children addObject:_ball];
        
        //Add a border to the center of the screen
        _border = [[RWTBorder alloc] initWithShader:shader];
        _border.position = GLKVector3Make(_gameArea.width/2, _gameArea.height/2, 0);
        [self.children addObject:_border];
        
        GLKVector4 colours[BRICKS_PER_ROW];
        for (int i = 0; i < BRICKS_PER_ROW; i++){
            colours[i] = [self color:(float)(BRICKS_PER_ROW - i) / (float)BRICKS_PER_ROW];
        }
        
        _bricks = [NSMutableArray arrayWithCapacity:72];
        for (int i = 0; i < BRICKS_PER_COL; i++){
            for (int j = 0; j < BRICKS_PER_ROW; j++){
                RWTBrick *_brick = [[RWTBrick alloc] initWithShader:shader];
                float margin = _gameArea.width * .1;
                float startY = _gameArea.height * .5;
                _brick.position = GLKVector3Make(margin + (margin * j), startY + (margin * i), 0);
                _brick.matColour = colours[i];
                [self.children addObject:_brick];
                [_bricks addObject:_brick];
            }
        }
    }
    return self;
}

- (GLKVector4)color:(float)x {
    float r = 0.0f;
    float g = 0.0f;
    float b = 1.0f;
    if (x >= 0.0f && x < 0.2f) {
        x = x / 0.2f;
        r = 0.0f;
        g = x;
        b = 1.0f;
    } else if (x >= 0.2f && x < 0.4f) {
        x = (x - 0.2f) / 0.2f;
        r = 0.0f;
        g = 1.0f;
        b = 1.0f - x;
    } else if (x >= 0.4f && x < 0.6f) {
        x = (x - 0.4f) / 0.2f;
        r = x;
        g = 1.0f;
        b = 0.0f;
    } else if (x >= 0.6f && x < 0.8f) {
        x = (x - 0.6f) / 0.2f;
        r = 1.0f;
        g = 1.0f - x;
        b = 0.0f;
    } else if (x >= 0.8f && x <= 1.0f) {
        x = (x - 0.8f) / 0.2f;
        r = 1.0f;
        g = 0.0f;
        b = x;
    }
    return GLKVector4Make(r, g, b, 1);
}

@end
