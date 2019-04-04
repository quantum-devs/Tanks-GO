//
//  HighscoreViewController.m
//  Tanks Go
//
//  Created by Student on 2019-04-01.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//
#import "AppDelegate.h"
#import "HighscoreViewController.h"
#import "HighscoreMO.h"

@interface HighscoreViewController ()
@property (weak, nonatomic) IBOutlet UILabel *name1;
@property (weak, nonatomic) IBOutlet UILabel *name2;
@property (weak, nonatomic) IBOutlet UILabel *name3;
@property (weak, nonatomic) IBOutlet UILabel *name4;
@property (weak, nonatomic) IBOutlet UILabel *name5;
@property (weak, nonatomic) IBOutlet UILabel *score1;
@property (weak, nonatomic) IBOutlet UILabel *score2;
@property (weak, nonatomic) IBOutlet UILabel *score3;
@property (weak, nonatomic) IBOutlet UILabel *score4;
@property (weak, nonatomic) IBOutlet UILabel *score5;
@property (nonatomic) int gameHighscore;

@property (strong, nonnull) NSArray* nameLabels;
@property (strong, nonnull) NSArray* scoreLabels;
@property (strong, nonnull) NSArray* names;
@property (strong, nonnull) NSArray* scores;
@property (strong, nonnull) NSDictionary* highscores;
@property (strong, nonatomic) NSString* highScoreName;
@property (strong, readonly) NSManagedObjectContext* context;
@end

@implementation HighscoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    _gameHighscore = 0;
    //[self deleteAllHighscores];
    [self createNameLabelsArray];
    [self createScoreLabelsArray];
    [self populateHighscoreArrays];
}

- (void)viewDidAppear:(BOOL)animated {
   [self presentNewHighscoreAlert];

}

- (void)presentNewHighscoreAlert {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: [NSString stringWithFormat:@"%@ %d!!!",@"New Highscore", _gameHighscore]                                                                              message: @"Enter a name"                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        //textfields[0]
        UITextField *nameTextField = textfields.firstObject;
        NSString *name = nameTextField.text;
        //self->_highscores = textfields[0];
        NSLog(@"%@",name);
        [self insertHighscoreWithScore:[NSNumber numberWithInt:self->_gameHighscore] name:name];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)populateHighscoreArrays {
    NSLog(@"%@", @"populateHighscoreArrays Enter");
    
    NSMutableArray * scores = [NSMutableArray array];
    NSMutableArray * names = [NSMutableArray array];
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Highscore"];
    NSSortDescriptor *scoreSort = [NSSortDescriptor sortDescriptorWithKey:@"highscore" ascending:NO];
    [request setSortDescriptors:@[scoreSort]];
    request.returnsObjectsAsFaults = false;
    NSError *error = nil;
    NSArray *results = [_context executeFetchRequest:request error:nil];
    NSUInteger count = [_context countForFetchRequest:request error:nil];
    
    if (!results) {
        NSLog(@"Error fetching Highscore objects: %@\n%@ %lu", [error localizedDescription], [error userInfo], (unsigned long)count);
        //abort();
    } else {
        for (HighscoreMO *hs in results) {
            NSNumber * hsNum = [NSNumber numberWithInteger:hs.highscore];
            [scores addObject: hsNum];
            [names addObject:hs.name];
            //NSLog(@"%ld %@",(long)hs.highscore, hs.name);
        }
    
    
        if (results.count > 5) {
            for (int i = 5; i < results.count; ++i) {
                NSNumber * hsNum = [NSNumber numberWithInteger:((HighscoreMO *)results[i]).highscore];
                [self deleteHighscoreWithScore:hsNum name:((HighscoreMO *)results[i]).name];
                //NSLog(@"%ld %@",(long)((HighscoreMO *)results[i]).highscore, ((HighscoreMO *)results[i]).name);
            }
        }
        _scores = scores;
        _names = names;
        NSLog(@"%lu %lu", (unsigned long)_scores.count, (unsigned long)_names.count);
    }
    [self updateScoreAndNameLabels];
    NSLog(@"%@", @"populateHighscoreArrays Exit");
    
}

- (void)updateScoreAndNameLabels {
    NSLog(@"%@", @"updateScoreAndNameLabels Enter");
    int j = 1;
    for (int i = 0; i < _nameLabels.count; ++i) {
        if (_scores != nil && i < _scores.count ) {
            //NSLog(@"%@ %@", _scores[i], _names[i]);
            ((UILabel *)_scoreLabels[i]).text = [NSString stringWithFormat:@"%@", _scores[i]];
            ((UILabel *)_nameLabels[i]).text = [NSString stringWithFormat:@"%@", _names[i]];
        } else {
            ((UILabel *)_scoreLabels[i]).text = [NSString stringWithFormat:@"%d", 0];
            ((UILabel *)_nameLabels[i]).text = [NSString stringWithFormat:@"%@ %d", @"Lazy Person", j];
            ++j;
        }
    }
    NSLog(@"%@", @"updateScoreAndNameLabels Exit");
}

- (void)insertHighscoreWithScore:(NSNumber*) score name:(NSString*) name {
    NSLog(@"%@", @"Inserting highscore Enter");
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Highscore" inManagedObjectContext:_context];
    
    NSManagedObject *highscoreObj = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:_context];
    
    [highscoreObj setValue:score forKey:@"highscore"];
    [highscoreObj setValue:name forKey:@"name"];
    [_context save:nil];
    
    [self populateHighscoreArrays];
    
    NSLog(@"%@", @"Inserting highscore Exit");
}


- (void)deleteHighscoreWithScore:(NSNumber*) score name:(NSString*) name {
    NSLog(@"%@", @"Deleting highscore Enter");
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Highscore" inManagedObjectContext:_context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"highscore == %@ AND name == %@", score, name];
    NSArray *fetchedObjects = [_context executeFetchRequest:fetchRequest error:nil];
    for (HighscoreMO *currentObject in fetchedObjects) {
        [_context deleteObject:currentObject];
    }
    [_context save:nil];
    
    NSLog(@"%@", @"Deleting highscore Exit");
}

- (void)deleteAllHighscores {
    NSLog(@"%@", @"deleteAllHighscores Enter");
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Highscore" inManagedObjectContext:_context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [_context executeFetchRequest:fetchRequest error:nil];
    for (HighscoreMO *currentObject in fetchedObjects) {
        [_context deleteObject:currentObject];
    }
    [_context save:nil];
    
    NSLog(@"%@", @"deleteAllHighscores Exit");
}


- (BOOL)descending:(id)obj1 id2:(id)obj2 {
    return [obj2 compare:obj1];
}

- (void)createNameLabelsArray {
    NSMutableArray * nameLabels = [NSMutableArray array];
    [nameLabels addObject:_name1];
    [nameLabels addObject:_name2];
    [nameLabels addObject:_name3];
    [nameLabels addObject:_name4];
    [nameLabels addObject:_name5];
    _nameLabels = [NSArray arrayWithArray: nameLabels];
};

- (void)createScoreLabelsArray {
    NSMutableArray *scoreLabels = [NSMutableArray array];
    [scoreLabels addObject:_score1];
    [scoreLabels addObject:_score2];
    [scoreLabels addObject:_score3];
    [scoreLabels addObject:_score4];
    [scoreLabels addObject:_score5];
    _scoreLabels = [NSArray arrayWithArray:scoreLabels];
};

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
