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
#import "BackgroundNode.h"
#import "AnglerNode.h"
#import "ParachuteNode.h"
#import "Player1WinsNode.h"
#import "TrailParticleNode.h"
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
    
    float _power;
    float _power2;
    float _angle;
    
    float _eMin;
    float _eMax;
    float _eMin2;
    float _eMax2;
    
    RWTBall *_ball;
    FloorNode *_floor;
    Tank1Node *_tank1;
    Tank2Node *_tank2;
    
    BackgroundNode *_background;
    AnglerNode *_angler;
    
    ParachuteNode *_parachute;
    ParachuteNode *_parachute2;
    
    TrailParticleNode *_trailParticle;
    
    Player1WinsNode *_p1;
    
    //Bullet3 Physics variables
    btBroadphaseInterface *_broadphase;
    btDefaultCollisionConfiguration *_collisionConfiguration;
    btCollisionDispatcher *_dispatcher;
    btSequentialImpulseConstraintSolver *_solver;
    btDiscreteDynamicsWorld *_world;
    
    btScalar _desiredVelocity;
    
}

- (instancetype)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super  initWithName:"GameScene" shader:shader vertices:nil vertexCount:0 tag:0])) {
        
        [self initPhysics];
        
        _gameStart = YES;
        _playerOneTurn = YES;
        _ballExists = NO;
        _playerOneHealth = [Director sharedInstance].playerOneHealth;
        _playerTwoHealth = [Director sharedInstance].playerTwoHealth;
        _playerOneMovesLeft = [Director sharedInstance].playerOneFuel;
        _playerTwoMovesLeft = [Director sharedInstance].playerTwoFuel;
        
        _power2 = 0.5;
        _eMin = 1;
        _eMax = 100;
        _eMin2 = 1;
        _eMax2 = 180;
        
        //Create the initial camera position
        _gameArea = CGSizeMake(27, 48);
        _sceneOffset = _gameArea.height/2/tanf(GLKMathDegreesToRadians(85/2));
        self.position = GLKVector3Make(-_gameArea.width/2, -_gameArea.height/2, -_sceneOffset -10 );
        
        //Background
        _background = [[BackgroundNode alloc] initWithShader:shader];
        _background.position = GLKVector3Make(_gameArea.width/2, _gameArea.height/2, -5);
        [self.children addObject:_background];
        
        //Create floor and add to scene
        _floor = [[FloorNode alloc] initWithShader:shader];
        _floor.position = GLKVector3Make(_gameArea.width/2, -5, 0);
        _floor.matColour = GLKVector4Make(1, 1, 1, 1);
        [self.children addObject:_floor];
        _world->addRigidBody(_floor.body);
        
        _tank1 = [[Tank1Node alloc] initWithShader:shader];
        _tank1.position = GLKVector3Make(_gameArea.width/2 - 40, _floor.height + 10, 3);
        [self.children addObject:_tank1];
        _world->addRigidBody(_tank1.body);
        
        _parachute = [[ParachuteNode alloc] initWithShader:shader];
        _parachute.position = GLKVector3Make(_gameArea.width/2 - 40,  _floor.height + 11, 3);
        [self.children addObject:_parachute];
        _world->addRigidBody(_parachute.body);
        
        _tank2 = [[Tank2Node alloc] initWithShader:shader];
        _tank2.position = GLKVector3Make(_gameArea.width/2 + 40, _floor.height + 10, 3);;
        [self.children addObject:_tank2];
        _world->addRigidBody(_tank2.body);
        
        _parachute2 = [[ParachuteNode alloc] initWithShader:shader];
        _parachute2.position = GLKVector3Make(_gameArea.width/2 + 40,  _floor.height + 11, 3);
        [self.children addObject:_parachute2];
        _world->addRigidBody(_parachute2.body);
        
        _angler = [[AnglerNode alloc] initWithShader:shader];
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

- (void)changeAnglerWidth:(float)vel {
    _power = (vel - _eMin) / (_eMax - _eMin) * 5;
    _power2 = (vel - _eMin) / (_eMax - _eMin);
    if (_power >= 0.1)
        _angler.width = _power;
    if (_power2 >= 0.1) {
        _angler.matColour = GLKVector4Make(1, 1, 1, _power2);
    }
}

- (void) changeAnglerAngle: (float) angle {
    _angle = (angle - _eMin2) / (_eMax2 - _eMin2) * M_PI;
    _angler.rotationZ = _angle;
}

- (BOOL)isBallActive {
    return _ballExists;
}

- (void)moveTankRight {
    if (_playerOneTurn && _playerOneMovesLeft > 0) {
        _tank1.position = GLKVector3Make(_tank1.position.x + 1, _tank1.position.y, _tank1.position.z);
        _playerOneMovesLeft--;
        _angler.position = GLKVector3Make(_tank1.position.x - 3, _tank1.height, 0);
    }
    if (!_playerOneTurn && _playerTwoMovesLeft > 0) {
        _tank2.position = GLKVector3Make(_tank2.position.x + 1, _tank2.position.y, _tank2.position.z);
        _playerTwoMovesLeft--;
        _angler.position = GLKVector3Make(_tank2.position.x + 3, _tank2.height, 0);
    }
}

- (void)moveTankLeft {
    if (_playerOneTurn && _playerOneMovesLeft > 0) {
        _tank1.position = GLKVector3Make(_tank1.position.x - 1, _tank1.position.y, _tank1.position.z);
        _angler.position = GLKVector3Make(_tank1.position.x - 3, _tank1.height, 0);
        _playerOneMovesLeft--;
    }
    if (!_playerOneTurn && _playerTwoMovesLeft > 0) {
        _tank2.position = GLKVector3Make(_tank2.position.x - 1, _tank2.position.y, _tank2.position.z);
        _angler.position = GLKVector3Make(_tank2.position.x + 3, _tank2.height, 0);
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
    _ballExists = NO;
    [[Director sharedInstance] playCollisionEffect];
    _world->removeRigidBody(ball.body);
    ball.position = GLKVector3Make(-_gameArea.width/2, -_gameArea.height/2, -_sceneOffset - 10);
    _playerOneTurn = !_playerOneTurn;
    
    for (int i = 0; i < [self.children count]; i++)
        if (((PNode *)[self.children objectAtIndex:i]).tag == kTrailParticle){
            [self.children removeObject:((PNode *)[self.children objectAtIndex:i])];
            NSLog(@"%d", i);
        }
    
    if (_playerOneTurn) {
        _angler.position = GLKVector3Make(_tank1.position.x - 3, _tank1.height, 0);
    } else {
        _angler.position = GLKVector3Make(_tank2.position.x + 3, _tank1.height, 0);
    }
    _playerOneMovesLeft = [Director sharedInstance].playerOneFuel;
    _playerTwoMovesLeft = [Director sharedInstance].playerTwoFuel;
    
}

- (void)launchBallWithVelocity:(float)X velocityY:(float)Y atAngle:(float)angle {
    _ball = [[RWTBall alloc] initWithShader:self.shader];
    [[Director sharedInstance] playLaunchEffect];
    _ballExists = YES;
    _angler.position = GLKVector3Make(_tank1.position.x, -15, 0);
    if (_playerOneTurn) {
        _ball.position = GLKVector3Make(_tank1.position.x, _tank1.position.y + 3, _tank1.position.z);
        _ball.matColour = GLKVector4Make(1, .1, .1, 1);
    } else {
        _ball.position = GLKVector3Make(_tank2.position.x, _tank2.position.y + 3, _tank2.position.z - 1);
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
    [Director sharedInstance].scene = [[GameOver alloc] initWithShader:self.shader win:NO];
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
    
    if (_ballExists){
        _trailParticle = [[TrailParticleNode alloc] initWithShader:self.shader];
        for (int i = 0; i < [self.children count]; i++)
            if (((PNode *)[self.children objectAtIndex:i]).tag == kTrailParticle){
                [self.children removeObject:((PNode *)[self.children objectAtIndex:i])];
                NSLog(@"%d", i);
            }
        _trailParticle.position = GLKVector3Make(_ball.position.x, _ball.position.y, _ball.position.z - 1);
        [self.children addObject:_trailParticle];
    }
    
    if (_parachute.position.y < _floor.height + 1) {
        _parachute.position = GLKVector3Make(_gameArea.width/2 - 40,  _floor.height + 11, 3);
        [self.children removeObject:_parachute];
        _world->removeRigidBody(_parachute.body);
        _angler.position = GLKVector3Make(_tank1.position.x - 1, _tank1.height + 1, 0);
        [self.children addObject:_angler];
        _angler.scale = 1;
        _angler.width = 2.5;
        _angler.height = 5;
        _angler.rotationZ = M_PI/2;
        _angler.matColour = GLKVector4Make(1, 1, 1, _power2);
        _world->addRigidBody(_angler.body);
    }
    
    if (_parachute2.position.y < _floor.height + 1) {
        _parachute2.position = GLKVector3Make(_gameArea.width/2 + 40,  _floor.height + 11, 3);
        [self.children removeObject:_parachute2];
        _world->removeRigidBody(_parachute2.body);
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
                    [[Director sharedInstance] playHurtEffect];
                } else if (pnB.tag == kTank2Tag) {
                    _playerTwoHealth--;
                    [[Director sharedInstance] playHurtEffect];
                }
                break;
            } else if (pnB.tag == kBallTag) {
                [self destroyBall:pnB];
                if (pnA.tag == kTank1Tag) {
                    _playerOneHealth--;
                    [[Director sharedInstance] playHurtEffect];
                } else if (pnA.tag == kTank2Tag) {
                    _playerTwoHealth--;
                    [[Director sharedInstance] playHurtEffect];
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
