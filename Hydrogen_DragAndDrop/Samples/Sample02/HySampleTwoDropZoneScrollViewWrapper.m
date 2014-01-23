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

- (BOOL)isActive:(HyDragAndDropManager *)manager point:(CGPoint)point
{
    return [self.view isActiveDropZone:manager point:point];
}

- (BOOL)dragStarted:(HyDragAndDropManager *)manager
{
    NSLog(@"HySampleOneDropZoneScrollView.dragStarted");
    [self.view autoScrollDragStarted];
    return YES;
}

- (BOOL)isInterested:(HyDragAndDropManager *)manager
{
    NSLog(@"HySampleOneDropZoneScrollView.isInterested");
    return YES;
}

- (void)dragEnded:(HyDragAndDropManager *)manager
{
    NSLog(@"HySampleOneDropZoneScrollView.dragEnded");
    [self.view autoScrollDragEnded];
}

- (void)dragEntered:(HyDragAndDropManager *)manager point:(CGPoint)point
{
    NSLog(@"HySampleOneDropZoneScrollView.dragEntered");
    self.savedBackgroundColor = self.view.backgroundColor;
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)dragExited:(HyDragAndDropManager *)manager point:(CGPoint)point
{
    NSLog(@"HySampleOneDropZoneScrollView.dragExited");
    self.view.backgroundColor = self.savedBackgroundColor;
}

- (void)dragMoved:(HyDragAndDropManager *)manager point:(CGPoint)point
{
    [self.view autoScrollDragMoved:[manager.rootView convertPoint:point toView:self.view]];
}

- (void)dragDropped:(HyDragAndDropManager *)manager point:(CGPoint)point
{
    NSLog(@"HySampleOneDropZoneScrollView.dragDropped");
    self.view.backgroundColor = [UIColor greenColor];
}

@end
