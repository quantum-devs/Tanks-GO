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
#import "FloorNode.h"
#import "TankerNode.h"
#import "Tank1Node.h"
#import "Tank2Node.h"
#include "BackgroundNode.h"
#import "AnglerNode.h"
#import "ParachuteNode.h"
#include "btBulletDynamicsCommon.h"


#define BRICKS_PER_COL 8
#define BRICKS_PER_ROW 9

@implementation GameScene {
    CGSize _gameArea;
    float _sceneOffset;
    
    float _playerOneHealth;
    float _playerTwoHealth;
    float _playerOneMovesLeft;
    float _playerTwoMovesLeft;
    
    CGPoint _prevTouchLocation;
    float _ballVelocityX;
    float _ballVelocityY;
    
    RWTBall *_ball;
    FloorNode *_floor;
    Tank1Node *_tank1;
    Tank2Node *_tank2;
    
    BackgroundNode *_background;
    AnglerNode *_angler;
    ParachuteNode *_parachute;
    NSMutableArray *_tanks;
    
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
        
        _gameStart = YES;
        _playerOneTurn = YES;
        _playerOneHealth = [Director sharedInstance].playerOneHealth;
        _playerTwoHealth = [Director sharedInstance].playerTwoHealth;
        _playerOneMovesLeft = [Director sharedInstance].playerOneFuel;
        _playerTwoMovesLeft = [Director sharedInstance].playerTwoFuel;
        
        //Create the initial camera position
        _gameArea = CGSizeMake(27, 48);
        _sceneOffset = _gameArea.height/2/tanf(GLKMathDegreesToRadians(85/2));
        self.position = GLKVector3Make(-_gameArea.width/2, -_gameArea.height/2, -_sceneOffset -10 );
        
        //Background
        //_background = [[BackgroundNode alloc] initWithShader:shader];
        //_background.position = GLKVector3Make(_gameArea.width/2, _gameArea.height/2, -5);
        //[self.children addObject:_background];
        
        //Create floor and add to scene
        _floor = [[FloorNode alloc] initWithShader:shader];
        _floor.position = GLKVector3Make(_gameArea.width/2, -5, 0);
        _floor.matColour = GLKVector4Make(1, 1, 1, 1);
        [self.children addObject:_floor];
        _world->addRigidBody(_floor.body);
        
        _tank1 = [[Tank1Node alloc] initWithShader:shader];
        _tank1.position = GLKVector3Make(_gameArea.width/2 - 40, _floor.height + 1, 3);
        [self.children addObject:_tank1];
        _world->addRigidBody(_tank1.body);
        
        _tank2 = [[Tank2Node alloc] initWithShader:shader];
        _tank2.position = GLKVector3Make(_gameArea.width/2 + 40, _floor.height + 1, 3);;
        [self.children addObject:_tank2];
        _world->addRigidBody(_tank2.body);
    }
    return self;
}

- (void)initPhysics {
    
    _broadphase = new btDbvtBroadphase();
    
    _collisionConfiguration = new btDefaultCollisionConfiguration();
    _dispatcher = new btCollisionDispatcher(_collisionConfiguration);
    
    _solver  = new btSequentialImpulseConstraintSolver();
    
    _world = new btDiscreteDynamicsWorld(_dispatcher, _broadphase, _solver, _collisionConfiguration);
    
    _world->setGravity(btVector3(0, -18.62, 0));
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
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (BOOL)isBallActive {
    for (int i = 0; i < [self.children count]; i++)
        if (((PNode *)[self.children objectAtIndex:i]).tag == kBallTag)
            return YES;
    return NO;
}

- (void)moveTankRight {
    if (_playerOneTurn && _playerOneMovesLeft > 0) {
        _tank1.position = GLKVector3Make(_tank1.position.x + 1, _tank1.position.y, _tank1.position.z);
        _playerOneMovesLeft--;
    }
    if (!_playerOneTurn && _playerTwoMovesLeft > 0) {
        _tank2.position = GLKVector3Make(_tank2.position.x + 1, _tank2.position.y, _tank2.position.z);
        _playerTwoMovesLeft--;
    }
}

- (void)moveTankLeft {
    if (_playerOneTurn && _playerOneMovesLeft > 0) {
        _tank1.position = GLKVector3Make(_tank1.position.x - 1, _tank1.position.y, _tank1.position.z);
        _playerOneMovesLeft--;
    }
    if (!_playerOneTurn && _playerTwoMovesLeft > 0) {
        _tank2.position = GLKVector3Make(_tank2.position.x - 1, _tank2.position.y, _tank2.position.z);
        _playerTwoMovesLeft--;
    }
}

- (float)getPlayerOneMovesLeft {
    return _playerOneMovesLeft;
}

- (float)getPlayerTwoMovesLeft {
    return _playerTwoMovesLeft;
}

- (float)getPlayerOneHealth {
    return _playerOneHealth;
}

- (float)getPlayerTwoHealth {
    return _playerTwoHealth;
}

- (void)destroyBall:(PNode*)ball {
    [self.children removeObject:ball];
    [[Director sharedInstance] playPopEffect];
    _world->removeRigidBody(ball.body);
    ball.position = GLKVector3Make(-_gameArea.width/2, -_gameArea.height/2, -_sceneOffset - 10);
    _playerOneTurn = !_playerOneTurn;
    _playerOneMovesLeft = [Director sharedInstance].playerOneFuel;
    _playerTwoMovesLeft = [Director sharedInstance].playerTwoFuel;
    
}

- (void)launchBallWithVelocity:(float)X velocityY:(float)Y atAngle:(float)angle {
    _ball = [[RWTBall alloc] initWithShader:self.shader];
    if (_playerOneTurn) {
        _ball.position = GLKVector3Make(_tank1.position.x, _tank1.position.y + 3, _tank1.position.z);
        _ball.matColour = GLKVector4Make(1, .1, .1, 1);
    } else {
        _ball.position = GLKVector3Make(_tank2.position.x, _tank2.position.y + 3, _tank2.position.z);
        _ball.matColour = GLKVector4Make(.1, 1, .1, 1);
    }
    [self.children addObject:_ball];
    _world->addRigidBody(_ball.body);
    _ball.body->setLinearVelocity(btVector3(X/2, Y/2, 0));
}

- (float)checkVictory {
    if (_playerOneHealth <= 0){
        [self playerTwoWon];
        return 1;
    } else if (_playerTwoHealth <= 0) {
        [self playerOneWon];
        return 2;
    }
    return 0;
}

- (void)playerOneWon {
    [self reinitializeRound];
    [Director sharedInstance].scene = [[GameOver alloc] initWithShader:self.shader win:YES];
}

- (void)playerTwoWon {
    [self reinitializeRound];
    [Director sharedInstance].scene = [[GameOver alloc] initWithShader:self.shader win:YES];
}

- (void)reinitializeRound {
    _gameStart = NO;
    _playerOneTurn = YES;
    _playerOneHealth = [Director sharedInstance].playerOneHealth;
    _playerTwoHealth = [Director sharedInstance].playerTwoHealth;
    _playerOneMovesLeft = [Director sharedInstance].playerOneFuel;
    _playerTwoMovesLeft = [Director sharedInstance].playerTwoFuel;
}

- (void)updateWithDelta:(GLfloat)dt {
    [super updateWithDelta:dt];
    _world->stepSimulation(dt);
    
    if (_ball.position.x > _gameArea.width + _sceneOffset + 15 || _ball.position.x < -_gameArea.width - _sceneOffset + 10) {
        [self destroyBall:_ball];
    }
    
    if (_playerOneTurn) {
        glClearColor(1, .75, .75, 1);
    } else {
        glClearColor(.75, 1, .75, 1);
    }
    
    int numManifolds = _world->getDispatcher()->getNumManifolds();
    for (int i = 0; i < numManifolds; i++){
        btPersistentManifold *contactManifold = _world->getDispatcher()->getManifoldByIndexInternal(i);
     
        int numContacts = contactManifold->getNumContacts();
        if (numContacts > 0) {
            
            const btCollisionObject *obA = contactManifold->getBody0();
            const btCollisionObject *obB = contactManifold->getBody1();
            
            PNode *pnA = (__bridge PNode*)obA->getUserPointer();
            PNode *pnB = (__bridge PNode*)obB->getUserPointer();
            
            if (pnA.tag == kBallTag) {
                [self destroyBall:pnA];
                if (pnB.tag == kTank1Tag) {
                    _playerOneHealth--;
                } else if (pnB.tag == kTank2Tag) {
                    _playerTwoHealth--;
                }
                break;
            } else if (pnB.tag == kBallTag) {
                [self destroyBall:pnB];
                if (pnA.tag == kTank1Tag) {
                    _playerOneHealth--;
                } else if (pnA.tag == kTank2Tag) {
                    _playerTwoHealth--;
                }
                break;
            }
        }
    }
}

- (void)dealloc {
    delete _world;
    delete _solver;
    delete _collisionConfiguration;
    delete _dispatcher;
    delete _broadphase;
}

@end
