//
//  Player2WinsNode.m
//  Tanks Go
//
//  Created by Renz on 3/26/19.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "Player2WinsNode.h"
#import "Player2Wins.h"

@implementation Player2WinsNode

- (instancetype)initWithShader:(BaseEffect *)shader {
    if ((self = [super initWithName:"Player2Wins" shader:shader vertices:(Vertex *)Player2Wins_CUText_Player2Wins_Vertices vertexCount:sizeof(Player2Wins_CUText_Player2Wins_Vertices)/sizeof(Player2Wins_CUText_Player2Wins_Vertices[0]) tag:0])) {
        self.width = 5;
        self.height = 5;
        self.scale = 5;
    }
    return self;
}

@end
