//
//  Player1WinsNode.m
//  Tanks Go
//
//  Created by Renz on 3/26/19.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "Player1WinsNode.h"
#import "Player1Wins.h"

@implementation Player1WinsNode

- (instancetype)initWithShader:(BaseEffect *)shader {
    if ((self = [super initWithName:"Player1Wins" shader:shader vertices:(Vertex *)Player1Wins_CUText_Player1Wins_Vertices vertexCount:sizeof(Player1Wins_CUText_Player1Wins_Vertices)/sizeof(Player1Wins_CUText_Player1Wins_Vertices[0]) tag:0])) {
        self.width = 5;
        self.height = 5;
        self.scale = 5;
    }
    return self;
}

@end
