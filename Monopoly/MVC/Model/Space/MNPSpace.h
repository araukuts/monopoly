//
//  MNPSpace.h
//  Monopoly
//
//  Created by Andrew Raukut on 31.05.15.
//  Copyright (c) 2015 raukutsCorporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNPPlayer.h"

@interface MNPSpace : NSObject

@property (strong, nonatomic) MNPPlayer *owner;
@property (assign, nonatomic) NSInteger cost;
@property (strong, nonatomic) NSString *factoryName;
@property (strong, nonatomic) NSArray *rent;

@property (assign, nonatomic) NSInteger buildingLevel;
@property (strong, nonatomic) NSString *buildingColor;

@end
