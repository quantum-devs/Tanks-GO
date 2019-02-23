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
- (void)playBackgroundMusic:(NSString *)filename;
- (AVAudioPlayer *)preloadSoundEffect:(NSString *)filename;
- (void)playPopEffect;

@end

NS_ASSUME_NONNULL_END
