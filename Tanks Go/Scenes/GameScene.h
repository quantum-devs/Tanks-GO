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

@end

NS_ASSUME_NONNULL_END
