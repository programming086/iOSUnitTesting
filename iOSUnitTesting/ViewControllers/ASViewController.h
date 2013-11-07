//
//  ASViewController.h
//  iOSUnitTesting
//
//  Created by Brovko Roman on 07.11.13.
//  Copyright (c) 2013 AshberrySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASAnimationManager.h"

@interface ASViewController : UIViewController <ASAnimationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *ballImageView;
@property (weak, nonatomic) IBOutlet UIButton *verticalButton;
@property (weak, nonatomic) IBOutlet UIButton *horizontalButton;

@property (strong, nonatomic) ASAnimationManager *animationManager;

- (IBAction)verticalButtonDidClicked:(id)sender;

- (IBAction)horizontalButtonDidClicked:(id)sender;

@end
