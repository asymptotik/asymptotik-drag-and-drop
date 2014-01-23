//
//  UIView+Image.h
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Image)

/**
 * Creates and autoreleased image from self.
 */
- (UIImage*)imageFromView;

@end
