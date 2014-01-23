//
//  HyDropZoneProtocol.h
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HyDragAndDropManager;

@protocol HyDropZoneProtocol <NSObject>

@optional

- (BOOL)isActive:(HyDragAndDropManager *)manager point:(CGPoint)point;

/**
 * A drag has started and dragStarted returned YES. Should we consider this drop zone interested in receiving
 * the following calls dragEntered, dragExited, dragMoved, dragDropped and dragEnded.
 */
- (BOOL)isInterested:(HyDragAndDropManager *)manager;

@required

/**
 * A drag has started, should we consider this drop zone. A drop zone that is considered
 * will receive calls, as appropriate, to isInterested and dragEnded
 */
- (BOOL)dragStarted:(HyDragAndDropManager *)manager;

/*
 * called on all drop zones that responded YES to dragStarted when the drag operation has ended. This will
 * be called last in the lifecycle of HyDragAndDrop.
 */
- (void)dragEnded:(HyDragAndDropManager *)manager;

/*
 * Called when the drag has entered the drop zone.
 */
- (void)dragEntered:(HyDragAndDropManager *)manager point:(CGPoint)point;

/*
 * Called when the drag has exited the drop zone.
 */
- (void)dragExited:(HyDragAndDropManager *)manager point:(CGPoint)point;

/*
 * Called when the drag is in the drop zone and has moved.
 */
- (void)dragMoved:(HyDragAndDropManager *)manager point:(CGPoint)point;

/*
 * called when the drag is in the drop zone and has been dropped.
 */
- (void)dragDropped:(HyDragAndDropManager *)manager point:(CGPoint)point;

@end
