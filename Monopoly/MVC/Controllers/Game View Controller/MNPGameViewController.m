//
//  MNPGameViewController.m
//  Monopoly
//
//  Created by Andrew Raukut on 28.04.15.
//  Copyright (c) 2015 raukutsCorporation. All rights reserved.
//

#import "MNPGameViewController.h"
#import "MNPGameManager.h"
#import "MNPPlayer.h"

@interface MNPGameViewController ()

@property (strong, nonatomic) MNPGameManager *gameManager;

@property (weak, nonatomic) IBOutlet UILabel *currentPlayerNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *currentPlayerCashLbl;

@property (weak, nonatomic) IBOutlet UIImageView *boardImageView;

@property (assign, nonatomic) NSArray *players;

@property (strong, nonatomic) NSArray *spaceList;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (assign, nonatomic) BOOL canPressEndTurn;

@end


@implementation MNPGameViewController

- (void)viewDidLoad {

  [super viewDidLoad];

  self.gameManager = [MNPGameManager sharedManager];
  self.gameManager.delegate = self;

  NSString *path = [[NSBundle mainBundle] pathForResource: @"MonopolySpaces" ofType: @"plist"];
  self.spaceList = [[NSArray alloc] initWithContentsOfFile:path];


  // Get info about first player
  MNPPlayer *firstPlayer = [self.gameManager getCurrentPlayerInfo];
  self.currentPlayerNameLbl.text = firstPlayer.playerName;
  self.currentPlayerCashLbl.text = [NSString stringWithFormat:@"%ld",(long)firstPlayer.playerCash];

  self.canPressEndTurn = YES;
}


#pragma mark - Private methods


#pragma mark - IBActions

- (IBAction)rollButton:(id)sender {

  UIButton *rollButton = sender;
  if ([rollButton.titleLabel.text isEqual: @"End Turn"]) {

    if (self.canPressEndTurn) {
      MNPPlayer *nextPlayer = [self.gameManager getCurrentPlayerInfo];

      self.currentPlayerCashLbl.text = [NSString stringWithFormat:@"%ld",(long)nextPlayer.playerCash ];
      self.currentPlayerNameLbl.text = nextPlayer.playerName;

      [rollButton setTitle:@"ROLL!" forState:UIControlStateNormal];
      [rollButton setTitle:@"ROLL!" forState:UIControlStateSelected];
      return;

    } else {
      return;
    }
  }
  self.canPressEndTurn = NO;
  [rollButton setTitle:@"End Turn" forState:UIControlStateNormal];
  [rollButton setTitle:@"End Turn" forState:UIControlStateSelected];
  [_gameManager performCurrentPlayerAction];
}

#pragma mark - MNPGameManager Delegate methods

- (void)gameManager:(MNPGameManager *)gameManager didPreparedGameWithPlayers:(NSArray *)players {

  self.players = players;
  MNPPlayer *firstPlayer = players[0];
  self.currentPlayerNameLbl.text = firstPlayer.playerName;
  self.currentPlayerCashLbl.text = [NSString stringWithFormat:@"%ld $",(long)firstPlayer.playerCash];

}

- (void)gameManager:(MNPGameManager *)gameManager didPerformActionWithPlayer:(MNPPlayer *)player {

  [self.boardImageView addSubview:player.playerToken];

  CGPoint currentLocation = player.currentLocation;

  NSInteger nextX = [_spaceList[player.currentSpace][@"x"] integerValue];
  NSInteger nextY = [_spaceList[player.currentSpace][@"y"] integerValue];

  CGPoint nextLocation = CGPointMake(nextX, currentLocation.y);

 // Turning for x coordinate
  CABasicAnimation *moveX = [CABasicAnimation animationWithKeyPath:@"position.x"];

  moveX.fromValue  = @(currentLocation.x);
  moveX.toValue    = @(nextLocation.x);

// Turning for y coordinate
  CABasicAnimation *moveY = [CABasicAnimation animationWithKeyPath:@"position.y"];
  player.currentLocation = nextLocation;

  nextLocation.y = nextY;
  currentLocation = player.currentLocation;
  moveY.fromValue  = @(currentLocation.y);
  moveY.toValue    = @(nextLocation.y);

// Combine animations
  CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
  groupAnimation.delegate = self;
  groupAnimation.duration = 1.5f;
  groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  groupAnimation.animations = @[moveX,moveY];

  [player.playerToken.layer addAnimation:groupAnimation forKey:@"moving"];
  player.playerToken.layer.position = nextLocation;
  player.currentLocation = nextLocation;
}


#pragma mark - GroupAnimationDelegate Methods

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  if (flag) {
      // Handle what type of space player visit now

    self.canPressEndTurn = YES;
  }
}

@end
