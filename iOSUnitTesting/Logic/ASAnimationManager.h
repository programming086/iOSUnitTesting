//
//  ASAnimationManager.h
//  iOSUnitTesting
//
//  Created by Brovko Roman on 07.11.13.
//  Copyright (c) 2013 AshberrySoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ASAnimationManagerDelegate <NSObject>

- (void)animationComplete;

@end

@interface ASAnimationManager : NSObject

@property (weak, nonatomic) id<ASAnimationManagerDelegate> delegate;

- (void)bounceView:(UIView *)view to:(CGPoint)dest;

@end
