//
//  AtkDragAndDropLifecycleProtocol.h
//  AtkDragAndDrop_Examples
//
//  Created by Rick Boykin on 4/29/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AtkDragAndDropManager;
@protocol AtkDropZoneProtocol;


@protocol AtkDragAndDropLifecycleProtocol <NSObject>

@optional

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
