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
#import "ASAnimationSegment.h"

#define ANIMATION_DURATION 0.1

@interface ASAnimationManagerTest : SenTestCase

@end

@implementation ASAnimationManagerTest {
    ASAnimationManager *_objUnderTest;
    id _mockDelegate;
    UIView *_parentView;
    UIView *_viewBeingAnimated;
    NSArray *_savedSegments;
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

- (void)waitForAnimation {
    NSTimeInterval timeout = 2 * ANIMATION_DURATION + 0.1;
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:timeout];
    while ([loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
}

- (void)saveAnimationSegments:(NSArray *)segments {
    _savedSegments = segments;
}

#pragma mark - Test methods

- (void)testVerticalBounce_startsAnimationToLowerLeftCorner {
    CGSize parentSize = _parentView.frame.size;
    CGPoint originalViewCenter = _viewBeingAnimated.center;
    CGPoint lowerLeftCenter = CGPointMake(_viewBeingAnimated.bounds.size.width / 2,
                                          parentSize.height - _viewBeingAnimated.bounds.size.height / 2);
    
    id wrapper = [OCMockObject partialMockForObject:_objUnderTest];
    [[[wrapper expect] andCall:@selector(saveAnimationSegments:) onObject:self] _beginAnimations:OCMOCK_ANY];
    
    [wrapper verticalBounce:_viewBeingAnimated];
    
    [_mockDelegate verify];
    [wrapper verify];
    
    STAssertEquals([_savedSegments count], (NSUInteger)2, nil);
    
    ASAnimationSegment *seg1 = _savedSegments[0];
    STAssertEquals(seg1.destCenter.x, lowerLeftCenter.x, nil);
    STAssertEquals(seg1.destCenter.y, lowerLeftCenter.y, nil);
    STAssertTrue(seg1.isPlaySoundAtEnd, nil);
    
    ASAnimationSegment *seg2 = _savedSegments[1];
    STAssertEquals(seg2.destCenter.x, originalViewCenter.x, nil);
    STAssertEquals(seg2.destCenter.y, originalViewCenter.y, nil);
    STAssertFalse(seg2.isPlaySoundAtEnd, nil);
}

- (void)testHorizontalBounce_startsAnimationToUpperRightCenter {
    CGSize parentSize = _parentView.frame.size;
    CGPoint originalViewCenter = _viewBeingAnimated.center;
    CGPoint upperRightCenter = CGPointMake(parentSize.width - _viewBeingAnimated.bounds.size.width / 2,
                                          _viewBeingAnimated.bounds.size.height / 2);
    
    id wrapper = [OCMockObject partialMockForObject:_objUnderTest];
    [[[wrapper expect] andCall:@selector(saveAnimationSegments:) onObject:self] _beginAnimations:OCMOCK_ANY];
    
    [wrapper horizontalBounce:_viewBeingAnimated];
    
    [_mockDelegate verify];
    [wrapper verify];
    
    STAssertEquals([_savedSegments count], (NSUInteger)2, nil);
    
    ASAnimationSegment *seg1 = _savedSegments[0];
    STAssertEquals(seg1.destCenter.x, upperRightCenter.x, nil);
    STAssertEquals(seg1.destCenter.y, upperRightCenter.y, nil);
    STAssertTrue(seg1.isPlaySoundAtEnd, nil);
    
    ASAnimationSegment *seg2 = _savedSegments[1];
    STAssertEquals(seg2.destCenter.x, originalViewCenter.x, nil);
    STAssertEquals(seg2.destCenter.y, originalViewCenter.y, nil);
    STAssertFalse(seg2.isPlaySoundAtEnd, nil);
}

- (void)testFourCenterBounce_startsAnimationToFourCenters {
    CGSize parentSize = _parentView.frame.size;
    CGPoint originalViewCenter = _viewBeingAnimated.center;
    CGPoint lowerLeftCenter = CGPointMake(_viewBeingAnimated.bounds.size.width / 2,
                                          parentSize.height - _viewBeingAnimated.bounds.size.height / 2);
    CGPoint lowerRightCenter = CGPointMake(parentSize.width - _viewBeingAnimated.bounds.size.width / 2,
                                          parentSize.height - _viewBeingAnimated.bounds.size.height / 2);
    CGPoint upperRightCenter = CGPointMake(parentSize.width - _viewBeingAnimated.bounds.size.width / 2,
                                           _viewBeingAnimated.bounds.size.height / 2);
    
    id wrapper = [OCMockObject partialMockForObject:_objUnderTest];
    [[[wrapper expect] andCall:@selector(saveAnimationSegments:) onObject:self] _beginAnimations:OCMOCK_ANY];
    
    [wrapper fourCornerBounce:_viewBeingAnimated];
    
    [_mockDelegate verify];
    [wrapper verify];
    
    STAssertEquals([_savedSegments count], (NSUInteger)4, nil);
    
    ASAnimationSegment *seg1 = _savedSegments[0];
    STAssertEquals(seg1.destCenter.x, lowerLeftCenter.x, nil);
    STAssertEquals(seg1.destCenter.y, lowerLeftCenter.y, nil);
    STAssertTrue(seg1.isPlaySoundAtEnd, nil);
    
    ASAnimationSegment *seg2 = _savedSegments[1];
    STAssertEquals(seg2.destCenter.x, lowerRightCenter.x, nil);
    STAssertEquals(seg2.destCenter.y, lowerRightCenter.y, nil);
    STAssertTrue(seg2.isPlaySoundAtEnd, nil);
    
    ASAnimationSegment *seg3 = _savedSegments[2];
    STAssertEquals(seg3.destCenter.x, upperRightCenter.x, nil);
    STAssertEquals(seg3.destCenter.y, upperRightCenter.y, nil);
    STAssertTrue(seg3.isPlaySoundAtEnd, nil);
    
    ASAnimationSegment *seg4 = _savedSegments[3];
    STAssertEquals(seg4.destCenter.x, originalViewCenter.x, nil);
    STAssertEquals(seg4.destCenter.y, originalViewCenter.y, nil);
    STAssertFalse(seg4.isPlaySoundAtEnd, nil);
}

@end
