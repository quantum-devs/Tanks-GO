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

@interface ViewController ()

@end

@implementation ViewController {
    BaseEffect *_shader;
    GameScene *_scene;
    __weak IBOutlet UISlider *_launchVelocitySlider;
    __weak IBOutlet UISlider *_launchAngleSlider;
    __weak IBOutlet UITextView *_launchVelocityLabel;
    __weak IBOutlet UITextView *_launchAngleLabel;
    __weak IBOutlet UIButton *_launchBtn;
}

- (void) setupScene{
    
    [Director sharedInstance].view = self.view;
    [[Director sharedInstance] playBackgroundMusic:@"bulletstorm_bg_v1.mp3"];
    
    _shader = [[BaseEffect alloc] initWithVertexShader:@"SimpleVertex.glsl"
                                        fragmentShader:@"SimpleFragment.glsl"];
    _scene = [[GameScene alloc] initWithShader:_shader];
    _shader.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0), self.view.bounds.size.width / self.view.bounds.size.height, 1, 150);
    
    [Director sharedInstance].scene = _scene;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_launchVelocityLabel setText:[NSString stringWithFormat:@"%3.2f", [_launchVelocitySlider value]]];
    [_launchAngleLabel setText:[NSString stringWithFormat:@"%3.2f", [_launchAngleSlider value]]];
    [_launchVelocitySlider setThumbImage:[UIImage imageNamed:@"thumb_image.png"] forState:UIControlStateNormal];
    [_launchVelocitySlider setThumbImage:[UIImage imageNamed:@"thumb_image.png"] forState:UIControlStateHighlighted];
    [_launchAngleSlider setThumbImage:[UIImage imageNamed:@"thumb_image.png"] forState:UIControlStateNormal];
    [_launchAngleSlider setThumbImage:[UIImage imageNamed:@"thumb_image.png"] forState:UIControlStateHighlighted];
    
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
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[Director sharedInstance].scene touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[Director sharedInstance].scene touchesMoved:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[Director sharedInstance].scene touchesEnded:touches withEvent:event];
}

- (IBAction)launchBtn:(id)sender {
    if (![_scene isBallActive]){
        float angle = GLKMathDegreesToRadians([_launchAngleSlider value]);
        float velocity = [_launchVelocitySlider value];
        float x = cosf(angle) * velocity;
        float y = sinf(angle) * velocity;
        [_scene launchBallWithVelocity:x velocityY:y atAngle:angle];
    }
}

- (IBAction)moveLeftBtn:(id)sender {
    [_scene moveTankLeft];
}

- (IBAction)moveRightBtn:(id)sender {
    [_scene moveTankRight];
}

- (IBAction)launchVelocitySliderChanged:(id)sender {
    [_launchVelocityLabel setText:[NSString stringWithFormat:@"%3.2f", [_launchVelocitySlider value]]];
}

- (IBAction)launchAngleSliderChanged:(id)sender {
    [_launchAngleLabel setText:[NSString stringWithFormat:@"%3.2f", [_launchAngleSlider value]]];
}

@end
