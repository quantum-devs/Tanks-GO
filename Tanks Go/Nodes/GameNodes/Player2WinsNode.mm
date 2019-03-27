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

- (id)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super initWithName:"Player2Wins"
                               mass:0.0f
                             convex:YES
                                tag:kPlayer2WinsTag
                             shader:shader
                           vertices:(Vertex *)Player2Wins_CUText_Player2Wins_Vertices
                        vertexCount:sizeof(Player2Wins_CUText_Player2Wins_Vertices)/sizeof(Player2Wins_CUText_Player2Wins_Vertices[0])
                        textureName:@"Player2Wins.png"
                     specularColour:Player2Wins_CUText_Player2Wins_specular
                      diffuseColour:Player2Wins_CUText_Player2Wins_diffuse
                          shininess:Player2Wins_CUText_Player2Wins_shininess])) {
        self.width = 5;
        self.height = 5;
        self.scale = 5;
        
    }
    return self;
}

@end
