//
//  MainMenuViewController.h
//  Tanks Go
//
//  Created by Renz on 2/22/19.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Director.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainMenuViewController : UIViewController

@property (strong, nonatomic) NSPersistentContainer *container;

@end

NS_ASSUME_NONNULL_END
