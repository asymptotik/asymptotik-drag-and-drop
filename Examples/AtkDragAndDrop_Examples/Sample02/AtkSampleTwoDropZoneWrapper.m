//
//  AtkSampleTwoDropZoneWrapper.m
//  Atkdrogen_DragAndDrop
//
//  Created by Rick Boykin on 1/21/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import "AtkSampleTwoDropZoneWrapper.h"
#import "AtkDragAndDrop.h"

@interface AtkSampleTwoDropZoneWrapper()

@property (nonatomic, strong) UIColor *savedBackgroundColor;

@end

@implementation AtkSampleTwoDropZoneWrapper

- (id)initWithView:(UIView *)view
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

- (BOOL)dropZoneIsActive:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    return [self.view isActiveDropZone:manager point:point];
}

- (BOOL)dropZoneShouldDragStart:(AtkDragAndDropManager *)manager
{
    return YES;
}

- (BOOL)dropZoneIsInterested:(AtkDragAndDropManager *)manager
{
    //NSLog(@"AtkSampleOneDropZoneView.dragStarted");
    UIPasteboard *pastebaord = manager.pasteboard;
    NSString *tagValue = [NSString stringWithFormat:@"val-%ld", (long)self.view.tag];
    NSString *pasteboardString = pastebaord.string;
    
    return [tagValue isEqualToString:pasteboardString];
}

- (void)dropZoneDragStarted:(AtkDragAndDropManager *)manager
{
    //NSLog(@"AtkSampleOneDropZoneView.dragStarted");
    self.savedBackgroundColor = self.view.backgroundColor;

    UIPasteboard *pastebaord = manager.pasteboard;
    NSString *tagValue = [NSString stringWithFormat:@"val-%ld", (long)self.view.tag];
    NSString *pasteboardString = pastebaord.string;
    
    if([tagValue isEqualToString:pasteboardString])
    {
        self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    }
    else
    {
        self.view.backgroundColor = [UIColor redColor];
    }
}

- (void)dropZoneDragEnded:(AtkDragAndDropManager *)manager
{
    //NSLog(@"AtkSampleOneDropZoneView.dragEnded");
    [self performSelector:@selector(delayEnd) withObject:nil afterDelay:0.4];
}

- (void)dropZoneDragEntered:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    //NSLog(@"AtkSampleOneDropZoneView.dragEntered");
    self.view.backgroundColor = [UIColor orangeColor];
}

- (void)dropZoneDragExited:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    //NSLog(@"AtkSampleOneDropZoneView.dragExited");
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
}

- (void)dropZoneDragMoved:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    //NSLog(@"AtkSampleOneDropZoneView.dragMoved");
}

- (void)dropZoneDragDropped:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    //NSLog(@"AtkSampleOneDropZoneView.dragDropped");
    self.view.backgroundColor = [UIColor magentaColor];
}

- (void)delayEnd
{
    self.view.backgroundColor = self.savedBackgroundColor;
}

@end
