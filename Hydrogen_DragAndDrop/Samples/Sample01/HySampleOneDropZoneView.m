//
//  HySampleOneDropZoneView.m
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "HySampleOneDropZoneView.h"

@interface HySampleOneDropZoneView ()

@property (nonatomic, retain) UIColor *savedBackgroundColor;

@end

@implementation HySampleOneDropZoneView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)dragStarted:(HyDragAndDropManager *)manager
{
    self.savedBackgroundColor = self.backgroundColor;
    return YES;
}

- (BOOL)isInterested:(HyDragAndDropManager *)manager
{
    //NSLog(@"HySampleOneDropZoneView.isInterested");
    
    BOOL ret = NO;
    UIPasteboard *pastebaord = manager.pasteboard;
    NSString *tagValue = [NSString stringWithFormat:@"val-%ld", (long)self.tag];
    NSString *pasteboardString = pastebaord.string;
    
    if([tagValue isEqualToString:pasteboardString])
        ret = YES;
    
    if(ret)
    {
        self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    }
    else
    {
        self.backgroundColor = [UIColor redColor];
    }
    
    return ret;
}

- (void)dragEnded:(HyDragAndDropManager *)manager
{
    //NSLog(@"HySampleOneDropZoneView.dragEnded");
    [self performSelector:@selector(delayEnd) withObject:nil afterDelay:0.2];
}

- (void)delayEnd
{
    self.backgroundColor = self.savedBackgroundColor;
}

- (void)dragEntered:(HyDragAndDropManager *)manager point:(CGPoint)point
{
    //NSLog(@"HySampleOneDropZoneView.dragEntered");
    self.backgroundColor = [UIColor orangeColor];
}

- (void)dragExited:(HyDragAndDropManager *)manager point:(CGPoint)point
{
    //NSLog(@"HySampleOneDropZoneView.dragExited");
    self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
}

- (void)dragMoved:(HyDragAndDropManager *)manager point:(CGPoint)point
{
    //NSLog(@"HySampleOneDropZoneView.dragMoved");
}

- (void)dragDropped:(HyDragAndDropManager *)manager point:(CGPoint)point
{
    //NSLog(@"HySampleOneDropZoneView.dragDropped");
    self.backgroundColor = [UIColor magentaColor];
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
