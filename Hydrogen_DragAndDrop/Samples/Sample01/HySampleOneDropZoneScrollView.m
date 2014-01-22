//
//  HySampleOneDropZoneScrollView.m
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "HySampleOneDropZoneScrollView.h"
#import "UIScrollView+HyDragAndDrop.h"

@interface HySampleOneDropZoneScrollView ()

@property (nonatomic, retain) UIColor *savedBackgroundColor;

@end

@implementation HySampleOneDropZoneScrollView

- (id)init
{
    self = [super init];
    if(self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
}

- (BOOL)dragStarted
{
    NSLog(@"HySampleOneDropZoneScrollView.dragStarted");
    [self autoScrollDragStarted];
    return YES;
}

- (BOOL)isInterested
{
    NSLog(@"HySampleOneDropZoneScrollView.isInterested");
    return YES;
}

- (void)dragEnded
{
    NSLog(@"HySampleOneDropZoneScrollView.dragEnded");
    [self autoScrollDragEnded];
}

- (void)dragEntered:(CGPoint)point
{
    NSLog(@"HySampleOneDropZoneScrollView.dragEntered");
    self.savedBackgroundColor = self.backgroundColor;
    self.backgroundColor = [UIColor blueColor];
}

- (void)dragExited:(CGPoint)point
{
    NSLog(@"HySampleOneDropZoneScrollView.dragExited");
    self.backgroundColor = self.savedBackgroundColor;
}

- (void)dragMoved:(CGPoint)point
{
    [self autoScrollDragMoved:[[HyDragAndDropManager instance].rootView convertPoint:point toView:self]];
}

- (void)dragDropped:(CGPoint)point
{
    NSLog(@"HySampleOneDropZoneScrollView.dragDropped");
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
