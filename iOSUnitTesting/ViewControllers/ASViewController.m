//
//  ASViewController.m
//  iOSUnitTesting
//
//  Created by Brovko Roman on 07.11.13.
//  Copyright (c) 2013 AshberrySoft. All rights reserved.
//

#import "ASViewController.h"

@interface ASViewController () {
    CGPoint _ballHomePosition;  // ball's home position
}

@end

@implementation ASViewController

- (id)init {
    self = [super initWithNibName:@"ASViewController" bundle:[NSBundle bundleForClass:[self class]]];
    if (self) {
        self.animationManager = [[ASAnimationManager alloc] init];
        self.animationManager.delegate = self;
    }
    return self;
}

#pragma mark - Memory manager

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
    _ballHomePosition = self.ballImageView.center;
}

#pragma mark - Actions methods

- (IBAction)verticalButtonDidClicked:(id)sender {
    // Destination is bottom edge of screen minus radius of ball
    CGSize ballSize = self.ballImageView.bounds.size;
    CGSize viewSize = self.view.bounds.size;
    CGPoint dest = CGPointMake(_ballHomePosition.x, viewSize.height - ballSize.height / 2);
    [self _bounceBallTo:dest];
}

- (IBAction)horizontalButtonDidClicked:(id)sender {
    // Destination is right edge of screen minus radius of ball
    CGSize ballSize = self.ballImageView.bounds.size;
    CGSize viewSize = self.view.bounds.size;
    CGPoint dest = CGPointMake(viewSize.width - ballSize.width / 2, _ballHomePosition.y);
    [self _bounceBallTo:dest];
}

#pragma mark - private methods

- (void)_bounceBallTo:(CGPoint)dest {
    self.verticalButton.hidden = YES;
    self.horizontalButton.hidden = YES;
    
    [self.animationManager bounceView:self.ballImageView to:dest];
}

#pragma mark - ASAnimationManager delegate methods

- (void)animationComplete {
    self.verticalButton.hidden = NO;
    self.horizontalButton.hidden = NO;
}

@end
