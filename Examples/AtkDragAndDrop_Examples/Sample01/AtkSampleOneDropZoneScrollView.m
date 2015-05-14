//
//  AtkSampleOneDropZoneScrollView.m
//  AtkDragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
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

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

- (BOOL)dropZoneShouldDragStart:(AtkDragAndDropManager *)manager
{
    return YES;
}

- (void)dropZoneDragStarted:(AtkDragAndDropManager *)manager
{
    //NSLog(@"AtkSampleOneDropZoneScrollView.dragStarted");
    [self autoScrollDragStarted];
}

- (BOOL)dropZoneIsInterested:(AtkDragAndDropManager *)manager
{
    //NSLog(@"AtkSampleOneDropZoneScrollView.isInterested");
    return YES;
}

- (void)dropZoneDragEnded:(AtkDragAndDropManager *)manager
{
    //NSLog(@"AtkSampleOneDropZoneScrollView.dragEnded");
    [self autoScrollDragEnded];
}

- (void)dropZoneDragEntered:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    //NSLog(@"AtkSampleOneDropZoneScrollView.dragEntered");
    self.savedBackgroundColor = self.backgroundColor;
    self.backgroundColor = [UIColor blueColor];
}

- (void)dropZoneDragExited:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    //NSLog(@"AtkSampleOneDropZoneScrollView.dragExited");
    self.backgroundColor = self.savedBackgroundColor;
}

- (void)dropZoneDragMoved:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    [self autoScrollDragMoved:[manager.rootView convertPoint:point toView:self]];
}

- (void)dropZoneDragDropped:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    //NSLog(@"AtkSampleOneDropZoneScrollView.dragDropped");
    self.backgroundColor = [UIColor greenColor];
}

@end
