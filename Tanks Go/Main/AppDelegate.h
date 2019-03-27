//
//  AppDelegate.h
//  Tanks Go
//
//  Created by Jason Sekhon on 2019-02-08.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end

