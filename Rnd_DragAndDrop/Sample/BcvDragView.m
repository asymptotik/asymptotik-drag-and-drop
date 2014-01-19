//
//  BcvDragView.m
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "BcvDragView.h"
#import "BcvDragAndDropManager.h"

@interface BcvDragView()

@end

@implementation BcvDragView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initialize
{

}

- (void)dealloc
{
    [super dealloc];
}


- (BOOL)dragStarted
{
    UIPasteboard *pasteboard = [BcvDragAndDropManager instance].pasteboard;
    [pasteboard setValue:@"string" forPasteboardType:@"com.comcast.bcv.test"];
    return YES;
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
