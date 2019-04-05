//
//  Model.h
//  Tanks Go
//
//  Created by Jason Sekhon on 2019-02-12.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vertex.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import <GLKit/GLKit.h>

@class BaseEffect;

#define kBallTag    1
#define kBrickTag   2
#define kPaddleTag  3
#define kBorderTag  4
#define kPanzerTag  5
#define kFloorTag   6
#define kTankerTag  7
#define kBoxTag     8
#define kTank1Tag   9
#define kTank2Tag   10
#define kBackgroundTag   11
#define kAnglerTag  12
#define kParachuteTag   13
#define kPlayer1WinsTag 14
#define kPlayer2WinsTag 15
#define kTrailParticle 16

@interface Node : NSObject

@property (nonatomic, strong) BaseEffect *shader;
@property (nonatomic, assign) GLKVector3 position;
@property (nonatomic) float rotationX;
@property (nonatomic) float rotationY;
@property (nonatomic) float rotationZ;
@property (nonatomic) float scale;
@property (nonatomic) GLKTextureInfo* texture;
@property (assign) GLKVector4 matColour;
@property (nonatomic, assign) GLKVector4 specularColor;
@property (nonatomic, assign) GLKVector4 diffuseColor;
@property (nonatomic, assign) float shininess;
@property (assign) float width;
@property (assign) float height;

@property (nonatomic, strong) NSMutableArray *children;
@property (nonatomic, assign) NSInteger tag;

- (instancetype)initWithName:(char *)name shader:(BaseEffect *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount tag:(unsigned int)tag;
- (instancetype)initWithName:(char *)name shader:(BaseEffect *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount textureName:(NSString *)textureName specularColor:(GLKVector4)specularColor diffuseColor:(GLKVector4)diffuseColor shininess:(float)shininess tag:(int)tag;
- (void)renderWithParentModelViewMatrix:(GLKMatrix4)parentModelViewMatrix;
- (void)updateWithDelta:(GLfloat)dt;
- (void)loadTexture:(NSString *)fileName;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (CGRect) boundingBoxWithModelViewMatrix:(GLKMatrix4)parentModelViewMatrix;

@end

