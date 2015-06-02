//
//  MNPSummaryViewController.m
//  Monopoly
//
//  Created by Andrew Raukut on 01.06.15.
//  Copyright (c) 2015 raukutsCorporation. All rights reserved.
//

#import "MNPSummaryViewController.h"
#import "MNPGameManager.h"

#import "MNPPlayer.h"
#import "MNPMenuViewController.h"

@interface MNPSummaryViewController ()

@property (strong, nonatomic) MNPGameManager *gameManager;

@end

@implementation MNPSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gameManager = [MNPGameManager sharedManager];
    MNPPlayer *winner = [_gameManager getCurrentPlayerInfo];

    self.winnerName.text = winner.playerName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)playAgainButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    MNPMenuViewController *menuViewController =
    [storyboard instantiateViewControllerWithIdentifier:@"menuViewController"];

    //[self dismissViewControllerAnimated:NO completion:nil];
    [self presentViewController:menuViewController animated:YES completion:nil];
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
