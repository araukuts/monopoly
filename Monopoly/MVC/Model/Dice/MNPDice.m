//
//  MNPDice.m
//  Monopoly
//
//  Created by Andrew Raukut on 21.04.15.
//  Copyright (c) 2015 raukutsCorporation. All rights reserved.
//

#import "MNPDice.h"

@implementation MNPDice

+ (NSInteger) roll {
  return arc4random()%6 + 1 + arc4random()%6 + 1;
}

@end
