//
//  GameOver.h
//  Tanks Go
//
//  Created by Jason Sekhon on 2019-02-21.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "Node.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameOver : Node

- (instancetype)initWithShader:(BaseEffect *)shader win:(BOOL)win;

@end

NS_ASSUME_NONNULL_END
