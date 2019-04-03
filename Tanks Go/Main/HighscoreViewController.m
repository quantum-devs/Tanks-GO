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
@property (nonatomic) int newHighscore;

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
    _newHighscore = 0;
    [self createNameLabelsArray];
    [self createScoreLabelsArray];
    [self populateHighscoreDictionary];
    /*
    for (int i = 0; i < _highscores.count; ++i) {
        
    }
     */
}

- (void)viewDidAppear:(BOOL)animated {
   //[self presentNewHighscoreAlert];

}

- (void)presentNewHighscoreAlert {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: [NSString stringWithFormat:@"%@ %d!!!",@"New Highscore", _newHighscore]                                                                              message: @"Enter a name"                                                                       preferredStyle:UIAlertControllerStyleAlert];
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
        [self insertHighscoreWithScore:[NSNumber numberWithInt:self->_newHighscore] name:name];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

//- (void)

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)populateHighscoreDictionary {
    //_scores = [[NSArray init] alloc];
    //_scores = [NSArray arrayWithObjects: @"0",@"0",@"0",@"0",@"0", nil];
    //NSLog(@"%@,%@,%@,%@,%@", sc[0], sc[1], sc[2], sc[3], sc[4]);
    //_names =  [NSArray arrayWithObjects: @"Lazy Person 1",@"Lazy Person 2",@"Lazy Person 3",@"Lazy Person 4",@"Lazy Person 5", nil];
    NSMutableArray * scores = [NSMutableArray array];
    NSMutableArray * names = [NSMutableArray array];
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Highscore"];
    NSSortDescriptor *scoreSort = [NSSortDescriptor sortDescriptorWithKey:@"highscore" ascending:NO];
    [request setSortDescriptors:@[scoreSort]];
    request.returnsObjectsAsFaults = false;
    NSError *error = nil;
    NSArray *results = [_context executeFetchRequest:request error:nil];
    NSUInteger count = [_context countForFetchRequest:request error:nil];
    //NSLog (@"%@", results);
    /*
    for (int i = 0; i < results.count; ++i) {
        NSLog(@"%@",results[i]);
    }
     */
    
    for (HighscoreMO *hs in results) {
        NSNumber * hsNum = [NSNumber numberWithInteger:hs.highscore];
        [scores addObject: hsNum];
        [names addObject:hs.name];
        NSLog(@"%ld %@",hs.highscore, hs.name);
    }
    
    /*
    if (results.count > 5) {
        for (int i = 5; i < results.count; ++i) {
            //NSNumber * hsNum = hs.highscore;
            //[scores addObject: (HighscoreMO *)(results[i]).highscore];
            //[names addObject: (HighscoreMO *)(results[i]).name];
            //NSLog(@"%@ %@",((HighscoreMO *)results[i]).highscore, ((HighscoreMO *)results[i]).name);
        }
    }
     */
    if (!results) {
        NSLog(@"Error fetching Highscore objects: %@\n%@ %lu", [error localizedDescription], [error userInfo], (unsigned long)count);
        //abort();
    }
    _scores = scores;
    _names = names;
    NSLog(@"%d %d", _scores.count, _names.count);
    //_highscores = [NSDictionary dictionaryWithObjects:na forKeys:sc count:5];
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"intValue" ascending:NO];
    //sortDescriptor = [sortDescriptor reversedSortDescriptor];
    //NSArray * sortedKeys = [[_highscores allKeys] sortedArrayUsingDescriptors: @[sortDescriptor]];
    //NSLog(@"%@,%@,%@,%@,%@", sortedKeys[0], sortedKeys[1], sortedKeys[2], sortedKeys[3], sortedKeys[4]);

/*
    NSArray * sortedKeys = [[_highscores allKeys] sortedArrayUsingComparator: ^(id obj1, id obj2) {
        // Switching the order of the operands reverses the sort direction
        return -[obj2 compare:obj1];
    }];
    */
    /*NSArray * sortedKeys = [[_highscores allKeys] sortedArrayUsingSelector:@selector(descending:id2:)];*/
    int j = 1;
    for (int i = 0; i < _nameLabels.count; ++i) {
        NSLog(@"%@ %@", _scores[i], _names[i]);
        if (_scores.count > i) {
            ((UILabel *)_scoreLabels[i]).text = [NSString stringWithFormat:@"%@", _scores[i]];
            ((UILabel *)_nameLabels[i]).text = [NSString stringWithFormat:@"%@", _names[i]];
        } else {
            //((UILabel *)_scoreLabels[i]).text = [NSString stringWithFormat:@"%d", 0];
            //((UILabel *)_nameLabels[i]).text = [NSString stringWithFormat:@"%@ %d", @"Lazy Person", j];
            ++j;
        }
        //((UILabel *)_nameLabels[i]).text = @"Lazy Person";
        //[_highscores add]
    }
    
}

- (void)insertHighscoreWithScore:(NSNumber*) score name:(NSString*) name {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Highscore" inManagedObjectContext:_context];
    
    // Initialize Record
    //NSManagedObject *record = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];

    //NSManagedObject *highscoreObj = [NSEntityDescription insertNewObjectForEntityForName:@"Highscore" inManagedObjectContext:_context];
    NSManagedObject *highscoreObj = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:_context];

    [highscoreObj setValue:score forKey:@"highscore"];
    [highscoreObj setValue:name forKey:@"name"];
    [_context save:nil];
    NSLog(@"%@", @"Inserting highscore");
    /*
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Highscore"];
    
    request.returnsObjectsAsFaults = false;
    NSError *error = nil;
    NSArray *results = [_context executeFetchRequest:request error:nil];
    NSUInteger count = [_context countForFetchRequest:request error:nil];
    NSLog (@"%@", results);
     */
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
    for (int i = 0; i < _nameLabels.count; ++i) {
       // ((UILabel *)_nameLabels[i]).text = @"Lazy Person";
    }
};

- (void)createScoreLabelsArray {
    NSMutableArray *scoreLabels = [NSMutableArray array];
    [scoreLabels addObject:_score1];
    [scoreLabels addObject:_score2];
    [scoreLabels addObject:_score3];
    [scoreLabels addObject:_score4];
    [scoreLabels addObject:_score5];
    _scoreLabels = [NSArray arrayWithArray:scoreLabels];
    for (int i = 0; i < _scoreLabels.count; ++i) {
        //((UILabel *)_scoreLabels[i]).text = [NSString stringWithFormat:@"%d", 1000 - i * 100];
    }
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
