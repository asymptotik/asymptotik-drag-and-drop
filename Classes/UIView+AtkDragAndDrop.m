//
//  UIView+DragAndDrop.m
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "UIView+AtkDragAndDrop.h"
#import "UIView+AtkImage.h"
#import "AtkDragAndDropManager.h"

@implementation UIView (DragAndDrop)

- (UIView *)createDefaultDragShadowView
{
    UIImage *image = [self imageFromView];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.alpha = 0.5;
    return imageView;
}

- (BOOL)isActiveDropZone:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    UIView *view = self;
    BOOL ret = YES;
    
    // We can safely assume point is within rootView.
    
    while(ret == YES && manager.rootView != view)
    {
        CGPoint pointRelativeToView = [manager.rootView convertPoint:point toView:view];
        ret = ret && [view pointInside:pointRelativeToView withEvent:nil];
        view = view.superview;
    }
    
    return ret;
}

@end
