//
//  UIScrollView+HyDragAndDrop.m
//  Hydrogen_DragAndDrop
//
//  Created by Rick Boykin on 1/21/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import <objc/runtime.h>
#import "UIScrollView+HyDragAndDrop.h"
#import "HyDragAndDropManager.h"

static const void *HyDragAndDropScrollViewPropertyHolderKey;
static const CGFloat kHyAutoScrollEdgeTolleranceDefault = 80.0;
static const CGFloat kHyAutoScrollMaxVelocityDefault = 4.0;
static const CGFloat kHyAutoScrollVelocityDefault = 0.1;

@interface HyDragAndDropScrollViewPropertyHolder : NSObject
    @property (nonatomic, assign) CGFloat autoScrollEdgeTollerance;
    @property (nonatomic, assign) CGFloat autoScrollVelocity;
    @property (nonatomic, assign) CGFloat autoScrollMaxVelocity;
    @property (nonatomic, assign) CGPoint autoScrollDragPinnedPoint;
    @property (nonatomic, assign) CGPoint autoScrollLastDragPoint;
    @property (nonatomic, retain) NSTimer *autoScrollTimer;
@end

@implementation HyDragAndDropScrollViewPropertyHolder

- (id)init
{
    self = [super init];
    if(self)
    {
        self.autoScrollEdgeTollerance = kHyAutoScrollEdgeTolleranceDefault;
        self.autoScrollVelocity = kHyAutoScrollVelocityDefault;
        self.autoScrollMaxVelocity = kHyAutoScrollMaxVelocityDefault;
    }
    
    return self;
}

@end

@implementation UIScrollView (HyDragAndDrop)

- (CGFloat)autoScrollEdgeTollerance
{
    CGFloat ret = kHyAutoScrollEdgeTolleranceDefault;
    HyDragAndDropScrollViewPropertyHolder *result = (HyDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &HyDragAndDropScrollViewPropertyHolderKey);
    if (result != nil) {
        ret = result.autoScrollEdgeTollerance;
    }
    return ret;
}

- (void)setAutoScrollEdgeTollerance:(CGFloat)autoScrollEdgeTollerance
{
    HyDragAndDropScrollViewPropertyHolder *result = (HyDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &HyDragAndDropScrollViewPropertyHolderKey);
    if (result == nil) {
        result = [[[HyDragAndDropScrollViewPropertyHolder alloc] init] autorelease];
        objc_setAssociatedObject(self, &HyDragAndDropScrollViewPropertyHolderKey, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    result.autoScrollEdgeTollerance = autoScrollEdgeTollerance;
}

- (CGFloat)autoScrollVelocity
{
    CGFloat ret = kHyAutoScrollVelocityDefault;
    HyDragAndDropScrollViewPropertyHolder *result = (HyDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &HyDragAndDropScrollViewPropertyHolderKey);
    if (result != nil) {
        ret = result.autoScrollVelocity;
    }
    return ret;
}

- (void)setAutoScrollVelocity:(CGFloat)autoScrollVelocity
{
    HyDragAndDropScrollViewPropertyHolder *result = (HyDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &HyDragAndDropScrollViewPropertyHolderKey);
    if (result == nil) {
        result = [[[HyDragAndDropScrollViewPropertyHolder alloc] init] autorelease];
        objc_setAssociatedObject(self, &HyDragAndDropScrollViewPropertyHolderKey, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    result.autoScrollVelocity = autoScrollVelocity;
}

- (CGFloat)autoScrollMaxVelocity
{
    CGFloat ret = kHyAutoScrollMaxVelocityDefault;
    HyDragAndDropScrollViewPropertyHolder *result = (HyDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &HyDragAndDropScrollViewPropertyHolderKey);
    if (result != nil) {
        ret = result.autoScrollMaxVelocity;
    }
    return ret;
}

- (void)setAutoScrollMaxVelocity:(CGFloat)autoScrollMaxVelocity
{
    HyDragAndDropScrollViewPropertyHolder *result = (HyDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &HyDragAndDropScrollViewPropertyHolderKey);
    if (result == nil) {
        result = [[[HyDragAndDropScrollViewPropertyHolder alloc] init] autorelease];
        objc_setAssociatedObject(self, &HyDragAndDropScrollViewPropertyHolderKey, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    result.autoScrollMaxVelocity = autoScrollMaxVelocity;
}

- (CGPoint)autoScrollDragPinnedPoint
{
    CGPoint ret = CGPointZero;
    HyDragAndDropScrollViewPropertyHolder *result = (HyDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &HyDragAndDropScrollViewPropertyHolderKey);
    if (result != nil) {
        ret = result.autoScrollDragPinnedPoint;
    }
    return ret;
}

- (void)setAutoScrollDragPinnedPoint:(CGPoint)autoScrollDragPinnedPoint
{
    HyDragAndDropScrollViewPropertyHolder *result = (HyDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &HyDragAndDropScrollViewPropertyHolderKey);
    if (result == nil) {
        result = [[[HyDragAndDropScrollViewPropertyHolder alloc] init] autorelease];
        objc_setAssociatedObject(self, &HyDragAndDropScrollViewPropertyHolderKey, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    result.autoScrollDragPinnedPoint = autoScrollDragPinnedPoint;
}

- (CGPoint)autoScrollLastDragPoint
{
    CGPoint ret = CGPointZero;
    HyDragAndDropScrollViewPropertyHolder *result = (HyDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &HyDragAndDropScrollViewPropertyHolderKey);
    if (result != nil) {
        ret = result.autoScrollLastDragPoint;
    }
    return ret;
}

- (void)setAutoScrollLastDragPoint:(CGPoint)autoScrollLastDragPoint
{
    HyDragAndDropScrollViewPropertyHolder *result = (HyDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &HyDragAndDropScrollViewPropertyHolderKey);
    if (result == nil) {
        result = [[[HyDragAndDropScrollViewPropertyHolder alloc] init] autorelease];
        objc_setAssociatedObject(self, &HyDragAndDropScrollViewPropertyHolderKey, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    result.autoScrollLastDragPoint = autoScrollLastDragPoint;
}

- (NSTimer *)autoScrollTimer
{
    NSTimer *ret = nil;
    HyDragAndDropScrollViewPropertyHolder *result = (HyDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &HyDragAndDropScrollViewPropertyHolderKey);
    if (result != nil) {
        ret = result.autoScrollTimer;
    }
    return ret;
}

- (void)setAutoScrollTimer:(NSTimer *)timer
{
    HyDragAndDropScrollViewPropertyHolder *result = (HyDragAndDropScrollViewPropertyHolder *)objc_getAssociatedObject(self, &HyDragAndDropScrollViewPropertyHolderKey);
    if (result == nil) {
        result = [[[HyDragAndDropScrollViewPropertyHolder alloc] init] autorelease];
        objc_setAssociatedObject(self, &HyDragAndDropScrollViewPropertyHolderKey, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
    NSLog(@"HySampleOneDropZoneScrollView.autoScrollDragStarted");
    self.autoScrollDragPinnedPoint = CGPointZero;
}

- (void)autoScrollDragMoved:(CGPoint)point
{
    //NSLog(@"HySampleOneDropZoneScrollView.dragMoved");
    
    CGPoint offset = self.contentOffset;
    NSTimer *autoScrollTimer = self.autoScrollTimer;
    
    //
    // iOS wants to convert the point to the content and not the UIScrollView frame. This
    // converts to the UIScrollView frame. Silly iOS.
    //
    point = CGPointMake(point.x - offset.x, point.y - offset.y);
    self.autoScrollLastDragPoint = point;
    
    CGPoint autoScrollDelta = [self autoScrollDelta:point];
    NSLog(@"HySampleOneDropZoneScrollView.autoScrollDragMoved:point: %f %f delta: %f %f", point.x, point.y, autoScrollDelta.x, autoScrollDelta.y);
    
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
    NSLog(@"HySampleOneDropZoneScrollView.autoScrollDragEnded");
    if(self.autoScrollTimer)
    {
        [self.autoScrollTimer invalidate];
        self.autoScrollTimer = nil;
    }
}

- (void)autoScrollTimerTick:(NSTimer *)timer
{
    CGPoint autoScrollDelta = [self autoScrollDelta:self.autoScrollLastDragPoint];
    NSLog(@"HySampleOneDropZoneScrollView.dragMoved:point: %f %f delta: %f %f", self.autoScrollLastDragPoint.x, self.autoScrollLastDragPoint.y, autoScrollDelta.x, autoScrollDelta.y);
    
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
