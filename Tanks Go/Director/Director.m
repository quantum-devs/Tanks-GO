//
//  Director.m
//  Tanks Go
//
//  Created by Jason Sekhon on 2019-02-20.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "Director.h"

@implementation Director {
    AVAudioPlayer *_backgroundMusicPlayer;
    AVAudioPlayer *_popEffect;
    AVAudioPlayer *_launchEffect;
    AVAudioPlayer *_collisionEffect;
    AVAudioPlayer *_hurtEffect;
    AVAudioPlayer *_purchase1Effect;
    AVAudioPlayer *_purchase2Effect;

}

+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static Director *_sharedInstance;
    dispatch_once(&pred, ^{ _sharedInstance = [[self alloc] init];});
    return _sharedInstance;
}

- (instancetype)init {
    if ((self = [super init])) {
        _popEffect = [self preloadSoundEffect:@"pop.wav"];
        _launchEffect = [self preloadSoundEffect:@"Explosion+1.mp3"];
        _collisionEffect = [self preloadSoundEffect:@"Explosion+7.mp3"];
        _hurtEffect = [self preloadSoundEffect:@"classic_hurt.mp3"];
        _purchase1Effect = [self preloadSoundEffect:@"purchase.wav"];
        _purchase2Effect = [self preloadSoundEffect:@"purchase.wav"];
        _playingMusic = NO;
    }
    return self;
}

- (void)playBackgroundMusic:(NSString *)filename {
    _backgroundMusicPlayer = [self preloadSoundEffect:filename];
    _backgroundMusicPlayer.numberOfLoops = -1;
    [_backgroundMusicPlayer play];
}
- (void)stopBackgroundMusic {
    [_backgroundMusicPlayer stop];
}

- (AVAudioPlayer *)preloadSoundEffect:(NSString *)filename {
    NSURL *URL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    AVAudioPlayer *retval = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:nil];
    [retval prepareToPlay];
    return retval;
}

- (void)playPopEffect {
    [_popEffect play];
}

- (void)playLaunchEffect {
    [_launchEffect play];
}

- (void)playCollisionEffect {
    [_collisionEffect play];
}

- (void)playHurtEffect {
    [_hurtEffect play];
}

- (void)playPurchase1Effect {
    [_purchase1Effect play];
}

- (void)playPurchase2Effect {
    [_purchase2Effect play];
}

@end
