//
//  HighscoreMO.h
//  Tanks Go
//
//  Created by Morris Arroyo on 2019-04-03.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface HighscoreMO : NSManagedObject

@property (nonatomic) NSInteger highscore;

@property (nonatomic, strong) NSString *name;

@end

NS_ASSUME_NONNULL_END
