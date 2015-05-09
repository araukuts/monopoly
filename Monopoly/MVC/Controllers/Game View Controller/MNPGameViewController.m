//
//  MNPGameViewController.m
//  Monopoly
//
//  Created by Andrew Raukut on 28.04.15.
//  Copyright (c) 2015 raukutsCorporation. All rights reserved.
//

#import "MNPGameViewController.h"
#import "MNPGameManager.h"

@interface MNPGameViewController ()

@property (nonatomic, strong) MNPGameManager *gameManager;

@property (weak, nonatomic) IBOutlet UILabel *currentPlayerLbl;

@property (weak, nonatomic) IBOutlet UIImageView *boardImageView;

@property (strong, nonatomic) NSArray *spaceList;

@end


@implementation MNPGameViewController

- (void)viewDidLoad {

  [super viewDidLoad];

  self.gameManager = [MNPGameManager sharedManager];
  self.gameManager.delegate = self;


  NSString *path = [[NSBundle mainBundle] pathForResource: @"MonopolySpaces" ofType: @"plist"];
  self.spaceList = [[NSArray alloc] initWithContentsOfFile:path];
}


#pragma mark - Private methods


#pragma mark - IBActions

- (IBAction)rollButton:(id)sender {

  [_gameManager performCurrentPlayerAction];
}

#pragma mark - MNPGameManager Delegate methods

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
  //[player.playerToken.layer addAnimation:moveX forKey:@"position.x"];
  //player.playerToken.layer.position = nextLocation;


// Turning for y coordinate
  CABasicAnimation *moveY = [CABasicAnimation animationWithKeyPath:@"position.y"];
  player.currentLocation = nextLocation;

  nextLocation.y = nextY;
  currentLocation = player.currentLocation;
  moveY.fromValue  = @(currentLocation.y);
  moveY.toValue    = @(nextLocation.y);


  CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
  groupAnimation.duration = 1.5f;
  groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  groupAnimation.animations = @[moveX,moveY];

  [player.playerToken.layer addAnimation:groupAnimation forKey:@"moving"];
  player.playerToken.layer.position = nextLocation;
  player.currentLocation = nextLocation;
}

@end
