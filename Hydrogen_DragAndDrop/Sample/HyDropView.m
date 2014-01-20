//
//  HyDropView.m
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "HyDropView.h"

@interface HyDropView ()

@property (nonatomic, retain) UIColor *savedBackgroundColor;

@end

@implementation HyDropView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)dragStarted
{
    return YES;
}

- (BOOL)isInterested
{
    //NSLog(@"HyDropView.dragStarted");
    
    BOOL ret = NO;
    UIPasteboard *pastebaord = [HyDragAndDropManager instance].pasteboard;
    NSString *tagValue = [NSString stringWithFormat:@"val-%d", self.tag];
    NSString *pasteboardString = pastebaord.string;
    
    if([tagValue isEqualToString:pasteboardString])
        ret = YES;
    
    self.savedBackgroundColor = self.backgroundColor;
    
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

- (void)dragEnded
{
    //NSLog(@"HyDropView.dragEnded");
    [self performSelector:@selector(delayEnd) withObject:nil afterDelay:0.2];
}

- (void)delayEnd
{
    self.backgroundColor = self.savedBackgroundColor;
}

- (void)dragEntered:(CGPoint)point
{
    //NSLog(@"HyDropView.dragEntered");
    self.backgroundColor = [UIColor orangeColor];
}

- (void)dragExited:(CGPoint)point
{
    //NSLog(@"HyDropView.dragExited");
    self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
}

- (void)dragMoved:(CGPoint)point
{
    //NSLog(@"HyDropView.dragMoved");
}

- (void)dragDropped:(CGPoint)point
{
    //NSLog(@"HyDropView.dragDropped");
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
