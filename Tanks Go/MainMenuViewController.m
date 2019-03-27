//
//  MainMenuViewController.m
//  Tanks Go
//
//  Created by Renz on 2/22/19.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController {
    __weak IBOutlet UIImageView *_backgroundImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    NSManagedObjectContext *context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSManagedObject *fuelObj = [NSEntityDescription insertNewObjectForEntityForName:@"Fuel" inManagedObjectContext:context];
    [fuelObj setValue:[NSNumber numberWithFloat: 5] forKey:@"fuel"];
    [fuelObj setValue:[NSNumber numberWithFloat: 1] forKey:@"player"];
    
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) saveContext];
    */
    
    [Director sharedInstance].playerOneFuel = 5.0f;
    [Director sharedInstance].playerTwoFuel = 5.0f;
    [Director sharedInstance].playerOneHealth = 5.0f;
    [Director sharedInstance].playerTwoHealth = 0.0f;
    _backgroundImage.layer.zPosition = -99;
    // Do any additional setup after loading the view.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
