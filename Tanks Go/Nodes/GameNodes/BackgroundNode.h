//
//  BackgroundNode.h
//  Tanks Go
//
//  Created by Jason Sekhon on 2019-03-24.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "Node.h"

NS_ASSUME_NONNULL_BEGIN

@interface BackgroundNode : Node

- (instancetype)initWithShader:(BaseEffect *)shader;

@end

NS_ASSUME_NONNULL_END
