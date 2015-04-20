//
//  MNPSettingsViewController.m
//  Monopoly
//
//  Created by Andrew Raukut on 20.04.15.
//  Copyright (c) 2015 raukutsCorporation. All rights reserved.
//

#import "MNPSettingsViewController.h"
#import "MNPGameManager.h"


@interface MNPSettingsViewController ()

@property (strong,nonatomic) MNPGameManager *gameManager;

@end

@implementation MNPSettingsViewController

typedef NS_ENUM(NSInteger, MNPCountPlayers) {
  MNPOnePlayers = 0,
  MNPTwoPlayers = 1,
  MNPThreePlayers = 2,
  MNPFourPlayers = 3,
};


#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
  self.title = @"Settings";

  [_countPlayers addTarget:self action:@selector(setUpPlayersName) forControlEvents:UIControlEventValueChanged];
  [self setUpRegistrationFieldWithMask:(1<<1)];

  UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
  [self.view addGestureRecognizer:tapRecognizer];

  self.gameManager = [MNPGameManager sharedManager];
  self.navigationItem.hidesBackButton = YES;
}


#pragma mark - Private methods

- (void)setUpPlayersName {

  switch (_countPlayers.selectedSegmentIndex) {
    case MNPOnePlayers:

      [self setUpRegistrationFieldWithMask:(1<<1)];
      break;

    case MNPTwoPlayers:

      [self setUpRegistrationFieldWithMask:(1<<1 | 1<<2)];
      break;

    case MNPThreePlayers:

      [self setUpRegistrationFieldWithMask:(1<<1 | 1<<2 | 1<<3)];
      break;

    case MNPFourPlayers:

      [self setUpRegistrationFieldWithMask:(1<<1 | 1<<2 | 1<<3 | 1<<4)];
      break;
  }
}

- (void)setUpRegistrationFieldWithMask:(NSInteger)mask {

  if (mask & (1<<1)) {
    _firstPlayerIcon.hidden = NO;
    _playerOneName.hidden = NO;
  }
  else {
    _firstPlayerIcon.hidden = YES;
    _playerOneName.hidden = YES;
    _playerOneName.text = @"";
  }

  if (mask & (1<<2)) {
    _secondPlayerIcon.hidden = NO;
    _playerTwoName.hidden = NO;
  }
  else {
    _secondPlayerIcon.hidden = YES;
    _playerTwoName.hidden = YES;
    _playerTwoName.text = @"";

  }

  if (mask & (1<<3)) {
    _thirdPlayerIcon.hidden = NO;
    _playerThreeName.hidden = NO;
    
  }
  else {
    _thirdPlayerIcon.hidden = YES;
    _playerThreeName.hidden = YES;
    _playerThreeName.text = @"";

  }

  if (mask & (1<<4)) {
    _fourthPlayerIcon.hidden = NO;
    _playerFourName.hidden = NO;
  }
  else {
    _fourthPlayerIcon.hidden = YES;
    _playerFourName.hidden = YES;
    _playerFourName.text = @"";
  }

}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {

  [self.view endEditing:YES];
}

#pragma mark - IBAction's methods

- (IBAction)performSettings:(id)sender {

  NSArray *playersInfo = @[];
  for (NSInteger index = 0; index < _countPlayers.selectedSegmentIndex; ++index) {
  
  }
  [_gameManager savePlayersInformation:playersInfo];
  [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
