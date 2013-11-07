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
    id _mockAnimationManager;
}

- (void)setUp {
    [super setUp];
    _objUnderTest = [[ASViewController alloc] init];
}

- (void)tearDown {
    _objUnderTest = nil;
    [super tearDown];
}

- (void)installMockAnimationManager {
    _mockAnimationManager = [OCMockObject mockForClass:[ASAnimationManager class]];
    _objUnderTest.animationManager = _mockAnimationManager;
}

- (void)installNiceMockAnimationManager {
    _mockAnimationManager = [OCMockObject niceMockForClass:[ASAnimationManager class]];
    _objUnderTest.animationManager = _mockAnimationManager;
}

- (void)sizeViewForiPhone {
    _objUnderTest.view.frame = CGRectMake(0, 0, 320, 460);
}

- (void)sizeViewForiPhone5 {
    _objUnderTest.view.frame = CGRectMake(0, 0, 320, 548);
}

- (CGPoint)topRightCornerOfView {
    CGRect viewFrame = _objUnderTest.view.frame;
    CGPoint topRight = CGPointMake(viewFrame.origin.x + viewFrame.size.width, 0);
    return topRight;
}

- (CGPoint)bottomLeftCornerOfView {
    CGRect viewFrame = _objUnderTest.view.frame;
    CGPoint bottomLeft = CGPointMake(0, viewFrame.origin.y + viewFrame.size.height);
    return bottomLeft;
}

- (CGPoint)ballTopRightPosition {
    CGSize ballSize = _objUnderTest.ballImageView.frame.size;
    CGPoint topRight = [self topRightCornerOfView];
    return CGPointMake(topRight.x - ballSize.width / 2, ballSize.height / 2);
}

- (CGPoint)ballBottomLeftPosition {
    CGSize ballSize = _objUnderTest.ballImageView.frame.size;
    CGPoint bottomLeft = [self bottomLeftCornerOfView];
    return CGPointMake(bottomLeft.x + ballSize.width / 2, bottomLeft.y - ballSize.height / 2);
}

#pragma mark - Test methods

- (void)testVerticalButtonDidClicked_callsAnimationManager_iPhone {
    [self sizeViewForiPhone];
    [self installMockAnimationManager];
    
    CGPoint dest = [self ballBottomLeftPosition];
    [[_mockAnimationManager expect] bounceView:_objUnderTest.ballImageView to:dest];
    
    [_objUnderTest verticalButtonDidClicked:_objUnderTest.verticalButton];
    
    [_mockAnimationManager verify];
}

- (void)testVerticalButtonDidClicked_callsAnimationManager_iPhone5 {
    [self sizeViewForiPhone5];
    [self installMockAnimationManager];
    
    CGPoint dest = [self ballBottomLeftPosition];
    [[_mockAnimationManager expect] bounceView:_objUnderTest.ballImageView to:dest];
    
    [_objUnderTest verticalButtonDidClicked:_objUnderTest.verticalButton];
    
    [_mockAnimationManager verify];
}

- (void)testVerticalButtonDidClicked_hidensButtons {
    [self installNiceMockAnimationManager];
    
    [_objUnderTest verticalButtonDidClicked:_objUnderTest.verticalButton];
    
    STAssertTrue(_objUnderTest.verticalButton.hidden, nil);
    STAssertTrue(_objUnderTest.horizontalButton.hidden, nil);
}

- (void)testHorizontalButtonDidClicked_callsAnimationManager_iPhone {
    [self sizeViewForiPhone];
    [self installMockAnimationManager];
    
    CGPoint dest = [self ballTopRightPosition];
    [[_mockAnimationManager expect] bounceView:_objUnderTest.ballImageView to:dest];
    
    [_objUnderTest horizontalButtonDidClicked:_objUnderTest.horizontalButton];
    
    [_mockAnimationManager verify];
}

- (void)testHorizontalButtonDidClicked_callsAnimationManager_iPhone5 {
    [self sizeViewForiPhone5];
    [self installMockAnimationManager];
    
    CGPoint dest = [self ballTopRightPosition];
    [[_mockAnimationManager expect] bounceView:_objUnderTest.ballImageView to:dest];
    
    [_objUnderTest horizontalButtonDidClicked:_objUnderTest.horizontalButton];
    
    [_mockAnimationManager verify];
}

- (void)testHorizontalButtonDidClicked_hidensButtons {
    [self installNiceMockAnimationManager];
    
    [_objUnderTest horizontalButtonDidClicked:_objUnderTest.verticalButton];
    
    STAssertTrue(_objUnderTest.verticalButton.hidden, nil);
    STAssertTrue(_objUnderTest.horizontalButton.hidden, nil);
}

- (void)testAnimationComplete_showsButtons {
    _objUnderTest.verticalButton.hidden = YES;
    _objUnderTest.horizontalButton.hidden = YES;
    
    [_objUnderTest animationComplete];
    
    STAssertFalse(_objUnderTest.verticalButton.hidden, nil);
    STAssertFalse(_objUnderTest.horizontalButton.hidden, nil);
}

@end
