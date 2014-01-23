//
//  HyDragSourceProtocol.h
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyDropZoneProtocol.h"

@class HyDragAndDropManager;

@protocol HyDragSourceProtocol <NSObject>

@optional

- (BOOL)dragStarted:(HyDragAndDropManager *)manager;
- (void)dragEnded:(HyDragAndDropManager *)manager;
- (UIView *)createDragShadowView:(HyDragAndDropManager *)manager;

- (void)dragStarted:(HyDragAndDropManager *)manager dropZone:(id<HyDropZoneProtocol>) dropZone;
- (void)dragEnded:(HyDragAndDropManager *)manager dropZone:(id<HyDropZoneProtocol>) dropZone;
- (void)dragEntered:(HyDragAndDropManager *)manager dropZone:(id<HyDropZoneProtocol>) dropZone point:(CGPoint)point;
- (void)dragExited:(HyDragAndDropManager *)manager dropZone:(id<HyDropZoneProtocol>) dropZone point:(CGPoint)point;
- (void)dragMoved:(HyDragAndDropManager *)manager dropZone:(id<HyDropZoneProtocol>) dropZone point:(CGPoint)point;
- (void)dragDropped:(HyDragAndDropManager *)manager dropZone:(id<HyDropZoneProtocol>) dropZone point:(CGPoint)point;

@end
