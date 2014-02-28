//
//  AtkSampleOneDropZoneScrollView.m
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "AtkSampleOneDropZoneScrollView.h"
#import "UIScrollView+AtkDragAndDrop.h"

@interface AtkSampleOneDropZoneScrollView ()

@property (nonatomic, strong) UIColor *savedBackgroundColor;

@end

@implementation AtkSampleOneDropZoneScrollView

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

- (BOOL)shouldDragStart:(AtkDragAndDropManager *)manager
{
    return YES;
}

- (void)dragStarted:(AtkDragAndDropManager *)manager
{
    NSLog(@"AtkSampleOneDropZoneScrollView.dragStarted");
    [self autoScrollDragStarted];
}

- (BOOL)isInterested:(AtkDragAndDropManager *)manager
{
    NSLog(@"AtkSampleOneDropZoneScrollView.isInterested");
    return YES;
}

- (void)dragEnded:(AtkDragAndDropManager *)manager
{
    NSLog(@"AtkSampleOneDropZoneScrollView.dragEnded");
    [self autoScrollDragEnded];
}

- (void)dragEntered:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    NSLog(@"AtkSampleOneDropZoneScrollView.dragEntered");
    self.savedBackgroundColor = self.backgroundColor;
    self.backgroundColor = [UIColor blueColor];
}

- (void)dragExited:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    NSLog(@"AtkSampleOneDropZoneScrollView.dragExited");
    self.backgroundColor = self.savedBackgroundColor;
}

- (void)dragMoved:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    [self autoScrollDragMoved:[manager.rootView convertPoint:point toView:self]];
}

- (void)dragDropped:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    NSLog(@"AtkSampleOneDropZoneScrollView.dragDropped");
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
