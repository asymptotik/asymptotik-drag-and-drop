//
//  UIView+DragAndDrop.m
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "UIView+HyDragAndDrop.h"
#import "UIView+HyImage.h"

@implementation UIView (DragAndDrop)

- (UIView *)createDefaultDragShadowView
{
    UIImage *image = [self imageFromView];
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
    imageView.alpha = 0.5;
    return imageView;
}

@end
