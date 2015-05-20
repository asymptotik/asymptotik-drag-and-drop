//
//  AtkSampleTwoDragSourceWrapper.m
//  Atkdrogen_DragAndDrop
//
//  Created by Rick Boykin on 1/21/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
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
    }
    return self;
}

- (BOOL)shouldDragStart:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    return YES;
}

- (void)dragWillStart:(AtkDragAndDropManager *)manager
{
    manager.pasteboard.string = [NSString stringWithFormat:@"val-%ld", (long)self.view.tag];
}

- (UIView *)createDragShadowView:(AtkDragAndDropManager *)manager
{
    return [self.view createDefaultDragShadowView:manager];
}

@end
