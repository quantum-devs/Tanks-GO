//
//  BackgroundNode.h
//  Tanks Go
//
//  Created by Jason Sekhon on 2019-03-24.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "PNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface BackgroundNode : PNode

- (instancetype)initWithShader:(BaseEffect *)shader;

@end

NS_ASSUME_NONNULL_END
