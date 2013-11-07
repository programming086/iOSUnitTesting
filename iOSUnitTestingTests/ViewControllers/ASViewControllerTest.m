//
//  ASViewControllerTest.m
//  iOSUnitTesting
//
//  Created by Brovko Roman on 07.11.13.
//  Copyright (c) 2013 AshberrySoft. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "ASViewController.h"

@interface ASViewControllerTest : SenTestCase

@end

@implementation ASViewControllerTest {
    ASViewController *_objUnderTest;
}

- (void)setUp {
    [super setUp];
    _objUnderTest = [[ASViewController alloc] init];
}

- (void)tearDown {
    _objUnderTest = nil;
    [super tearDown];
}

- (void)sizeViewForiPhone {
    _objUnderTest.view.frame = CGRectMake(0, 0, 320, 460);
}

- (void)sizeViewForiPhone5 {
    _objUnderTest.view.frame = CGRectMake(0, 0, 320, 548);
}

- (void)testVerticalButtonDidClicked_callsAnimationManager {
    [self sizeViewForiPhone];
    
    id mockAnimationManager = [OCMockObject mockForClass:[ASAnimationManager class]];
    _objUnderTest.animationManager = mockAnimationManager;
    
    CGPoint dest = CGPointMake(30, 430);
    [[mockAnimationManager expect] bounceView:_objUnderTest.ballImageView to:dest];
    
    [_objUnderTest verticalButtonDidClicked:_objUnderTest.verticalButton];
    
    [mockAnimationManager verify];
}

- (void)testVerticalButtonDidClicked_callsAnimationManager_iPhone5 {
    [self sizeViewForiPhone5];
    
    id mockAnimationManager = [OCMockObject mockForClass:[ASAnimationManager class]];
    _objUnderTest.animationManager = mockAnimationManager;
    
    CGPoint dest = CGPointMake(30, 518);
    [[mockAnimationManager expect] bounceView:_objUnderTest.ballImageView to:dest];
    
    [_objUnderTest verticalButtonDidClicked:_objUnderTest.verticalButton];
    
    [mockAnimationManager verify];
}

@end
