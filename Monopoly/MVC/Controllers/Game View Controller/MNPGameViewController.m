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
#import "MNPSpace.h"
#import "MNPMenuViewController.h"
#import "MNPSummaryViewController.h"


const int dx = 200, dy = 200;

@interface MNPGameViewController ()

@property (strong, nonatomic) MNPGameManager *gameManager;
@property (strong, nonatomic) MNPPlayer *currentPlayer;
@property (strong, nonatomic) MNPSpace *currentSpace;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *houses;

@property (weak, nonatomic) IBOutlet UILabel *currentPlayerNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *currentPlayerCashLbl;
@property (weak, nonatomic) IBOutlet UIImageView *currentPlayerToken;

@property (weak, nonatomic) IBOutlet UIImageView *boardImageView;

@property (assign, nonatomic) NSArray *players;

@property (strong, nonatomic) NSArray *spaceList;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (assign, nonatomic) BOOL canPressEndTurn;

@property (assign, nonatomic) NSInteger someCount;

@property (assign, nonatomic) CAAnimationGroup *movingAnimation;

@property (assign, nonatomic) NSInteger firstRoll;
@property (assign, nonatomic) NSInteger secondRoll;

@end


@implementation MNPGameViewController

- (void)viewDidLoad {

  [super viewDidLoad];

  self.gameManager = [MNPGameManager sharedManager];
  self.gameManager.delegate = self;
  [_gameManager updateGameManager];
  _someCount = 2;

  NSString *path = [[NSBundle mainBundle] pathForResource: @"MonopolySpaces" ofType: @"plist"];
  self.spaceList = [[NSArray alloc] initWithContentsOfFile:path];


  // Get info about first player
  MNPPlayer *firstPlayer = [self.gameManager getCurrentPlayerInfo];
  self.currentPlayer = firstPlayer;
  self.currentPlayerNameLbl.text = firstPlayer.playerName;
  self.currentPlayerCashLbl.text = [NSString stringWithFormat:@"%ld",(long)firstPlayer.playerCash];
  self.currentPlayerToken.image = firstPlayer.playerToken.image;

  self.canPressEndTurn = YES;

  [self createDice];
}


#pragma mark - Private methods

- (void)showUserDetailsWithPlayer:(MNPPlayer *)player {

  self.currentPlayer = player;
  self.currentPlayerCashLbl.text = [NSString stringWithFormat:@"%ld",(long)player.playerCash ];
  self.currentPlayerNameLbl.text = player.playerName;
  self.currentPlayerToken.image = player.playerToken.image;
}


- (void)rescueFromJailByDice {

  self.currentPlayer.playerInJail = NO;
  self.currentPlayer.countOfFreeRolling = 0;
  [self createAlertViewForRescueFromJailByEqualDice];
}

- (void)rescueFromJailByMoney {

  [_gameManager player:self.currentPlayer rescuedFromJailByMoney:50];
  [self createAlertViewForRescueFromJailByMoney];
}

- (void)createDice {

  UIImageView *_dice1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1@2x.png"]];
  _dice1.frame = CGRectMake(85.0 + dx, 115.0 + dx, 90.0, 90.0);
  dice1 = _dice1;
  [self.view addSubview:_dice1];
  UIImageView *_dice2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2@2x.png"]];
  _dice2.frame = CGRectMake(165.0 + dx, 115.0 + dy, 90.0, 90.0);
  dice2 = _dice2;
  [self.view addSubview:_dice2];
}

- (void)diceRolling {

  dice1.hidden = YES;
  dice2.hidden = YES;

  dong1.hidden = YES;
  dong2.hidden = YES;

  NSArray *myImages = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"dong1@2x.png"],
                       [UIImage imageNamed:@"dong2@2x.png"],
                       nil];


  UIImageView *dong11 = [[UIImageView alloc] initWithFrame:CGRectMake(85.0 + dx, 115.0 + dy, 90, 90.0)];
  dong11.animationImages = myImages;
  dong11.animationDuration = 0.5;
  [dong11 startAnimating];
  [self.view addSubview:dong11];
  dong1 = dong11;
  UIImageView *dong12 = [[UIImageView alloc] initWithFrame:CGRectMake(165.0 + dx, 115.0 + dy, 90, 90)];
  dong12.animationImages = myImages;
  dong12.animationDuration = 0.5;
  [dong12 startAnimating];
  [self.view addSubview:dong12];
  dong2 = dong12;


  CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
  [spin setToValue:[NSNumber numberWithFloat:M_PI * 16.0]];
  [spin setDuration:4];

  CGPoint p1 = CGPointMake(85.0 + dx, 115.0 + dy);
  CGPoint p2 = CGPointMake(165.0 + dx, 100.0 + dy);
  CGPoint p3 = CGPointMake(240.0 + dx, 160.0 + dy);
  CGPoint p4 = CGPointMake(140.0 + dx, 200.0 + dy);
  NSArray *keypoint = [[NSArray alloc] initWithObjects:[NSValue valueWithCGPoint:p1],[NSValue valueWithCGPoint:p2],[NSValue valueWithCGPoint:p3],[NSValue valueWithCGPoint:p4], nil];
  CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  [animation setValues:keypoint];
  [animation setDuration:4.0];
  [animation setDelegate:self];
  [dong11.layer setPosition:CGPointMake(140.0+150, 200.0+150)];

  CGPoint p21 = CGPointMake(135.0 + dx, 115.0 + dy);
  CGPoint p22 = CGPointMake(160.0 + dx, 220.0 + dy);
  CGPoint p23 = CGPointMake(85.0 + dx, 190.0 + dy);
  CGPoint p24 = CGPointMake(190.0 + dx, 175.0 + dy);
  NSArray *keypoint2 = [[NSArray alloc] initWithObjects:[NSValue valueWithCGPoint:p21],[NSValue valueWithCGPoint:p22],[NSValue valueWithCGPoint:p23],[NSValue valueWithCGPoint:p24], nil];
  CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  [animation2 setValues:keypoint2];
  [animation2 setDuration:4.0];
  [animation2 setDelegate:self];
  [dong12.layer setPosition:CGPointMake(190.0 + dx, 175.0 + dy)];

  CAAnimationGroup *animGroup = [CAAnimationGroup animation];
  animGroup.animations = [NSArray arrayWithObjects: animation, spin,nil];
  animGroup.duration = 4;
  [animGroup setDelegate:self];
  [[dong11 layer] addAnimation:animGroup forKey:@"position"];

  [animGroup setValue:@"animation1" forKey:@"id"];


  CAAnimationGroup *animGroup2 = [CAAnimationGroup animation];
  animGroup2.animations = [NSArray arrayWithObjects: animation2, spin,nil];
  animGroup2.duration = 4;
  [animGroup2 setDelegate:self];
  [[dong12 layer] addAnimation:animGroup2 forKey:@"position"];

  [animGroup2 setValue:@"animation2" forKey:@"id"];

}

- (void)movePlayerToJail:(MNPPlayer *)player {

  player.playerInJail = YES;
  player.countOfFreeRolling = 3;
  NSInteger nextX = [_spaceList[30][@"x"] integerValue];
  NSInteger nextY = [_spaceList[30][@"y"] integerValue];
  player.currentSpace = 30;
  CGPoint jailPoint = CGPointMake(nextX, nextY);
  player.currentLocation = jailPoint;
  player.playerToken.layer.position = jailPoint;
  [self.boardImageView addSubview:player.playerToken];
  [self createActionSheetForJail];
}

- (void)currentPlayerBuyCurrentFactory{

  if (_currentPlayer.playerCash < _currentSpace.cost) {
    [self createAlertViewNotEnoughMoneyForBuyingFactory];
  } else {
    [_gameManager player:_currentPlayer buyFactoryAtSpace:_currentSpace];
  }
}

- (void)checkForWinner {

  if ([_gameManager getNumberOfExistPlayers] == 1) {

    MNPPlayer *winner = [_gameManager getCurrentPlayerInfo];
    [self createAlertViewCongratulateWinner:winner];
  }
}

- (void)completeGame {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                       bundle:nil];
  MNPSummaryViewController *summaryViewController =
  [storyboard instantiateViewControllerWithIdentifier:@"summaryViewController"];

  [self presentViewController:summaryViewController animated:YES completion:nil];
}

- (void)currentPlayerBuyCurrentRailroad {

  if (_currentPlayer.playerCash < _currentSpace.cost) {
    [self createAlertViewNotEnoughMoneyForBuyingRailroad];
  } else {
    [_gameManager player:_currentPlayer buyRailroadAtSpace:_currentSpace];
  }
}

- (void)currentPlayerBuyCurrentBuilding {

  if (_currentPlayer.playerCash < _currentSpace.cost) {
    [self createAlertViewNotEnoughMoneyForBuyingBuilding];
  } else {
    [_gameManager player:_currentPlayer buyBuildingAtSpace:_currentSpace];
  }
}

- (void)currentPlayerUpdateCurrentBuilding {
  
  if (_currentPlayer.playerCash < _currentSpace.cost) {
    [self createAlertViewNotEnoughMoneyForUpdateBuilding];
  } else {
    [_gameManager player:_currentPlayer updateBuildingAtSpace:_currentSpace];
  }
}

#pragma mark - IBActions

- (IBAction)exitButtonPressed:(id)sender {

  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                       bundle:nil];
  MNPMenuViewController *menuViewController =
  [storyboard instantiateViewControllerWithIdentifier:@"menuViewController"];

  //[self dismissViewControllerAnimated:NO completion:nil];
  [self presentViewController:menuViewController animated:YES completion:nil];
}

- (IBAction)rollButton:(id)sender {

  [self checkForWinner];

  UIButton *rollButton = sender;
  self.someCount = 2;
  if ([rollButton.titleLabel.text isEqual: @"End Turn"]) {

    if (self.canPressEndTurn) {
      MNPPlayer *nextPlayer = [self.gameManager getCurrentPlayerInfo];
      self.currentPlayer = nextPlayer;
      [self showUserDetailsWithPlayer:nextPlayer];
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
  [self diceRolling];
}


#pragma mark - MNPGameManagerDelegate methods

- (void)gameManager:(MNPGameManager *)gameManager didPreparedGameWithPlayers:(NSArray *)players {

  self.players = players;
  MNPPlayer *firstPlayer = players[0];
  self.currentPlayerNameLbl.text = firstPlayer.playerName;
  self.currentPlayerCashLbl.text = [NSString stringWithFormat:@"%ld $",(long)firstPlayer.playerCash];

}

- (void)gameManager:(MNPGameManager *)gameManager
      didPerformActionWithPlayer:(MNPPlayer *)player
      withNumberDice:(NSInteger)rollDice {

  self.currentPlayer = player;

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

  [moveY setValue:@"moving" forKey:@"animationID"];
  [moveX setValue:@"moving" forKey:@"animationID"];
// Combine animations
  CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
  groupAnimation.delegate = self;
  groupAnimation.duration = 1.5f;
  groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  groupAnimation.animations = @[moveX,moveY];

  [player.playerToken.layer addAnimation:groupAnimation forKey:@"moving"];
  player.playerToken.layer.position = nextLocation;
  player.currentLocation = nextLocation;

  [groupAnimation setValue:@"animation3" forKey:@"id"];

}

- (void)gameManager:(MNPGameManager *)gameManager didPerfromGoToFreeParkingForCurrentPlayer:(MNPPlayer *)player {

  self.currentPlayer = player;
  [self createAlertViewGoToFreeParkingForPlayer:player];
}

- (void)gameManager:(MNPGameManager *)gameManager didPerformPayTax:(NSNumber *)tax forCurrentPlayer:(MNPPlayer *)player {

  self.currentPlayer = player;
  [self createAlertViewPayTax:tax];
  [self showUserDetailsWithPlayer:player];
}

- (void)gameManager:(MNPGameManager *)gameManager didPerformTakeSalary:(NSNumber *)salary forCurrentPlayer:(MNPPlayer *)player {
  self.currentPlayer = player;
  [self createAlertViewForRecieveSalary:salary];
  [self showUserDetailsWithPlayer:player];
}

- (void)gameManager:(MNPGameManager *)gameManager didPerformGetFreeKeyFromJailForCurrentPlayer:(MNPPlayer *)player {

  self.currentPlayer = player;
  [self createAlertViewForRecieveFreeKeyFromJail];
}

- (void)gameManager:(MNPGameManager *)gameManager didPerformGoToJailForCurrentPlayer:(MNPPlayer *)player {

  self.currentPlayer = player;
  [self createAlertViewGoToJailForPlayer:player];
}

- (void)gameManager:(MNPGameManager *)gameManager didPerformActionWithPlayerInJail:(MNPPlayer *)player {
  self.currentPlayer = player;
}

- (void)gameManager:(MNPGameManager *)gameManager currentPlayerSuccesfullyBuyFactory:(MNPPlayer *)player {

  [self showUserDetailsWithPlayer:player];
  NSInteger spaceNumber = player.currentSpace;
  for (UIImageView *imageView in self.houses) {
    if (imageView.tag == spaceNumber) {
      imageView.image = [UIImage imageNamed:player.houseImagePath];
      break;
    }
  }

}

- (void)gameManager:(MNPGameManager *)gameManager currentPlayerSuccesfullyBuyRailroad:(MNPPlayer *)player {

  [self showUserDetailsWithPlayer:player];

  NSInteger spaceNumber = player.currentSpace;
  for (UIImageView *imageView in self.houses) {
    if (imageView.tag == spaceNumber) {
      imageView.image = [UIImage imageNamed:player.houseImagePath];
      break;
    }
  }
}

- (void)gameManager:(MNPGameManager *)gameManager currentPlayerSuccesfullyBuyBuilding:(MNPPlayer *)player {

  [self showUserDetailsWithPlayer:player];
  NSInteger spaceNumber = player.currentSpace;
  for (UIImageView *imageView in self.houses) {
    if (imageView.tag == spaceNumber) {
      imageView.image = [UIImage imageNamed:player.houseImagePath];
      break;
    }
  }
}

- (void)gameManager:(MNPGameManager *)gameManager currentPLayerSuccesfullyUpdateBuilding:(MNPPlayer *)player {

  [self showUserDetailsWithPlayer:player];
}

- (void)gameManager:(MNPGameManager *)gameManager currentPlayerKnockoutFromGame:(MNPPlayer *)player {

  [self createAlertViewKnockoutFromGamePlayer:player];
  for (UIImageView *imageView in self.houses) {
    NSData *image1Data = UIImagePNGRepresentation(imageView.image);
    NSData *image2Data = UIImagePNGRepresentation([UIImage imageNamed:player.houseImagePath]);
    if ([image1Data isEqualToData:image2Data])
      imageView.image = nil;
  }
}

- (void)gameManager:(MNPGameManager *)gameManager currentPlayerSuccesfullyPaidRent:(MNPPlayer *)player {
  [self showUserDetailsWithPlayer:player];
}

#pragma mark - MNPGameManager Municipal Spaces

- (void)gameManager:(MNPGameManager *)gameManager currentPlayer:(MNPPlayer *)player stayAtFreeMunicipalFactory:(MNPSpace *)space {

  self.currentSpace = space;
  self.currentPlayer = player;
  [self createAlertViewStayAtFreeFactory:space.factoryName withRentCost:space.cost];
}

- (void)gameManager:(MNPGameManager *)gameManager currentPlayer:(MNPPlayer *)player mustPayMoney:(NSInteger)cost toFactoryOwner:(MNPPlayer *)factoryOwner {

  self.currentPlayer = player;
  [self createAlertViewStayAtOccupiedFactoryByPlayer:factoryOwner withRentCost:cost];
  [_gameManager player:player mustPayRentToFactoryOwner:factoryOwner atTheRateOf:cost];
}

#pragma mark - MNPGameManager Railroad Spaces

- (void)gameManager:(MNPGameManager *)gameManager currentPlayer:(MNPPlayer *)player stayAtFreeRailroad:(MNPSpace *)space {

  self.currentSpace = space;
  self.currentPlayer = player;
  [self createAlertViewStayAtFreeRailroad:space.factoryName withCost:space.cost];
}


- (void)gameManager:(MNPGameManager *)gameManager currentPlayer:(MNPPlayer *)player mustPayMoney:(NSInteger)cost toRailroadOwner:(MNPPlayer *)railroadOwner {
  self.currentPlayer = player;
  [self createAlertViewStayAtOccupiedRailroadByPlayer:railroadOwner withRentCost:cost];
  [_gameManager player:player mustPayRentToRailroadOwner:railroadOwner atTheRateOf:cost];
}

#pragma mark - MNPGameManager Building Spaces

- (void)gameManager:(MNPGameManager *)gameManager currentPlayer:(MNPPlayer *)player stayAtFreeBuilding:(MNPSpace *)space {

  self.currentSpace = space;
  self.currentPlayer = player;
  [self createAlertViewStayAtFreeBuilding:space.factoryName withCost:space.cost];
}

- (void)gameManager:(MNPGameManager *)gameManager currentPlayer:(MNPPlayer *)player mustPayMoney:(NSInteger)cost toBuildingOwner:(MNPPlayer *)buildingOwner {
  
  self.currentPlayer = player;
  [self createAlertViewStayAtOccupiedBuildingByPlayer:buildingOwner withRentCost:cost];
  [_gameManager player:player mustPayRentToBuildingOwner:buildingOwner atTheRateOf:cost];
}

- (void)gameManager:(MNPGameManager *)gameManager currentPlayer:(MNPPlayer *)player stayAtOwnBuilding:(MNPSpace *)space {

  self.currentPlayer = player;
  self.currentSpace = space;
  [self createAlertViewStayAtOwnBuilding:space.factoryName withCost:space.cost];
}


#pragma mark - ActionSheet

- (void)createActionSheetForJail {

  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"Pay 50$", @"Stay in Jail",nil];
  [actionSheet showInView:self.view];

}


#pragma mark - AlertView

- (void)createAlertViewStayAtOwnBuilding:(NSString *)buildingName withCost:(NSInteger)cost {

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:buildingName
                                                      message:[NSString stringWithFormat:@"Do you want to update your building by %ld $", (long)cost]
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"Update Building", @"Ignore", nil];

  [alertView show];
}

- (void)createAlertViewStayAtFreeBuilding:(NSString *)buildingName withCost:(NSInteger)cost {

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:buildingName
                                                      message:[NSString stringWithFormat:@"Do you want to buy building by %ld $", (long)cost]
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"Buy Building", @"Ignore", nil];

  [alertView show];
}

- (void)createAlertViewStayAtFreeRailroad:(NSString *)railroadName withCost:(NSInteger)cost {

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:railroadName
                                                      message:[NSString stringWithFormat:@"Do you want to buy factory by %ld $", (long)cost]
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"Buy Railroad", @"Ignore", nil];

  [alertView show];
}

- (void)createAlertViewCongratulateWinner:(MNPPlayer *)player {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"CONGRATULATION!!!!"
                                                      message:[NSString stringWithFormat: @"Dear, %@, Congratulations you won the game Monopoly",player.playerName]
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"Okay :)",nil];

  [alertView show];
}

- (void)createAlertViewKnockoutFromGamePlayer:(MNPPlayer *)player {

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                      message:[NSString stringWithFormat: @"Dear, %@, You bankrupt, You knockout from this game",player.playerName]
                                                     delegate:self
                                            cancelButtonTitle:@"Okay :("
                                            otherButtonTitles:nil];

  [alertView show];
}

- (void)createAlertViewNotEnoughMoneyForBuyingFactory {

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                      message:@"You have enough money to buy the factory"
                                                     delegate:self
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil];

  [alertView show];
}

- (void)createAlertViewNotEnoughMoneyForUpdateBuilding {

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                      message:@"You have enough money to update the building"
                                                     delegate:self
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil];

  [alertView show];
}

- (void)createAlertViewNotEnoughMoneyForBuyingBuilding {

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                      message:@"You have enough money to buy the building"
                                                     delegate:self
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil];

  [alertView show];
}

- (void)createAlertViewNotEnoughMoneyForBuyingRailroad {

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                      message:@"You have enough money to buy the railroad"
                                                     delegate:self
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil];

  [alertView show];
}

- (void)createAlertViewStayAtFreeFactory:(NSString *)factoryName withRentCost:(NSInteger)rentCost {

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:factoryName
                                                      message:[NSString stringWithFormat:@"Do you want to buy factory by %ld $", (long)rentCost]
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"Buy Factory", @"Ignore", nil];

  [alertView show];
}

- (void)createAlertViewStayAtOccupiedBuildingByPlayer:(MNPPlayer *)owner withRentCost:(NSInteger)rentCost {

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Territory occupied by %@",owner.playerName]
                                                      message:[NSString stringWithFormat:@"You must pay %ld", (long)rentCost]
                                                     delegate:self
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil];

  [alertView show];
}

- (void)createAlertViewStayAtOccupiedRailroadByPlayer:(MNPPlayer *)owner withRentCost:(NSInteger)rentCost {

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Territory occupied by %@",owner.playerName]
                                                      message:[NSString stringWithFormat:@"You must pay %ld", (long)rentCost]
                                                     delegate:self
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil];

  [alertView show];
}

- (void)createAlertViewStayAtOccupiedFactoryByPlayer:(MNPPlayer *)owner withRentCost:(NSInteger)rentCost {

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Territory occupied by %@",owner.playerName]
                                                      message:[NSString stringWithFormat:@"You must pay %ld", (long)rentCost]
                                                     delegate:self
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil];

  [alertView show];
}

- (void)createAlertViewGoToFreeParkingForPlayer:(MNPPlayer *)player {

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Free Parking"
                                                      message:[NSString stringWithFormat:@"Do you want to stay in free parking?"]
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"Accept",@"Deny",nil];

  [alertView show];
}

- (void)createAlertViewGoToJailForPlayer:(MNPPlayer *)player{

  if (player.playerGetOutOfJailFree) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:[NSString stringWithFormat:@"You must go to jail!"]
                                                     delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Use free key",@"Go to jail",nil];

    [alertView show];
  } else {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:[NSString stringWithFormat:@"You must go to jail!"]
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Go to jail",nil];

    [alertView show];
  }
}

- (void)createAlertViewForRecieveFreeKeyFromJail {

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Congratulate!"
                                                      message:[NSString stringWithFormat:@"You received free key from jail!!!"]
                                                     delegate:self
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles: nil];
  [alertView show];
}

- (void)createAlertViewForRecieveSalary:(NSNumber *)salary {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Salary!"
                                                      message:[NSString stringWithFormat:@"You received %@$",salary]
                                                     delegate:self
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles: nil];
  [alertView show];
}

- (void)createAlertViewPayTax:(NSNumber *)tax {

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                      message:[NSString stringWithFormat:@"You must pay tax at the rate of %@",tax]
                                                                                delegate:self
                                            cancelButtonTitle:@"Ok" otherButtonTitles:nil];
  [alertView show];
}

- (void)createAlertViewForRescueFromJailByEqualDice {

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You Lucky!"
                                                      message:[NSString stringWithFormat:@"You roll the same number on the dice!!"]
                                                     delegate:self
                                            cancelButtonTitle:@"Ok" otherButtonTitles:nil];
  [alertView show];
}

- (void)createAlertViewForRescueFromJailByMoney {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You can no longer sit in jail"
                                                      message:[NSString stringWithFormat:@"You must pay 50$"]
                                                     delegate:self
                                            cancelButtonTitle:@"Ok" otherButtonTitles:nil];
  [alertView show];
}

- (void)createAlertViewContinueSeatInJail {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Jail"
                                                      message:[NSString stringWithFormat:@"You still sitting in jail"]
                                                     delegate:self
                                            cancelButtonTitle:@"Okay :("
                                            otherButtonTitles:nil];

  [alertView show];
}

- (void)createAlertViewForRequestStayInParking {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Free Parking"
                                                      message:[NSString stringWithFormat:@"Do you want to stay in the parking?"]
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"Yes",@"No",nil];

  [alertView show];
}
- (void)createAlertViewNotEnoughtMoneyForRescueFromJail {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Jail"
                                                      message:[NSString stringWithFormat:@"You have no enough money for rescue from jail"]
                                                     delegate:self
                                            cancelButtonTitle:@"Okay"
                                            otherButtonTitles:nil];

  [alertView show];
}



#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

  if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Use free key"]) {

    self.currentPlayer.playerGetOutOfJailFree = NO;
  } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Go to jail"]) {
    [self movePlayerToJail:self.currentPlayer];
  } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Accept"]) {
      self.currentPlayer.playerInFreeParking = YES;
  } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"No"]) {

    self.currentPlayer.playerInFreeParking = NO;
    [_gameManager performCurrentPlayerActionWithDice:@(self.firstRoll + self.secondRoll)];
    
  } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {

    [_gameManager performCurrentPlayerActionInFreeParking];
    self.canPressEndTurn = YES;
  } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Buy Factory"]) {
    [self currentPlayerBuyCurrentFactory];
  } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Okay :("]) {

    self.canPressEndTurn = YES;
    [self.currentPlayer.playerToken removeFromSuperview];
  } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Okay :)"]) {
    [self completeGame];
  } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Buy Railroad"]) {
    [self currentPlayerBuyCurrentRailroad];
  } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Buy Building"]) {
    [self currentPlayerBuyCurrentBuilding];
  } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Update Building"]) {
    [self currentPlayerUpdateCurrentBuilding];
  }
}


#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

  if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Pay 50$"]) {
    if (self.currentPlayer.playerCash > 50) {
      [_gameManager player:self.currentPlayer rescuedFromJailByMoney:50];
    } else {
      [self createAlertViewNotEnoughtMoneyForRescueFromJail];
    }
  }
}


#pragma mark - GroupAnimationDelegate Methods

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {

  if (flag) {
    if (self.someCount == 0) {
      self.canPressEndTurn = YES;
    } else {

      [dong1 stopAnimating];
      [dong2 stopAnimating];

      srand((unsigned)time(0));
      int result1 = (rand() % 5) + 1 ;
      switch (result1) {
        case 1:dong1.image = [UIImage imageNamed:@"1@2x.png"];break;
        case 2:dong1.image = [UIImage imageNamed:@"2@2x.png"];break;
        case 3:dong1.image = [UIImage imageNamed:@"3@2x.png"];break;
        case 4:dong1.image = [UIImage imageNamed:@"4@2x.png"];break;
        case 5:dong1.image = [UIImage imageNamed:@"5@2x.png"];break;
        case 6:dong1.image = [UIImage imageNamed:@"6@2x.png"];break;
      }

      int result2 = (rand() % 5) + 1 ;
      switch (result2) {
        case 1:dong2.image = [UIImage imageNamed:@"1@2x.png"];break;
        case 2:dong2.image = [UIImage imageNamed:@"2@2x.png"];break;
        case 3:dong2.image = [UIImage imageNamed:@"3@2x.png"];break;
        case 4:dong2.image = [UIImage imageNamed:@"4@2x.png"];break;
        case 5:dong2.image = [UIImage imageNamed:@"5@2x.png"];break;
        case 6:dong2.image = [UIImage imageNamed:@"6@2x.png"];break;
      }
      NSNumber *rollDice = @(result1 + result2);
      self.firstRoll = result1;
      self.secondRoll = result2;
      --self.someCount;
      if (_someCount != 0) {
        return;
      }
      if (self.currentPlayer.playerInJail) {
        if (result1 == result2) {

          [self rescueFromJailByDice];
          [_gameManager performCurrentPlayerActionWithDice:rollDice];
          return;
        } else if (self.currentPlayer.countOfFreeRolling == 0) {

          [self rescueFromJailByMoney];
          [_gameManager performCurrentPlayerActionWithDice:rollDice];
          return;
        } else {
          [self createAlertViewContinueSeatInJail];
        }
        --self.currentPlayer.countOfFreeRolling;
        [_gameManager performCurrentPlayerActionInJail];
        self.canPressEndTurn = YES;
        self.currentPlayer = [_gameManager getCurrentPlayerInfo];
      } else if (self.currentPlayer.playerInFreeParking) {

        [self createAlertViewForRequestStayInParking];
        return;
      }
      else {

        [_gameManager performCurrentPlayerActionWithDice:rollDice];
      }
    }
  }
}

@end
