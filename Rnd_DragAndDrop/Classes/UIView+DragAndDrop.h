//
//  UIView+DragAndDrop.h
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DragAndDrop)

/**
 * Creates a UIView based on self that is a UIImageView with an image
 * of self to be used as the drag shadow for self.
 */
- (UIView *)createDefaultDragShadowView;

@end
