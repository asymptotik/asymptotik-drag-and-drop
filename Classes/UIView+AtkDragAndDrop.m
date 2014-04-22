//
//  UIView+DragAndDrop.m
//  AtkDragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import "UIView+AtkDragAndDrop.h"
#import "UIView+AtkImage.h"
#import "AtkDragAndDropManager.h"

@implementation UIView (DragAndDrop)

- (UIView *)createDefaultDragShadowView:(AtkDragAndDropManager *)manager
{
    UIImage *image = [self imageFromView];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGRect frame = imageView.frame;
    frame.origin = [self convertPoint:self.bounds.origin toView:manager.rootView];
    imageView.frame = frame;
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
