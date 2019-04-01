//
//  HighscoreViewController.m
//  Tanks Go
//
//  Created by Student on 2019-04-01.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "HighscoreViewController.h"

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
@property (strong, nonnull) NSArray* names;
@property (strong, nonnull) NSArray* scores;
@end

@implementation HighscoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNameLabelsArray];
    [self createScoreLabelsArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createNameLabelsArray {
    NSMutableArray *nameLabels = [NSMutableArray array];
    [nameLabels addObject:_name1];
    [nameLabels addObject:_name2];
    [nameLabels addObject:_name3];
    [nameLabels addObject:_name4];
    [nameLabels addObject:_name5];
    _names = [NSArray arrayWithArray:nameLabels];
    for (int i = 0; i < _names.count; ++i) {
        ((UILabel *)_names[i]).text = @"Lazy Person";
    }
};

- (void)createScoreLabelsArray {
    NSMutableArray *scoreLabels = [NSMutableArray array];
    [scoreLabels addObject:_score1];
    [scoreLabels addObject:_score2];
    [scoreLabels addObject:_score3];
    [scoreLabels addObject:_score4];
    [scoreLabels addObject:_score5];
    _scores = [NSArray arrayWithArray:scoreLabels];
    for (int i = 0; i < _scores.count; ++i) {
        ((UILabel *)_scores[i]).text = [NSString stringWithFormat:@"%d", 1000 - i * 100];
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
