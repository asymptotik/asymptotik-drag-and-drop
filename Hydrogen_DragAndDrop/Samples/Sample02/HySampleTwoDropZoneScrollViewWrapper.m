//
//  HySampleTwoDropZoneScrollViewWrapper.m
//  Hydrogen_DragAndDrop
//
//  Created by Rick Boykin on 1/21/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "HySampleTwoDropZoneScrollViewWrapper.h"
#import "UIScrollView+HyDragAndDrop.h"

@interface HySampleTwoDropZoneScrollViewWrapper ()

@property (nonatomic, retain) UIColor *savedBackgroundColor;

@end

@implementation HySampleTwoDropZoneScrollViewWrapper

- (id)initWithScrollView:(UIScrollView *)view
{
    self = [super init];
    if(self)
    {
        self.view = view;
        [self initialize];
    }
    return self;
}

- (void)initialize
{
}

- (BOOL)containsPoint:(UIView *)baseView point:(CGPoint)point
{
    CGPoint pointRelativeToDropView = [baseView convertPoint:point toView:self.view];
    return [self.view pointInside:pointRelativeToDropView withEvent:nil];
}

- (BOOL)dragStarted
{
    NSLog(@"HySampleOneDropZoneScrollView.dragStarted");
    [self.view autoScrollDragStarted];
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
    [self.view autoScrollDragEnded];
}

- (void)dragEntered:(CGPoint)point
{
    NSLog(@"HySampleOneDropZoneScrollView.dragEntered");
    self.savedBackgroundColor = self.view.backgroundColor;
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)dragExited:(CGPoint)point
{
    NSLog(@"HySampleOneDropZoneScrollView.dragExited");
    self.view.backgroundColor = self.savedBackgroundColor;
}

- (void)dragMoved:(CGPoint)point
{
    [self.view autoScrollDragMoved:[[HyDragAndDropManager instance].rootView convertPoint:point toView:self.view]];
}

- (void)dragDropped:(CGPoint)point
{
    NSLog(@"HySampleOneDropZoneScrollView.dragDropped");
    self.view.backgroundColor = [UIColor greenColor];
}

@end
