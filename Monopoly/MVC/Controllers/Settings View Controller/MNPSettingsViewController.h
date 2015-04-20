//
//  MNPSettingsViewController.h
//  Monopoly
//
//  Created by Andrew Raukut on 20.04.15.
//  Copyright (c) 2015 raukutsCorporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNPSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *countPlayers;

@property (weak, nonatomic) IBOutlet UITextField *playerOneName;
@property (weak, nonatomic) IBOutlet UITextField *playerTwoName;
@property (weak, nonatomic) IBOutlet UITextField *playerThreeName;
@property (weak, nonatomic) IBOutlet UITextField *playerFourName;

@property (weak, nonatomic) IBOutlet UIImageView *firstPlayerIcon;
@property (weak, nonatomic) IBOutlet UIImageView *secondPlayerIcon;
@property (weak, nonatomic) IBOutlet UIImageView *thirdPlayerIcon;
@property (weak, nonatomic) IBOutlet UIImageView *fourthPlayerIcon;

@end
