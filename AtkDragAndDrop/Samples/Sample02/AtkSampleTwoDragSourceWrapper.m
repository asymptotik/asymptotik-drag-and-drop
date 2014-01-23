//
//  AtkSampleTwoDragSourceWrapper.m
//  Atkdrogen_DragAndDrop
//
//  Created by Rick Boykin on 1/21/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "AtkSampleTwoDragSourceWrapper.h"
#import "UIView+AtkDragAndDrop.h"

@implementation AtkSampleTwoDragSourceWrapper

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

- (BOOL)dragStarted:(AtkDragAndDropManager *)manager
{
    manager.pasteboard.string = [NSString stringWithFormat:@"val-%ld", (long)self.view.tag];;
    return YES;
}

- (UIView *)createDragShadowView:(AtkDragAndDropManager *)manager
{
    return [self.view createDefaultDragShadowView];
}

@end
