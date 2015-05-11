//
//  MenuViewController.m
//  Monopoly
//
//  Created by Andrew Raukut on 20.04.15.
//  Copyright (c) 2015 raukutsCorporation. All rights reserved.
//

#import "MNPMenuViewController.h"
#import "MNPSettingsViewController.h"
#import "MNPGameViewController.h"

#import "MNPDataManager.h"

@interface MNPMenuViewController ()

@property (strong, nonatomic) MNPDataManager *dataManager;

@end


@implementation MNPMenuViewController

- (void)viewDidLoad {
  
    [super viewDidLoad];
    _monopolyManImage.image = [UIImage imageNamed:@"monopoly-man.jpg"];
    self.dataManager = [MNPDataManager sharedManager];
}


- (IBAction)playButtonPressed:(id)sender {
    if (![_dataManager havePlayersInformation]) {

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
        MNPSettingsViewController *settingsViewController =
        [storyboard instantiateViewControllerWithIdentifier:@"settingsViewController"];

        settingsViewController.openGameBoardAfterSaving = YES;

        [self presentViewController:settingsViewController animated:YES completion:nil];
    } else {

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:nil];
        MNPGameViewController *gameViewController =
        [storyboard instantiateViewControllerWithIdentifier:@"gameViewController"];


        [self presentViewController:gameViewController animated:YES completion:nil];
    }
}

- (IBAction)settingsButtonPressed:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    MNPSettingsViewController *settingsViewController =
    [storyboard instantiateViewControllerWithIdentifier:@"settingsViewController"];
    settingsViewController.openGameBoardAfterSaving = NO;

    [self presentViewController:settingsViewController animated:YES completion:nil];

}

@end
