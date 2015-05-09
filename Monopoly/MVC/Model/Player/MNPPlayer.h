//
//  MNPPlayer.h
//  Monopoly
//
//  Created by Andrew Raukut on 21.04.15.
//  Copyright (c) 2015 raukutsCorporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface MNPPlayer : NSObject

// Properties - information about player
@property (strong, nonatomic) NSString *playerName;
@property (strong, nonatomic) UIImageView *playerToken;

@property (assign, nonatomic) CGPoint currentLocation;
@property (assign, nonatomic) NSInteger currentSpace;

// Gameplay properties
@property (assign, nonatomic) NSInteger playerCash;
@property (assign, nonatomic) BOOL playerGetOutOfJailFree;


#pragma mark - Public Methods

- (instancetype)initPlayerWithName:(NSString *)playerName token:(UIImage *)playerToken;

@end
