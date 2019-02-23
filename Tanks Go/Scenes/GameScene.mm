//
//  GameScene.m
//  Tanks Go
//
//  Created by Jason Sekhon on 2019-02-20.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "GameScene.h"
#import "GameOver.h"
#import "RWTPaddle.h"
#import "RWTBall.h"
#import "RWTBorder.h"
#import "RWTBrick.h"
#import "Director.h"
#include "btBulletDynamicsCommon.h"

#define BRICKS_PER_COL 8
#define BRICKS_PER_ROW 9

@implementation GameScene {
    CGSize _gameArea;
    float _sceneOffset;
    //RWTPaddle *_paddle;
    //RWTBall *_ball;
    //RWTBorder *_border;
    //RWTBrick *_brick;
    //NSMutableArray *_bricks;
    CGPoint _prevTouchLocation;
    //float _ballVelocityX;
    //float _ballVelocityY;
    
    //Bullet3 Physics variables
    btBroadphaseInterface *_broadphase;
    btDefaultCollisionConfiguration *_collisionConfiguration;
    btCollisionDispatcher *_dispatcher;
    btSequentialImpulseConstraintSolver *_solver;
    btDiscreteDynamicsWorld *_world;
    
    btScalar _desiredVelocity;
}

- (instancetype)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super  initWithName:"GameScene" shader:shader vertices:nil vertexCount:0])) {
        
        [self initPhysics];
        
        //Create the initial camera position
        _gameArea = CGSizeMake(27, 48);
        _sceneOffset = _gameArea.height/2/tanf(GLKMathDegreesToRadians(85/2));
        self.position = GLKVector3Make(-_gameArea.width/2, -_gameArea.height/2, -_sceneOffset);
        
        /*
        //Create paddle and add to scene
        _paddle = [[RWTPaddle alloc] initWithShader:shader];
        _paddle.position = GLKVector3Make(_gameArea.width/2, _gameArea.height * .05, 0);
        _paddle.matColour = GLKVector4Make(1, 0, 0, 1);
        [self.children addObject:_paddle];
        _world->addRigidBody(_paddle.body);
        
        //Create ball and add to scene
        _ball = [[RWTBall alloc] initWithShader:shader];
        _ball.position = GLKVector3Make(_gameArea.width/2, _gameArea.height * .1, 0);
        _ball.matColour = GLKVector4Make(.5, 1, .5, 1);
        [self.children addObject:_ball];
        _world->addRigidBody(_ball.body);
        _ball.body->setLinearVelocity(btVector3(15, 15, 0));
        _desiredVelocity = _ball.body->getLinearVelocity().length();
        
        //Add a border to the center of the screen
        _border = [[RWTBorder alloc] initWithShader:shader];
        _border.position = GLKVector3Make(_gameArea.width/2, _gameArea.height/2, 0);
        [self.children addObject:_border];
        _world->addRigidBody(_border.body);
        
        GLKVector4 colours[BRICKS_PER_ROW];
        for (int i = 0; i < BRICKS_PER_ROW; i++){
            colours[i] = [self color:(float)(BRICKS_PER_ROW - i) / (float)BRICKS_PER_ROW];
        }
        
        _bricks = [NSMutableArray arrayWithCapacity:72];
        for (int j = 0; j < BRICKS_PER_COL; j++){
            for (int i = 0; i < BRICKS_PER_ROW; i++){
                RWTBrick *_brick = [[RWTBrick alloc] initWithShader:shader];
                float margin = _gameArea.width * .1;
                float startY = _gameArea.height * .5;
                _brick.position = GLKVector3Make(margin + (margin * i), startY + (margin * j), 0);
                _brick.matColour = colours[i];
                [self.children addObject:_brick];
                [_bricks addObject:_brick];
                _world->addRigidBody(_brick.body);
            }
        }
         */
    }
    return self;
}

- (void)initPhysics {
    
    _broadphase = new btDbvtBroadphase();
    
    _collisionConfiguration = new btDefaultCollisionConfiguration();
    _dispatcher = new btCollisionDispatcher(_collisionConfiguration);
    
    _solver  = new btSequentialImpulseConstraintSolver();
    
    _world = new btDiscreteDynamicsWorld(_dispatcher, _broadphase, _solver, _collisionConfiguration);
    
    _world->setGravity(btVector3(0, 0, 0));
}

- (CGPoint) touchLocationToGameArea:(CGPoint)touchLocation {
    float ratio = [Director sharedInstance].view.frame.size.height / _gameArea.height;
    float actualX = touchLocation.x / ratio;
    float actualY = ([Director sharedInstance].view.frame.size.height - touchLocation.y ) / ratio;
    CGPoint actual = CGPointMake(actualX, actualY);
    return actual;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:[Director sharedInstance].view];
    _prevTouchLocation = [self touchLocationToGameArea:touchLocation];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:[Director sharedInstance].view];
    touchLocation = [self touchLocationToGameArea:touchLocation];
    CGPoint diff = CGPointMake(touchLocation.x - _prevTouchLocation.x, touchLocation.y - _prevTouchLocation.y);
    _prevTouchLocation = touchLocation;
    //float  newX = _paddle.position.x + diff.x;
    //newX = MIN(MAX(newX, _paddle.width/2), _gameArea.width - _paddle.width/2);
    //_paddle.position = GLKVector3Make(newX, _paddle.position.y, _paddle.position.z);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
/*
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
} */

- (void)updateWithDelta:(GLfloat)dt {
    [super updateWithDelta:dt];
    _world->stepSimulation(dt);
    
    /*
    if (_ball.position.y < 0) {
        [Director sharedInstance].scene = [[GameOver alloc] initWithShader:self.shader win:NO];
        return;
    }
    int numManifolds = _world->getDispatcher()->getNumManifolds();
    for (int i = 0; i < numManifolds; i++){
        btPersistentManifold *contactManifold = _world->getDispatcher()->getManifoldByIndexInternal(i);
        
        int numContacts = contactManifold->getNumContacts();
        NSLog(@"%d", numContacts);
        if (numContacts > 0) {
            [[Director sharedInstance] playPopEffect];
            
            const btCollisionObject *obA = contactManifold->getBody0();
            const btCollisionObject *obB = contactManifold->getBody1();
            
            PNode *pnA = (__bridge PNode*)obA->getUserPointer();
            PNode *pnB = (__bridge PNode*)obB->getUserPointer();
            
            if (pnA.tag == kBrickTag) {
                [self destroyBrickAndCheckVictory:pnA];
            }
            
            if (pnB.tag == kBrickTag) {
                [self destroyBrickAndCheckVictory:pnB];
            }
        }
    }
    
    btVector3 currentVelocityDirection = _ball.body->getLinearVelocity();
    btScalar currentVelocity = currentVelocityDirection.length();
    if (currentVelocity < _desiredVelocity) {
        currentVelocityDirection *= _desiredVelocity/currentVelocity;
        _ball.body->setLinearVelocity(currentVelocityDirection);
    }*/
}
/*
- (void)destroyBrickAndCheckVictory:(PNode*)brick {
    [self.children removeObject:brick];
    [_bricks removeObject:brick];
    
    _world->removeRigidBody(brick.body);
    
    if (_bricks.count == 0) {
        [Director sharedInstance].scene = [[GameOver alloc] initWithShader:self.shader win:YES];
    }
}*/

- (void)dealloc {
    delete _world;
    delete _solver;
    delete _collisionConfiguration;
    delete _dispatcher;
    delete _broadphase;
}

@end
