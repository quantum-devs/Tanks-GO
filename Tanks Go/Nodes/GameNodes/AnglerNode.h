//
//  AnglerNode.h
//  Tanks Go
//
//  Created by Renz on 3/25/19.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "Node.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnglerNode : Node

- (instancetype) initWithShader:(BaseEffect *)shader;

@end

NS_ASSUME_NONNULL_END
