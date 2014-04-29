//
//  AtkSampleOneDragSourceView.m
//  AtkDragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import "AtkSampleOneDragSourceView.h"
#import "AtkDragAndDropManager.h"

@interface AtkSampleOneDragSourceView()

@end

@implementation AtkSampleOneDragSourceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dragWillStart:(AtkDragAndDropManager *)manager
{
    manager.pasteboard.string = [NSString stringWithFormat:@"val-%ld", (long)self.tag];
}

@end
