//
//  UIView+DragAndDrop.m
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "UIView+DragAndDrop.h"
#import "UIView+Image.h"

@implementation UIView (DragAndDrop)

- (UIView *)createDefaultDragShadowView
{
    UIImage *image = [self imageFromView];
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
    return imageView;
}

@end
