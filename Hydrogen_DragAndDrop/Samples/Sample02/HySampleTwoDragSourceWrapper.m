//
//  HySampleTwoDragSourceWrapper.m
//  Hydrogen_DragAndDrop
//
//  Created by Rick Boykin on 1/21/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "HySampleTwoDragSourceWrapper.h"
#import "UIView+HyDragAndDrop.h"

@implementation HySampleTwoDragSourceWrapper

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

- (BOOL)dragStarted
{
    [HyDragAndDropManager instance].pasteboard.string = [NSString stringWithFormat:@"val-%ld", (long)self.view.tag];;
    return YES;
}

- (UIView *)createDragShadowView
{
    return [self.view createDefaultDragShadowView];
}

@end
