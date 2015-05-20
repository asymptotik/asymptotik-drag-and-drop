//
//  AtkDropZoneProtocol.h
//  AtkDragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AtkDragAndDropManager;

@protocol AtkDropZoneProtocol <NSObject>

@optional

/**
 * Should the drop zone be considered active for the manager and point.
 */
- (BOOL)dropZoneIsActive:(AtkDragAndDropManager *)manager point:(CGPoint)point;

/**
 * A drag has started, should we consider this drop zone. A drop zone that is considered
 * will receive calls, as appropriate, to isInterested, dragStarted and dragEnded but not
 * dragEntered, dragExited, dragMoved and dragDropped
 */
- (BOOL)dropZoneShouldDragStart:(AtkDragAndDropManager *)manager;

/**
 * A drag has started and shouldDropStart returned YES. Should we consider this drop zone interested in receiving
 * the following calls dragEntered, dragExited, dragMoved, dragDropped in addition to dragStarted and dragEnded.
 */
- (BOOL)dropZoneIsInterested:(AtkDragAndDropManager *)manager;

/*
 * Called on all drop zones that responded YES to dragStarted when the drag operation has started. This will
 * be soon after shouldDropStart responds YES.
 */
- (void)dropZoneDragStarted:(AtkDragAndDropManager *)manager;

/*
 * Called on all drop zones that responded YES to dragStarted when the drag operation has ended. This will
 * be called last in the lifecycle of AtkDragAndDrop.
 */
- (void)dropZoneDragEnded:(AtkDragAndDropManager *)manager;

/*
 * Called when the drag has entered the drop zone.
 */
- (void)dropZoneDragEntered:(AtkDragAndDropManager *)manager point:(CGPoint)point;

/*
 * Called when the drag has exited the drop zone.
 */
- (void)dropZoneDragExited:(AtkDragAndDropManager *)manager point:(CGPoint)point;

/*
 * Called when the drag is in the drop zone and has moved.
 */
- (void)dropZoneDragMoved:(AtkDragAndDropManager *)manager point:(CGPoint)point;

/*
 * called when the drag is in the drop zone and has been dropped.
 */
- (void)dropZoneDragDropped:(AtkDragAndDropManager *)manager point:(CGPoint)point;

@end
