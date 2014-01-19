//
//  BcvDropView.m
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "BcvDropView.h"

@interface BcvDropView ()

@property (nonatomic, retain) UIColor *savedBackgroundColor;

@end

@implementation BcvDropView

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
    //NSLog(@"BcvDropView.dragStarted");
    
    //UIPasteboard *pastebaord = [BcvDragAndDropManager instance].pasteboard;
    
    return true;
}

- (void)dragEnded
{
    //NSLog(@"BcvDropView.dragEnded");
}

- (void)dragEntered:(CGPoint)point
{
    //NSLog(@"BcvDropView.dragEntered");
    self.savedBackgroundColor = self.backgroundColor;
    self.backgroundColor = [UIColor orangeColor];
}

- (void)dragExited:(CGPoint)point
{
    //NSLog(@"BcvDropView.dragExited");
    self.backgroundColor = self.savedBackgroundColor;
}

- (void)dragMoved:(CGPoint)point
{
    //NSLog(@"BcvDropView.dragMoved");
}

- (void)dragDropped:(CGPoint)point
{
    //NSLog(@"BcvDropView.dragDropped");
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
