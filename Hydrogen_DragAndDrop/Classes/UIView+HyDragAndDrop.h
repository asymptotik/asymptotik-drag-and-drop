//
//  UIView+DragAndDrop.h
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HyDragAndDrop.h"

@interface UIView (HyDragAndDrop)

/**
 * Creates a UIView based on self that is a UIImageView with an image
 * of self to be used as the drag shadow for self.
 */
- (UIView *)createDefaultDragShadowView;

/**
 * determine if this view can be considered active by the HyDragAndDropManager based on the location of point
 * point is give relative to manager.rootView, not this view.
 */
- (BOOL)isActiveDropZone:(HyDragAndDropManager *)manager point:(CGPoint)point;

@end
