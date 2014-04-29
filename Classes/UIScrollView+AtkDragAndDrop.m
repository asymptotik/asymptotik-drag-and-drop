//
//  UIScrollView+AtkDragAndDrop.m
//  Atkdrogen_DragAndDrop
//
//  Created by Rick Boykin on 1/21/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import <objc/runtime.h>
#import "UIScrollView+AtkDragAndDrop.h"
#import "AtkDragAndDropManager.h"

static const void *AtkDragAndDropScrollViewPropertyHolderKey;
static const CGFloat kAtkAutoScrollEdgeTolleranceDefault = 80.0;
static const CGFloat kAtkAutoScrollMaxVelocityDefault = 4.0;
static const CGFloat kAtkAutoScrollVelocityDefault = 0.1;

@interface AtkDragAndDropScrollViewPropertyHolder : NSObject
    @property (nonatomic, assign) CGFloat autoScrollEdgeTollerance;
    @property (nonatomic, assign) CGFloat autoScrollVelocity;
    @property (nonatomic, assign) CGFloat autoScrollMaxVelocity;
    @property (nonatomic, assign) CGPoint autoScrollDragPinnedPoint;
    @property (nonatomic, assign) CGPoint autoScrollLastDragPoint;
    @property (nonatomic, strong) NSTimer *autoScrollTimer;
@end

@implementation AtkDragAndDropScrollViewPropertyHolder

- (id)init
{
    self = [super init];
    if(self)
    {
        self.autoScrollEdgeTollerance = kAtkAutoScrollEdgeTolleranceDefault;
        self.autoScrollVelocity = kAtkAutoScrollVelocityDefault;
        self.autoScrollMaxVelocity = kAtkAutoScrollMaxVelocityDefault;
    }
    
    return self;
}

@end

@implementation UIScrollView (AtkDragAndDrop)

- (CGFloat)autoScrollEdgeTollerance
{
    CGFloat ret = kAtkAutoScrollEdgeTolleranceDefault;
    AtkDragAndDropScrollViewPropertyHolder *result = (AtkDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &AtkDragAndDropScrollViewPropertyHolderKey);
    if (result != nil) {
        ret = result.autoScrollEdgeTollerance;
    }
    return ret;
}

- (void)setAutoScrollEdgeTollerance:(CGFloat)autoScrollEdgeTollerance
{
    AtkDragAndDropScrollViewPropertyHolder *result = (AtkDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &AtkDragAndDropScrollViewPropertyHolderKey);
    if (result == nil) {
        result = [[AtkDragAndDropScrollViewPropertyHolder alloc] init];
        objc_setAssociatedObject(self, &AtkDragAndDropScrollViewPropertyHolderKey, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    result.autoScrollEdgeTollerance = autoScrollEdgeTollerance;
}

- (CGFloat)autoScrollVelocity
{
    CGFloat ret = kAtkAutoScrollVelocityDefault;
    AtkDragAndDropScrollViewPropertyHolder *result = (AtkDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &AtkDragAndDropScrollViewPropertyHolderKey);
    if (result != nil) {
        ret = result.autoScrollVelocity;
    }
    return ret;
}

- (void)setAutoScrollVelocity:(CGFloat)autoScrollVelocity
{
    AtkDragAndDropScrollViewPropertyHolder *result = (AtkDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &AtkDragAndDropScrollViewPropertyHolderKey);
    if (result == nil) {
        result = [[AtkDragAndDropScrollViewPropertyHolder alloc] init];
        objc_setAssociatedObject(self, &AtkDragAndDropScrollViewPropertyHolderKey, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    result.autoScrollVelocity = autoScrollVelocity;
}

- (CGFloat)autoScrollMaxVelocity
{
    CGFloat ret = kAtkAutoScrollMaxVelocityDefault;
    AtkDragAndDropScrollViewPropertyHolder *result = (AtkDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &AtkDragAndDropScrollViewPropertyHolderKey);
    if (result != nil) {
        ret = result.autoScrollMaxVelocity;
    }
    return ret;
}

- (void)setAutoScrollMaxVelocity:(CGFloat)autoScrollMaxVelocity
{
    AtkDragAndDropScrollViewPropertyHolder *result = (AtkDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &AtkDragAndDropScrollViewPropertyHolderKey);
    if (result == nil) {
        result = [[AtkDragAndDropScrollViewPropertyHolder alloc] init];
        objc_setAssociatedObject(self, &AtkDragAndDropScrollViewPropertyHolderKey, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    result.autoScrollMaxVelocity = autoScrollMaxVelocity;
}

- (CGPoint)autoScrollDragPinnedPoint
{
    CGPoint ret = CGPointZero;
    AtkDragAndDropScrollViewPropertyHolder *result = (AtkDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &AtkDragAndDropScrollViewPropertyHolderKey);
    if (result != nil) {
        ret = result.autoScrollDragPinnedPoint;
    }
    return ret;
}

- (void)setAutoScrollDragPinnedPoint:(CGPoint)autoScrollDragPinnedPoint
{
    AtkDragAndDropScrollViewPropertyHolder *result = (AtkDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &AtkDragAndDropScrollViewPropertyHolderKey);
    if (result == nil) {
        result = [[AtkDragAndDropScrollViewPropertyHolder alloc] init];
        objc_setAssociatedObject(self, &AtkDragAndDropScrollViewPropertyHolderKey, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    result.autoScrollDragPinnedPoint = autoScrollDragPinnedPoint;
}

- (CGPoint)autoScrollLastDragPoint
{
    CGPoint ret = CGPointZero;
    AtkDragAndDropScrollViewPropertyHolder *result = (AtkDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &AtkDragAndDropScrollViewPropertyHolderKey);
    if (result != nil) {
        ret = result.autoScrollLastDragPoint;
    }
    return ret;
}

- (void)setAutoScrollLastDragPoint:(CGPoint)autoScrollLastDragPoint
{
    AtkDragAndDropScrollViewPropertyHolder *result = (AtkDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &AtkDragAndDropScrollViewPropertyHolderKey);
    if (result == nil) {
        result = [[AtkDragAndDropScrollViewPropertyHolder alloc] init];
        objc_setAssociatedObject(self, &AtkDragAndDropScrollViewPropertyHolderKey, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    result.autoScrollLastDragPoint = autoScrollLastDragPoint;
}

- (NSTimer *)autoScrollTimer
{
    NSTimer *ret = nil;
    AtkDragAndDropScrollViewPropertyHolder *result = (AtkDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &AtkDragAndDropScrollViewPropertyHolderKey);
    if (result != nil) {
        ret = result.autoScrollTimer;
    }
    return ret;
}

- (void)setAutoScrollTimer:(NSTimer *)timer
{
    AtkDragAndDropScrollViewPropertyHolder *result = (AtkDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &AtkDragAndDropScrollViewPropertyHolderKey);
    if (result == nil) {
        result = [[AtkDragAndDropScrollViewPropertyHolder alloc] init];
        objc_setAssociatedObject(self, &AtkDragAndDropScrollViewPropertyHolderKey, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    result.autoScrollTimer = timer;
}

/**
 * Given a point, this method calculates the scroll delta, or the amount the scroller should scroll
 * in both the x and y direction.
 */
- (CGPoint)autoScrollDelta:(CGPoint)point
{
    CGPoint delta                     = CGPointZero;
    CGFloat autoScrollEdgeTollerance  = self.autoScrollEdgeTollerance;
    CGFloat autoScrollVelocity        = self.autoScrollVelocity;
    CGPoint autoScrollDragPinnedPoint = self.autoScrollDragPinnedPoint;
    CGFloat autoScrollMaxVelocity     = self.autoScrollMaxVelocity;
    
    if(point.x < autoScrollEdgeTollerance)
    {
        // Our point is on the left edge of the scroller, within the given tolerance
        // We want to pin a point (autoScrollDragPinnedPoint) if that pin point is 0 or the
        // new point is to the right of the old point. When the new point is to the right
        // we do not scroll to the left. If we have a pin point and the new point is to the
        // left of that pin point, we then scroll left. This consideration of
        // where the new point is in relation to the pin point prevent us from scrolling
        // when we enter the UIScrollView with a drag operation. We actually have to
        // move in the direction we want to scroll. This makes a much more user friendly
        // drag/scroll operation.
        if(autoScrollDragPinnedPoint.x == 0.0 || point.x > autoScrollDragPinnedPoint.x)
        {
            autoScrollDragPinnedPoint = CGPointMake(point.x, autoScrollDragPinnedPoint.y);
        }
        else
        {
            delta.x = (point.x - autoScrollDragPinnedPoint.x) * autoScrollVelocity;
            if(delta.x < -autoScrollMaxVelocity) delta.x = -autoScrollMaxVelocity;
        }
    }
    else if(point.x > (self.frame.size.width - autoScrollEdgeTollerance))
    {
        if(autoScrollDragPinnedPoint.x == 0.0 || point.x < autoScrollDragPinnedPoint.x)
        {
            autoScrollDragPinnedPoint = CGPointMake(point.x, autoScrollDragPinnedPoint.y);
        }
        else
        {
            delta.x = (point.x - autoScrollDragPinnedPoint.x) * autoScrollVelocity;
            if(delta.x > autoScrollMaxVelocity) delta.x = autoScrollMaxVelocity;
        }
    }
    else
    {
        // We are not in scroll teritory on the x axis. Reset the x pin to 0.0.
        autoScrollDragPinnedPoint = CGPointMake(0.0, autoScrollDragPinnedPoint.y);
    }
    
    if(delta.x != 0.0)
    {
        if(self.contentOffset.x + delta.x < 0.0)
        {
            delta.x = -self.contentOffset.x;
        }
        else
        {
            CGFloat maxOffset =  self.contentSize.width - self.frame.size.width;
            if(maxOffset < 0.0)
                maxOffset = 0.0;
            
            if(self.contentOffset.x + delta.x > maxOffset)
                delta.x = maxOffset - self.contentOffset.x;
        }
    }
    
    if(point.y < autoScrollEdgeTollerance)
    {
        if(autoScrollDragPinnedPoint.y == 0.0 || point.y > autoScrollDragPinnedPoint.y)
        {
            autoScrollDragPinnedPoint = CGPointMake(autoScrollDragPinnedPoint.x, point.y);
        }
        else
        {
            delta.y = (point.y - autoScrollDragPinnedPoint.y) * autoScrollVelocity;
            if(delta.y < -autoScrollMaxVelocity) delta.y = -autoScrollMaxVelocity;
        }
    }
    else if(point.y > (self.frame.size.height - autoScrollEdgeTollerance))
    {
        if(autoScrollDragPinnedPoint.y == 0.0 || point.y < autoScrollDragPinnedPoint.y)
        {
            autoScrollDragPinnedPoint = CGPointMake(autoScrollDragPinnedPoint.x, point.y);
        }
        else
        {
            delta.y = (point.y - autoScrollDragPinnedPoint.y) * autoScrollVelocity;
            if(delta.y > autoScrollMaxVelocity) delta.y = autoScrollMaxVelocity;
        }
    }
    else
    {
        autoScrollDragPinnedPoint = CGPointMake(autoScrollDragPinnedPoint.x, 0.0);
    }
    
    if(delta.y != 0.0)
    {
        if(self.contentOffset.y + delta.y < 0.0)
        {
            delta.y = -self.contentOffset.y;
        }
        else
        {
            CGFloat maxOffset =  self.contentSize.height - self.frame.size.height;
            if(maxOffset < 0.0)
                maxOffset = 0.0;
            
            if(self.contentOffset.y + delta.y > maxOffset)
                delta.y = maxOffset - self.contentOffset.y;
        }
    }
    
    if(delta.x < 0.000001 && delta.x > -0.000001)
        delta.x = 0.0;
    
    if(delta.y < 0.000001 && delta.y > -0.000001)
        delta.y = 0.0;
    
    self.autoScrollDragPinnedPoint = autoScrollDragPinnedPoint;
    
    return delta;
}

- (void)autoScrollDragStarted
{
    self.autoScrollDragPinnedPoint = CGPointZero;
}

- (void)autoScrollDragMoved:(CGPoint)point
{
    //NSLog(@"AtkSampleOneDropZoneScrollView.dragMoved");
    
    CGPoint offset = self.contentOffset;
    NSTimer *autoScrollTimer = self.autoScrollTimer;
    
    //
    // iOS wants to convert the point to the content and not the UIScrollView frame. This
    // converts to the UIScrollView frame. Silly iOS.
    //
    point = CGPointMake(point.x - offset.x, point.y - offset.y);
    self.autoScrollLastDragPoint = point;
    
    if(autoScrollTimer)
        return;
    
    CGPoint autoScrollDelta = [self autoScrollDelta:point];

    if(!CGPointEqualToPoint(autoScrollDelta, CGPointZero))
    {
        CGPoint p = self.contentOffset;
        p.x += autoScrollDelta.x;
        p.y += autoScrollDelta.y;
        
        [self setContentOffset:p animated:NO];
        
        if(autoScrollTimer == nil)
            self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(autoScrollTimerTick:) userInfo:nil repeats:YES];
    }
    else if(autoScrollTimer)
    {
        [autoScrollTimer invalidate];
        self.autoScrollTimer = nil;
    }
}

- (void)autoScrollDragEnded
{
    if(self.autoScrollTimer)
    {
        [self.autoScrollTimer invalidate];
        self.autoScrollTimer = nil;
    }
}

- (void)autoScrollTimerTick:(NSTimer *)timer
{
    CGPoint autoScrollDelta = [self autoScrollDelta:self.autoScrollLastDragPoint];
    
    if(!CGPointEqualToPoint(autoScrollDelta, CGPointZero))
    {
        CGPoint p = self.contentOffset;
        p.x += autoScrollDelta.x;
        p.y += autoScrollDelta.y;
        
        [self setContentOffset:p animated:NO];
    }
    else if(self.autoScrollTimer)
    {
        [self.autoScrollTimer invalidate];
        self.autoScrollTimer = nil;
    }
}

@end
