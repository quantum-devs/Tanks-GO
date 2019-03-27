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

- (id)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super initWithName:"Player1Wins"
                               mass:0.0f
                             convex:YES
                                tag:kPlayer1WinsTag
                             shader:shader
                           vertices:(Vertex *)Player1Wins_CUText_Player1Wins_Vertices
                        vertexCount:sizeof(Player1Wins_CUText_Player1Wins_Vertices)/sizeof(Player1Wins_CUText_Player1Wins_Vertices[0])
                        textureName:@"Player1Wins.png"
                     specularColour:Player1Wins_CUText_Player1Wins_specular
                      diffuseColour:Player1Wins_CUText_Player1Wins_diffuse
                          shininess:Player1Wins_CUText_Player1Wins_shininess])) {
        self.width = 5;
        self.height = 5;
        self.scale = 5;
        
    }
    return self;
}

@end
