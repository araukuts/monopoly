//
//  MNPSettingsViewController.m
//  Monopoly
//
//  Created by Andrew Raukut on 20.04.15.
//  Copyright (c) 2015 raukutsCorporation. All rights reserved.
//

#import "MNPSettingsViewController.h"

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
  }

  if (mask & (1<<2)) {
    _secondPlayerIcon.hidden = NO;
    _playerTwoName.hidden = NO;
  }
  else {
    _secondPlayerIcon.hidden = YES;
    _playerTwoName.hidden = YES;
  }

  if (mask & (1<<3)) {
    _thirdPlayerIcon.hidden = NO;
    _playerThreeName.hidden = NO;
  }
  else {
    _thirdPlayerIcon.hidden = YES;
    _playerThreeName.hidden = YES;
  }

  if (mask & (1<<4)) {
    _fourthPlayerIcon.hidden = NO;
    _playerFourName.hidden = NO;
  }
  else {
    _fourthPlayerIcon.hidden = YES;
    _playerFourName.hidden = YES;
  }

}

@end
