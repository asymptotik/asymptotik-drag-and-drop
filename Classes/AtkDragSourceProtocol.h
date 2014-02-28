//
//  AtkDragSourceProtocol.h
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtkDropZoneProtocol.h"

@class AtkDragAndDropManager;

@protocol AtkDragSourceProtocol <NSObject>

@optional

- (UIView *)createDragShadowView:(AtkDragAndDropManager *)manager;

/**
 * Called to determine if dragging should start on this drag source.
 */
- (BOOL)shouldDragStart:(AtkDragAndDropManager *)manager;

/**
 * Called when a drag source has been found, but before searching for drop zones.
 */
- (void)dragWillStart:(AtkDragAndDropManager *)manager;

/**
 * Called when a drag has started. All of the interested drop zoned have been found.
 */
- (void)dragStarted:(AtkDragAndDropManager *)manager;

/**
 * Called when a drag has ended.
 */
- (void)dragEnded:(AtkDragAndDropManager *)manager;

/**
 * Called when a drag has entered a drop zone.
 */
- (void)dragEntered:(AtkDragAndDropManager *)manager dropZone:(id<AtkDropZoneProtocol>) dropZone point:(CGPoint)point;

/**
 * Called when a drag has exited a drop zone.
 */
- (void)dragExited:(AtkDragAndDropManager *)manager dropZone:(id<AtkDropZoneProtocol>) dropZone point:(CGPoint)point;

/**
 * Called when a drag has moved within a drop zone. Only called after dragEntered and before dragExited.
 */
- (void)dragMoved:(AtkDragAndDropManager *)manager dropZone:(id<AtkDropZoneProtocol>) dropZone point:(CGPoint)point;

/**
 * Called when a drag is dropped onto a drop zone.
 */
- (void)dragDropped:(AtkDragAndDropManager *)manager dropZone:(id<AtkDropZoneProtocol>) dropZone point:(CGPoint)point;

@end
