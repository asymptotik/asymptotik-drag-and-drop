//
//  AtkSampleThreeDragSourceView.m
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "AtkSampleThreeDragSourceView.h"
#import "AtkDragAndDropManager.h"

@interface AtkSampleThreeDragSourceView()

@end

@implementation AtkSampleThreeDragSourceView

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

- (BOOL)shouldDragStart:(AtkDragAndDropManager *)manager
{
    return YES;
}

- (void)dragWillStart:(AtkDragAndDropManager *)manager
{
    manager.pasteboard.string = [NSString stringWithFormat:@"val-%ld", (long)self.tag];
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
