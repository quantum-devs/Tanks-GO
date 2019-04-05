//
//  GameScene.h
//  Tanks Go
//
//  Created by Jason Sekhon on 2019-02-20.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "Node.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameScene : Node

- (instancetype)initWithShader:(BaseEffect *)shader;
- (void)launchBallWithVelocity:(float)X velocityY:(float)Y atAngle:(float)angle;
- (BOOL)isBallActive;
- (void)changeAnglerWidth: (float)vel;
- (void)changeAnglerAngle: (float) angle;
- (void)moveTankLeft;
- (void)moveTankRight;
- (float)getPlayerOneMovesLeft;
- (float)getPlayerTwoMovesLeft;
- (float)getPlayerOneHealth;
- (float)getPlayerTwoHealth;
- (float)checkVictory;
- (CGPoint) touchLocationToGameArea:(CGPoint)touchLocation;

@property (nonatomic, assign) BOOL gameStart;
@property (nonatomic, assign) BOOL playerOneTurn;
@property (nonatomic, assign) BOOL ballExists;
@property (strong) NSMutableArray *fuel;
@property (strong) NSMutableArray *health;
@property (strong, nonatomic) NSPersistentContainer *container;

@end

NS_ASSUME_NONNULL_END
