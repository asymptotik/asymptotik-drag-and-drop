//
//  HySampleOneDragSourceView.m
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "HySampleOneDragSourceView.h"
#import "HyDragAndDropManager.h"

@interface HySampleOneDragSourceView()

@end

@implementation HySampleOneDragSourceView

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


- (BOOL)dragStarted:(HyDragAndDropManager *)manager
{
    manager.pasteboard.string = [NSString stringWithFormat:@"val-%ld", (long)self.tag];;
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
