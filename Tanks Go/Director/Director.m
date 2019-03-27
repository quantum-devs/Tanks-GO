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

@end
