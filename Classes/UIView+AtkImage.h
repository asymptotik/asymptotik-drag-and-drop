//
//  UIView+Image.h
//  AtkDragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Image)

/**
 * Creates and autoreleased image from self.
 */
- (UIImage*)imageFromView;

@end
