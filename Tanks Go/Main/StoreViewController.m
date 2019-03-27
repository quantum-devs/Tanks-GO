//
//  StoreViewController.m
//  Tanks Go
//
//  Created by Jason Sekhon on 2019-03-26.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "StoreViewController.h"

@interface StoreViewController () {
    __weak IBOutlet UILabel *_playerOneFuel;
    __weak IBOutlet UILabel *_playerOneHealth;
    __weak IBOutlet UILabel *_playerTwoFuel;
    __weak IBOutlet UILabel *_playerTwoHealth;
    __weak IBOutlet UIButton *_playerOneFuelBtn;
    __weak IBOutlet UIButton *_playerOneHealthBtn;
    __weak IBOutlet UIButton *_playerTwoFuelBtn;
    __weak IBOutlet UIButton *_playerTwoHealthBtn;
    BOOL playerOneBought;
    BOOL playerTwoBought;
}

@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    playerOneBought = false;
    playerTwoBought = false;
    
    _playerOneFuel.text = [NSString stringWithFormat:@"%1.0f", [Director sharedInstance].playerOneFuel];
    _playerTwoFuel.text = [NSString stringWithFormat:@"%1.0f", [Director sharedInstance].playerTwoFuel];
    _playerOneHealth.text = [NSString stringWithFormat:@"%1.0f", [Director sharedInstance].playerOneHealth];
    _playerTwoHealth.text = [NSString stringWithFormat:@"%1.0f", [Director sharedInstance].playerTwoHealth];
    
    [Director sharedInstance].round++;
    
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    [EAGLContext setCurrentContext:view.context];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(.5, .5, 1, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

- (IBAction)playerOneFuelBtn:(id)sender {
    if (!playerOneBought){
        [Director sharedInstance].playerOneFuel++;
        _playerOneFuel.text = [NSString stringWithFormat:@"%1.0f", [Director sharedInstance].playerOneFuel];
        [self hidePlayerOneUI:YES];
    }
}

- (IBAction)playerOneHealthBtn:(id)sender {
    if (!playerOneBought){
        [Director sharedInstance].playerOneHealth++;
        _playerOneHealth.text = [NSString stringWithFormat:@"%1.0f", [Director sharedInstance].playerOneHealth];
        [self hidePlayerOneUI:YES];
    }
}

- (IBAction)playerTwoFuelBtn:(id)sender {
    if (!playerTwoBought){
        [Director sharedInstance].playerTwoFuel++;
        _playerTwoFuel.text = [NSString stringWithFormat:@"%1.0f", [Director sharedInstance].playerTwoFuel];
        [self hidePlayerTwoUI:YES];
    }
}

- (IBAction)playerTwoHealthBtn:(id)sender {
    if (!playerTwoBought){
        [Director sharedInstance].playerTwoHealth++;
        _playerTwoHealth.text = [NSString stringWithFormat:@"%1.0f", [Director sharedInstance].playerTwoHealth];
        [self hidePlayerTwoUI:YES];
    }
}

- (void)hidePlayerTwoUI:(BOOL)hideUI {
    [_playerTwoFuelBtn setHidden:hideUI];
    [_playerTwoHealthBtn setHidden:hideUI];
}

- (void)hidePlayerOneUI:(BOOL)hideUI {
    [_playerOneFuelBtn setHidden:hideUI];
    [_playerOneHealthBtn setHidden:hideUI];
}

@end
