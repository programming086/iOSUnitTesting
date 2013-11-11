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

- (void)test_beginAnimations_setsUpAndStarts {
    ASAnimationSegment *seg1 = [[ASAnimationSegment alloc] initWithPoint:CGPointMake(10, 10) playSoundAtEnd:YES];
    ASAnimationSegment *seg2 = [[ASAnimationSegment alloc] initWithPoint:CGPointMake(0, 0) playSoundAtEnd:NO];
    
    _objUnderTest.currentSegmentIndex = 99; // make sure it gets reset
    
    id wrapper = [OCMockObject partialMockForObject:_objUnderTest];
    [[wrapper expect] _beginCurrentAnimationSegment];
    
    [wrapper _beginAnimations:@[seg1, seg2]];
    
    [wrapper verify];
    STAssertEquals([wrapper currentSegmentIndex], (NSUInteger)0, nil);
    
    NSArray *segments = [wrapper animationSegments];
    
    STAssertEquals(segments.count, (NSUInteger)2, nil);
    STAssertEquals(segments[0], seg1, nil);
    STAssertEquals(segments[1], seg2, nil);
}

- (void)test_beginCurrentAnimationSegment_animatesAndCallsback {
    CGPoint endViewCenter = CGPointMake(10, 20);
    ASAnimationSegment *seg1 = [[ASAnimationSegment alloc] initWithPoint:endViewCenter playSoundAtEnd:YES];
    _objUnderTest.animationSegments = @[seg1];
    _objUnderTest.viewBeingAnimated = _viewBeingAnimated;
    
    id wrapper = [OCMockObject partialMockForObject:_objUnderTest];
    [[wrapper expect] _currentAnimationSegmentEnded:NO];
    
    [wrapper _beginCurrentAnimationSegment];
    
    [self waitForAnimation];
    
    [wrapper verify];
    
    CGPoint viewCenter = _viewBeingAnimated.center;
    STAssertEquals(viewCenter.x, endViewCenter.x, nil);
    STAssertEquals(viewCenter.y, endViewCenter.y, nil);
}

- (void)test_currentAnimationSegmentEnded_resetsAndDoesntPlayIfNotSuccessful {
    CGPoint originalViewCenter = _viewBeingAnimated.center;
    
    // so we can make sure it doesn't play
    ASAnimationSegment *seg1 = [[ASAnimationSegment alloc] initWithPoint:CGPointMake(100, 100) playSoundAtEnd:YES];
    
    _viewBeingAnimated.center = CGPointMake(99, 99);    // so we can see if it's reset
    _objUnderTest.viewBeingAnimated = _viewBeingAnimated;
    _objUnderTest.animationSegments = @[seg1];
    
    id wrapper = [OCMockObject partialMockForObject:_objUnderTest];
    [[wrapper reject] _beginCurrentAnimationSegment];
    [[wrapper reject] _playBounceSound];
    
    [[_mockDelegate expect] animationComplete];
    
    [wrapper _currentAnimationSegmentEnded:NO];
    
    [_mockDelegate verify];
    [wrapper verify];
    STAssertEquals(_viewBeingAnimated.center.x, originalViewCenter.x, nil);
    STAssertEquals(_viewBeingAnimated.center.y, originalViewCenter.y, nil);
}

- (void)test_currentAnimationSegmentEnded_startsNextSegmentWithPlayIfNotLast {
    ASAnimationSegment *seg1 = [[ASAnimationSegment alloc] initWithPoint:CGPointMake(100, 100) playSoundAtEnd:YES];
    ASAnimationSegment *seg2 = [[ASAnimationSegment alloc] initWithPoint:CGPointMake(0, 0) playSoundAtEnd:YES];
    ASAnimationSegment *seg3 = [[ASAnimationSegment alloc] initWithPoint:CGPointMake(5, 5) playSoundAtEnd:NO];
    
    _objUnderTest.viewBeingAnimated = _viewBeingAnimated;
    _objUnderTest.animationSegments = @[seg1, seg2, seg3];
    _objUnderTest.currentSegmentIndex = 1;
    
    id wrapper = [OCMockObject partialMockForObject:_objUnderTest];
    [[wrapper expect] _beginCurrentAnimationSegment];
    [[wrapper expect] _playBounceSound];
    
    [wrapper _currentAnimationSegmentEnded:YES];
    
    [wrapper verify];
    STAssertEquals([wrapper currentSegmentIndex], (NSUInteger)2, nil);
}

- (void)test_currentAnimationSegmentEnded_startsNextSegmentWithoutPlayIfNotLast {
    ASAnimationSegment *seg1 = [[ASAnimationSegment alloc] initWithPoint:CGPointMake(100, 100) playSoundAtEnd:YES];
    ASAnimationSegment *seg2 = [[ASAnimationSegment alloc] initWithPoint:CGPointMake(0, 0) playSoundAtEnd:NO];
    ASAnimationSegment *seg3 = [[ASAnimationSegment alloc] initWithPoint:CGPointMake(5, 5) playSoundAtEnd:NO];
    
    _objUnderTest.viewBeingAnimated = _viewBeingAnimated;
    _objUnderTest.animationSegments = @[seg1, seg2, seg3];
    _objUnderTest.currentSegmentIndex = 1;
    
    id wrapper = [OCMockObject partialMockForObject:_objUnderTest];
    [[wrapper expect] _beginCurrentAnimationSegment];
    [[wrapper reject] _playBounceSound];
    
    [wrapper _currentAnimationSegmentEnded:YES];
    
    [wrapper verify];
    STAssertEquals([wrapper currentSegmentIndex], (NSUInteger)2, nil);
}

- (void)test_currentAnimationSegmentEnded_handlesLastSegmentWithPlay {
    ASAnimationSegment *seg1 = [[ASAnimationSegment alloc] initWithPoint:CGPointMake(100, 100) playSoundAtEnd:YES];
    ASAnimationSegment *seg2 = [[ASAnimationSegment alloc] initWithPoint:CGPointMake(0, 0) playSoundAtEnd:YES];
    
    _objUnderTest.viewBeingAnimated = _viewBeingAnimated;
    _objUnderTest.animationSegments = @[seg1, seg2];
    _objUnderTest.currentSegmentIndex = 1;
    
    id wrapper = [OCMockObject partialMockForObject:_objUnderTest];
    [[wrapper reject] _beginCurrentAnimationSegment];
    [[wrapper expect] _playBounceSound];
    
    [[_mockDelegate expect] animationComplete];
    
    [wrapper _currentAnimationSegmentEnded:YES];
    
    [wrapper verify];
}

- (void)test_currentAnimationSegmentEnded_handlesLastSegmentWithoutPlay {
    ASAnimationSegment *seg1 = [[ASAnimationSegment alloc] initWithPoint:CGPointMake(100, 100) playSoundAtEnd:YES];
    ASAnimationSegment *seg2 = [[ASAnimationSegment alloc] initWithPoint:CGPointMake(0, 0) playSoundAtEnd:NO];
    
    _objUnderTest.viewBeingAnimated = _viewBeingAnimated;
    _objUnderTest.animationSegments = @[seg1, seg2];
    _objUnderTest.currentSegmentIndex = 1;
    
    id wrapper = [OCMockObject partialMockForObject:_objUnderTest];
    [[wrapper reject] _beginCurrentAnimationSegment];
    [[wrapper reject] _playBounceSound];
    
    [[_mockDelegate expect] animationComplete];
    
    [wrapper _currentAnimationSegmentEnded:YES];
    
    [wrapper verify];
}

@end
