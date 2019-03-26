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
#import "AnglerNode.h"
#include "btBulletDynamicsCommon.h"


#define BRICKS_PER_COL 8
#define BRICKS_PER_ROW 9

@implementation GameScene {
    CGSize _gameArea;
    float _sceneOffset;
    
    BOOL _playerOneTurn;
    
    RWTBall *_ball;
    CGPoint _prevTouchLocation;
    float _ballVelocityX;
    float _ballVelocityY;
    FloorNode *_floor;
    TankerNode *_tanker;
    Tank1Node *_tank1;
    Tank2Node *_tank2;
    AnglerNode *_angler;
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
        
        _playerOneTurn = YES;
        
        //Create the initial camera position
        _gameArea = CGSizeMake(27, 48);
        _sceneOffset = _gameArea.height/2/tanf(GLKMathDegreesToRadians(85/2));
        self.position = GLKVector3Make(-_gameArea.width/2, -_gameArea.height/2, -_sceneOffset -10 );
        
        //Create floor and add to scene
        _floor = [[FloorNode alloc] initWithShader:shader];
        _floor.position = GLKVector3Make(_gameArea.width/2, -5, 0);
        _floor.matColour = GLKVector4Make(1, 1, 1, 1);
        [self.children addObject:_floor];
        _world->addRigidBody(_floor.body);
        
         _tanks = [NSMutableArray arrayWithCapacity:2];
        //Create tanks and add to scene
        _tanker = [[TankerNode alloc] initWithShader:shader];
        _tanker.rotationY = -M_PI_2;
        _tanker.position = GLKVector3Make(_gameArea.width/2 - 40, _gameArea.height * 0.05, 2);
        _tanker.matColour = GLKVector4Make(.5, 1, .5, 1);
        [self.children addObject:_tanker];
        [_tanks addObject:_tanker];
        _world->addRigidBody(_tanker.body);
        
        _tanker = [[TankerNode alloc] initWithShader:shader];
        _tanker.rotationY = M_PI_2;
        _tanker.position = GLKVector3Make(_gameArea.width/2 + 40, _gameArea.height * 0.05, 2);
        _tanker.matColour = GLKVector4Make(1, .5, .5, 1);
        [self.children addObject:_tanker];
        [_tanks addObject:_tanker];
        _world->addRigidBody(_tanker.body);
        
        _tank1 = [[Tank1Node alloc] initWithShader:shader];
        _tank1.position = GLKVector3Make(_gameArea.width/2, _gameArea.height * .5, 2);
        [self.children addObject:_tank1];
        [_tanks addObject:_tank1];
        _world->addRigidBody(_tank1.body);
        
        _tank2 = [[Tank2Node alloc] initWithShader:shader];
        _tank2.position = GLKVector3Make(_gameArea.width/2 + 20, _gameArea.height * .5, 2);
        [self.children addObject:_tank2];
        [_tanks addObject:_tank2];
        _world->addRigidBody(_tank2.body);
        
        _angler = [[AnglerNode alloc] initWithShader:shader];
        _angler.position = GLKVector3Make(_gameArea.width/2, _gameArea.height * .5, 2);
        [self.children addObject:_angler];
        [_tanks addObject:_angler];
        
    }
    return self;
}

- (void)initPhysics {
    
    _broadphase = new btDbvtBroadphase();
    
    _collisionConfiguration = new btDefaultCollisionConfiguration();
    _dispatcher = new btCollisionDispatcher(_collisionConfiguration);
    
    _solver  = new btSequentialImpulseConstraintSolver();
    
    _world = new btDiscreteDynamicsWorld(_dispatcher, _broadphase, _solver, _collisionConfiguration);
    
    _world->setGravity(btVector3(0, -9.81, 0));
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

- (void)destroyBall:(PNode*)ball {
    [self.children removeObject:ball];
    _world->removeRigidBody(ball.body);
}

- (void)launchBallWithVelocity:(float)X velocityY:(float)Y atAngle:(float)angle {
    _ball = [[RWTBall alloc] initWithShader:self.shader];
    if (_playerOneTurn) {
        _ball.position = GLKVector3Make(((PNode *)[_tanks objectAtIndex:0]).position.x, ((PNode *)[_tanks objectAtIndex:0]).position.y + 3, ((PNode *)[_tanks objectAtIndex:0]).position.z);
        _ball.matColour = GLKVector4Make(.5, 1, .5, 1);
    } else {
        _ball.position = GLKVector3Make(((PNode *)[_tanks objectAtIndex:1]).position.x, ((PNode *)[_tanks objectAtIndex:1]).position.y + 3, ((PNode *)[_tanks objectAtIndex:1]).position.z);
        _ball.matColour = GLKVector4Make(1, .5, .5, 1);
    }
    [self.children addObject:_ball];
    _world->addRigidBody(_ball.body);
    _ball.body->setLinearVelocity(btVector3(X/2, Y/2, 0));
    _playerOneTurn = !_playerOneTurn;
}

- (void)updateWithDelta:(GLfloat)dt {
    [super updateWithDelta:dt];
    _world->stepSimulation(dt);
    
    if (_ball.position.x > _gameArea.width + _sceneOffset + 10 || _ball.position.x < -_gameArea.width - _sceneOffset + 10)
        [self destroyBall:_ball];
    
    if (_playerOneTurn) {
        glClearColor(.5, 1, .5, 1);
    } else {
        glClearColor(1, .5, .5, 1);
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
            
            if (pnA.tag == kBallTag) {
                [self destroyBall:pnA];
                if (pnB.tag == kTankerTag) {
                    
                }
            }
            
            if (pnB.tag == kBallTag) {
                [self destroyBall:pnB];
                if (pnA.tag == kTankerTag) {
                    
                }
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




/* EXAMPLE CODE
 
 DESTROY OBJECT AND CHANGE SCENE
 ----------------------------------
 - (void)destroyBrickAndCheckVictory:(PNode*)brick {
     [self.children removeObject:brick];
     [_bricks removeObject:brick];
 
     _world->removeRigidBody(brick.body);
 
     if (_bricks.count == 0) {
     [Director sharedInstance].scene = [[GameOver alloc] initWithShader:self.shader win:YES];
     }
 }
 
 
 MOVING THE PADDLE
 ----------------------------------
 float  newX = _paddle.position.x + diff.x;
 newX = MIN(MAX(newX, _paddle.width/2), _gameArea.width - _paddle.width/2);
 _paddle.position = GLKVector3Make(newX, _paddle.position.y, _paddle.position.z);
 
 
 CREATEING OBJECTS
 ----------------------------------
 //Create paddle and add to scene
 _paddle = [[RWTPaddle alloc] initWithShader:shader];
 _paddle.position = GLKVector3Make(_gameArea.width/2, _gameArea.height * .05, 0);
 _paddle.matColour = GLKVector4Make(1, 0, 0, 1);
 [self.children addObject:_paddle];
 _world->addRigidBody(_paddle.body);
 
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
