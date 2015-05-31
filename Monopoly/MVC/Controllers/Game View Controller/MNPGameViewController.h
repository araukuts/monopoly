//
//  MNPGameViewController.h
//  Monopoly
//
//  Created by Andrew Raukut on 28.04.15.
//  Copyright (c) 2015 raukutsCorporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNPDataManager.h"
#import "MNPGameManager.h"

@interface MNPGameViewController : UIViewController <MNPGameManagerDelegate, UIAlertViewDelegate, UIActionSheetDelegate> {
    UIImageView *dice1,*dice2;
    UIImageView *dong1,*dong2;
}

@end
