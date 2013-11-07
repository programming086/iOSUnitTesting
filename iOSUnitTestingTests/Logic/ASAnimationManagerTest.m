//
//  ASAnimationManagerTest.m
//  iOSUnitTesting
//
//  Created by Brovko Roman on 07.11.13.
//  Copyright (c) 2013 AshberrySoft. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "ASAnimationManager.h"
#import "ASAnimationManager+Internal.h"

#define ANIMATION_DURATION 0.1

@interface ASAnimationManagerTest : SenTestCase

@end

@implementation ASAnimationManagerTest {
    ASAnimationManager *_objUnderTest;
    id _mockDelegate;
    UIView *_parentView;
    UIView *_viewBeingAnimated;
}

- (void)setUp {
    [super setUp];
    _objUnderTest = [[ASAnimationManager alloc] init];
    _objUnderTest.duration = ANIMATION_DURATION;
    _mockDelegate = [OCMockObject mockForProtocol:@protocol(ASAnimationManagerDelegate)];
    _objUnderTest.delegate = _mockDelegate;
    _parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _viewBeingAnimated = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [_parentView addSubview:_viewBeingAnimated];
}

- (void)tearDown {
    _objUnderTest = nil;
    _parentView = nil;
    _viewBeingAnimated = nil;
    _mockDelegate = nil;
    [super tearDown];
}

- (void)testViewReturnsHomeAfterAnimationsComplete {
    CGPoint originalViewCenter = _viewBeingAnimated.center;
    
    [[_mockDelegate expect] animationComplete];
    
    [_objUnderTest bounceView:_viewBeingAnimated to:CGPointMake(5, 95)];
    
    [NSThread sleepForTimeInterval:2 * ANIMATION_DURATION + 0.1];
    
    CGPoint viewCenter = _viewBeingAnimated.center;
    
    STAssertEquals(viewCenter.x, originalViewCenter.x, nil);
    STAssertEquals(viewCenter.y, originalViewCenter.y, nil);
    [_mockDelegate verify];
}

@end
