//
//  ViewController.m
//  Tanks Go
//
//  Created by Jason Sekhon on 2019-02-08.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "ViewController.h"
#import "Vertex.h"
#import "BaseEffect.h"
#import "GameScene.h"
#import "GameOver.h"
#import "Director.h"
#import "ASValueTrackingSlider.h"
#import "ASValuePopUpView.h"

@interface ViewController ()

@end

@implementation ViewController {
    BaseEffect *_shader;
    GameScene *_scene;
    CGPoint _prevTouchLocation;
    //__weak IBOutlet UISlider *_launchVelocitySlider;
    //__weak IBOutlet UISlider *_launchAngleSlider;
    __weak IBOutlet ASValueTrackingSlider *_launchVelocitySlider;
    __weak IBOutlet ASValueTrackingSlider *_launchAngleSlider;
    __weak IBOutlet UIButton *_launchBtn;
    __weak IBOutlet UILabel *_gasLabel;
    __weak IBOutlet ASValueTrackingSlider *_playerOneHealthSlider;
    __weak IBOutlet ASValueTrackingSlider *_playerTwoHealthSlider;
    __weak IBOutlet UIImageView *_gasolineImg;
    __weak IBOutlet UIButton *_moveRightImg;
    __weak IBOutlet UIButton *_moveLeftImg;
    __weak IBOutlet UIImageView *_velocityImg;
    __weak IBOutlet UIImageView *_angleImg;
    __weak IBOutlet UIButton *_healthImg;
    __weak IBOutlet UIButton *_healthImg2;
}

- (void) setupScene{
    
    [Director sharedInstance].view = self.view;
    [[Director sharedInstance] playBackgroundMusic:@"seaShanty2.mp3"];
    
    _shader = [[BaseEffect alloc] initWithVertexShader:@"SimpleVertex.glsl"
                                        fragmentShader:@"SimpleFragment.glsl"];
    _scene = [[GameScene alloc] initWithShader:_shader];
    _shader.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0), self.view.bounds.size.width / self.view.bounds.size.height, 1, 150);
    
    [Director sharedInstance].scene = _scene;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_gasLabel setTextColor:[UIColor colorWithRed:fabsf(_gasLabel.text.floatValue-5)/5 green:.25 blue:0 alpha:1]];
    
    _launchVelocitySlider.popUpViewAnimatedColors = @[[UIColor greenColor], [UIColor redColor]];
    [_launchVelocitySlider setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    
    _launchAngleSlider.popUpViewAnimatedColors = @[[UIColor greenColor], [UIColor redColor]];
    [_launchAngleSlider setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    
    _playerOneHealthSlider.popUpViewAnimatedColors = @[[UIColor redColor]];
    _playerTwoHealthSlider.popUpViewAnimatedColors = @[[UIColor whiteColor]];
    
    [_playerOneHealthSlider setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    [_playerTwoHealthSlider setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    
    [self setStoreEnabled:NO];
    
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    [EAGLContext setCurrentContext:view.context];
    
    [self setupScene];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    //glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    GLKMatrix4 viewMatrix = GLKMatrix4Identity;
    [[Director sharedInstance].scene renderWithParentModelViewMatrix:viewMatrix];
}

- (void)update {
    [[Director sharedInstance].scene updateWithDelta:self.timeSinceLastUpdate];
    if ([_scene playerOneTurn])
        [_gasLabel setText:[NSString stringWithFormat:@"%1.0f", [Director sharedInstance].playerOneFuel]];
    else
        [_gasLabel setText:[NSString stringWithFormat:@"%1.0f", [Director sharedInstance].playerTwoFuel]];
    [_gasLabel setTextColor:[UIColor colorWithRed:fabsf(_gasLabel.text.floatValue-5)/5 green:.25 blue:0 alpha:1]];
    [_playerOneHealthSlider setValue:[_scene getPlayerOneHealth]];
    [_playerTwoHealthSlider setValue:[_scene getPlayerTwoHealth]];
    if ([_scene gameStart])
        [self hideUI:FALSE];
    float checkVictory = [_scene checkVictory];
    if (checkVictory == 1) {
        [self reinitializeUI];
        [self hideUI:TRUE];
    } else if(checkVictory == 2) {
        [self reinitializeUI];
        [self hideUI:TRUE];
    }
    if ([[Director sharedInstance].scene isKindOfClass:[GameOver class]])
        if (((GameOver *)[Director sharedInstance].scene).storeEnabled)
            [self segueToStore];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[Director sharedInstance].scene touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:[Director sharedInstance].view];
    _prevTouchLocation = [_scene touchLocationToGameArea:touchLocation];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[Director sharedInstance].scene touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:[Director sharedInstance].view];
    touchLocation = [_scene touchLocationToGameArea:touchLocation];
    CGPoint diff = CGPointMake(touchLocation.x - _prevTouchLocation.x, touchLocation.y - _prevTouchLocation.y);
    _prevTouchLocation = touchLocation;
    if (fabs(diff.y) > fabs(diff.x)){
        _launchVelocitySlider.value += diff.y;
    } else if (fabs(diff.x) > fabs(diff.y)) {
        _launchAngleSlider.value += diff.x;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[Director sharedInstance].scene touchesEnded:touches withEvent:event];
}

- (void)hideUI:(BOOL)hideUI {
    [_launchAngleSlider setHidden:hideUI];
    [_launchVelocitySlider setHidden:hideUI];
    [_gasLabel setHidden:hideUI];
    [_playerOneHealthSlider setHidden:hideUI];
    [_playerTwoHealthSlider setHidden:hideUI];
    [_launchBtn setHidden:hideUI];
    [_gasolineImg setHidden:hideUI];
    [_angleImg setHidden:hideUI];
    [_healthImg setHidden:hideUI];
    [_healthImg2 setHidden:hideUI];
    [_velocityImg setHidden:hideUI];
    [_moveLeftImg setHidden:hideUI];
    [_moveRightImg setHidden:hideUI];
}

- (void)reinitializeUI {
    [_launchAngleSlider setValue:90];
    [_launchVelocitySlider setValue:50];
    [_gasLabel setText:[NSString stringWithFormat:@"%1.0f", [Director sharedInstance].playerOneFuel]];
    [_playerOneHealthSlider setValue:0];
    [_playerTwoHealthSlider setValue:5];
}

- (void)segueToStore {
    [self performSegueWithIdentifier:@"storeSegue" sender:self];
}

- (IBAction)launchBtn:(id)sender {
    if (![_scene isBallActive]){
        [[Director sharedInstance] playPopEffect];
        float angle = GLKMathDegreesToRadians([_launchAngleSlider value]);
        float velocity = [_launchVelocitySlider value];
        float x = cosf(angle) * velocity;
        float y = sinf(angle) * velocity;
        [_scene launchBallWithVelocity:x velocityY:y atAngle:angle];
        [_launchAngleSlider setValue:90];
        [_launchVelocitySlider setValue:50];
    }
}

- (IBAction)moveLeftBtn:(id)sender {
    if (_gasLabel != 0)
        [_scene moveTankLeft];
}

- (IBAction)moveRightBtn:(id)sender {
    if (_gasLabel != 0)
        [_scene moveTankRight];
}

@end
