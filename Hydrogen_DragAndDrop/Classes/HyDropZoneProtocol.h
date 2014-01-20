//
//  HyDropZoneProtocol.h
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HyDropZoneProtocol <NSObject>

@optional

- (BOOL)containsPoint:(UIView *)baseView point:(CGPoint)point;

/**
 * A drag has started and dragStarted returned YES. Should we consider this drop zone interested in receiving
 * the following calls dragEntered, dragExited, dragMoved, dragDropped and dragEnded.
 */
- (BOOL)isInterested;

@required

/**
 * A drag has started, should we consider this drop zone. A drop zone that is considered
 * will receive calls, as appropriate, to isInterested and dragEnded
 */
- (BOOL)dragStarted;

/*
 * called on all drop zones that responded YES to dragStarted when the drag operation has ended. This will
 * be called last in the lifecycle of HyDragAndDrop.
 */
- (void)dragEnded;

/*
 * Called when the drag has entered the drop zone.
 */
- (void)dragEntered:(CGPoint)point;

/*
 * Called when the drag has exited the drop zone.
 */
- (void)dragExited:(CGPoint)point;

/*
 * Called when the drag is in the drop zone and has moved.
 */
- (void)dragMoved:(CGPoint)point;

/*
 * called when the drag is in the drop zone and has been dropped.
 */
- (void)dragDropped:(CGPoint)point;

@end
