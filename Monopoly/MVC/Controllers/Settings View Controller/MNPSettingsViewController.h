//
//  MNPSettingsViewController.h
//  Monopoly
//
//  Created by Andrew Raukut on 20.04.15.
//  Copyright (c) 2015 raukutsCorporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNPDataManager;

@interface MNPSettingsViewController : UIViewController

@property (assign, nonatomic) BOOL openGameBoardAfterSaving;

@property (weak, nonatomic) IBOutlet UISegmentedControl *countPlayers;

@property (weak, nonatomic) IBOutlet UITextField *playerOneName;
@property (weak, nonatomic) IBOutlet UITextField *playerTwoName;
@property (weak, nonatomic) IBOutlet UITextField *playerThreeName;
@property (weak, nonatomic) IBOutlet UITextField *playerFourName;

@property (strong, nonatomic) IBOutlet UIImageView *firstPlayerIcon;
@property (strong, nonatomic) IBOutlet UIImageView *secondPlayerIcon;
@property (strong, nonatomic) IBOutlet UIImageView *thirdPlayerIcon;
@property (strong, nonatomic) IBOutlet UIImageView *fourthPlayerIcon;

@end
