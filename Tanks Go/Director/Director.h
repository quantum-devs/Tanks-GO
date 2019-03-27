//
//  Director.h
//  Tanks Go
//
//  Created by Jason Sekhon on 2019-02-20.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class Node;

NS_ASSUME_NONNULL_BEGIN

@interface Director : NSObject

+ (instancetype)sharedInstance;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) Node *scene;
@property (assign) float playerOneHealth;
@property (assign) float playerTwoHealth;
@property (assign) float playerOneFuel;
@property (assign) float playerTwoFuel;
@property (assign) float round;
@property (assign) BOOL playingMusic;

- (void)playBackgroundMusic:(NSString *)filename;
- (AVAudioPlayer *)preloadSoundEffect:(NSString *)filename;
- (void)playPopEffect;
- (void)stopBackgroundMusic;

@end

NS_ASSUME_NONNULL_END
