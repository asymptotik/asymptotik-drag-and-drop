//
//  BcvDropScrollView.m
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "BcvDropScrollView.h"

@interface BcvDropScrollView ()

@property (nonatomic, retain) UIColor *savedBackgroundColor;
@property (nonatomic, assign) CGPoint lastDragPoint;
@property (nonatomic, retain) NSTimer *scrollTimer;

@end

@implementation BcvDropScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _autoScrollEdgeTollerance = 30.0;
        _autoScrollVelocity = 0.25;
        
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        _autoScrollEdgeTollerance = 30.0;
        _autoScrollVelocity = 0.25;
        
        // Initialization code
    }
    return self;
}

- (BOOL)dragStarted
{
    NSLog(@"BcvDropScrollView.dragStarted");
    
    //UIPasteboard *pastebaord = [BcvDragAndDropManager instance].pasteboard;
    
    return true;
}

- (void)dragEnded
{
    NSLog(@"BcvDropScrollView.dragEnded");
}

- (void)dragEntered:(CGPoint)point
{
    NSLog(@"BcvDropScrollView.dragEntered");
    self.savedBackgroundColor = self.backgroundColor;
    self.backgroundColor = [UIColor blueColor];
}

- (void)dragExited:(CGPoint)point
{
    NSLog(@"BcvDropScrollView.dragExited");
    self.backgroundColor = self.savedBackgroundColor;
}

- (CGPoint)scrollDelta:(CGPoint)point
{
    CGPoint delta = CGPointZero;
    
    if(point.x < _autoScrollEdgeTollerance)
    {
        delta.x = -(_autoScrollEdgeTollerance - point.y) * _autoScrollVelocity;
    }
    else if(point.x > (self.frame.size.width - _autoScrollEdgeTollerance))
    {
        delta.x = (point.x - self.frame.size.width + _autoScrollEdgeTollerance) * _autoScrollVelocity;
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
    
    if(point.y < _autoScrollEdgeTollerance)
    {
        delta.y = -(_autoScrollEdgeTollerance - point.y) * _autoScrollVelocity;
    }
    else if(point.y > (self.frame.size.height - _autoScrollEdgeTollerance))
    {
        delta.y = (point.y - self.frame.size.height + _autoScrollEdgeTollerance) * _autoScrollVelocity;
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
    
    return delta;
}

- (void)dragMoved:(CGPoint)point
{
    //NSLog(@"BcvDropScrollView.dragMoved");
    
    _lastDragPoint = [[BcvDragAndDropManager instance] convertPoint:point toView:self];
    CGPoint offset = self.contentOffset;
    
    //
    // iOS want to convert the point to the content and not the UIScrollView frame. This
    // converts to the UIScrollView frame. Silly iOS.
    //
    _lastDragPoint.x -= offset.x;
    _lastDragPoint.y -= offset.y;
    
    CGPoint scrollDelta = [self scrollDelta:_lastDragPoint];
    NSLog(@"BcvDropScrollView.dragMoved:point: %f %f delta: %f %f", _lastDragPoint.x, _lastDragPoint.y, scrollDelta.x, scrollDelta.y);
    
    if(!CGPointEqualToPoint(scrollDelta, CGPointZero))
    {
        CGPoint p = self.contentOffset;
        p.x += scrollDelta.x;
        p.y += scrollDelta.y;
        
        [self setContentOffset:p animated:NO];
        
        if(_scrollTimer == nil)
            self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    }
    else if(_scrollTimer)
    {
        [_scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}

- (void)tick:(NSTimer *)timer
{
    CGPoint scrollDelta = [self scrollDelta:_lastDragPoint];
    NSLog(@"BcvDropScrollView.dragMoved:point: %f %f delta: %f %f", _lastDragPoint.x, _lastDragPoint.y, scrollDelta.x, scrollDelta.y);
    
    if(!CGPointEqualToPoint(scrollDelta, CGPointZero))
    {
        CGPoint p = self.contentOffset;
        p.x += scrollDelta.x;
        p.y += scrollDelta.y;
        
        [self setContentOffset:p animated:NO];
    }
    else if(_scrollTimer)
    {
        [_scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}


- (void)dragDropped:(CGPoint)point
{
    NSLog(@"BcvDropScrollView.dragDropped");
    self.backgroundColor = [UIColor greenColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
