//
//  Model.h
//  Tanks Go
//
//  Created by Jason Sekhon on 2019-02-12.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vertex.h"

@class BaseEffect;
@import GLKit;

@interface Node : NSObject

@property (nonatomic, strong) BaseEffect *shader;
@property (nonatomic, assign) GLKVector3 position;
@property (nonatomic) float rotationX;
@property (nonatomic) float rotationY;
@property (nonatomic) float rotationZ;
@property (nonatomic) float scale;
@property (nonatomic) GLKTextureInfo* texture;
@property (assign) GLKVector4 matColour;
@property (assign) float width;
@property (assign) float height;

@property (nonatomic, strong) NSMutableArray *children;

- (instancetype)initWithName:(char *)name shader:(BaseEffect *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount;
- (void)renderWithParentModelViewMatrix:(GLKMatrix4)parentModelViewMatrix;
- (void)updateWithDelta:(NSTimeInterval)dt;
- (void)loadTexture:(NSString *)fileName;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end

