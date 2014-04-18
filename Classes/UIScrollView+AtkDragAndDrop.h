//
//  UIScrollView+AtkDragAndDrop.h
//  Atkdrogen_DragAndDrop
//
//  Created by Rick Boykin on 1/21/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (AtkDragAndDrop)

@property (nonatomic, assign) CGFloat autoScrollEdgeTollerance;
@property (nonatomic, assign) CGFloat autoScrollVelocity;
@property (nonatomic, assign) CGFloat autoScrollMaxVelocity;

// Notifies the UIScrollView that dragging has started.
- (void)autoScrollDragStarted;

// allows the UIScrollView to monitor the drag movemment and scroll appropriately
// point should be converted to the UIScrollView coordinates using
// [rootView convertPoint:point toView:uiScrollView] from whatever rootView
// coordinate system point was originally in.
- (void)autoScrollDragMoved:(CGPoint)point;

// Notifies the UIScrollView that dragging has ended.
- (void)autoScrollDragEnded;

@end
