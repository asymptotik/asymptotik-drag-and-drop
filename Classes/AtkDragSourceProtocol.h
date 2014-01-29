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

- (BOOL)dragStarted:(AtkDragAndDropManager *)manager;
- (void)dragEnded:(AtkDragAndDropManager *)manager;
- (UIView *)createDragShadowView:(AtkDragAndDropManager *)manager;

- (void)dragStarted:(AtkDragAndDropManager *)manager dropZone:(id<AtkDropZoneProtocol>) dropZone;
- (void)dragEnded:(AtkDragAndDropManager *)manager dropZone:(id<AtkDropZoneProtocol>) dropZone;
- (void)dragEntered:(AtkDragAndDropManager *)manager dropZone:(id<AtkDropZoneProtocol>) dropZone point:(CGPoint)point;
- (void)dragExited:(AtkDragAndDropManager *)manager dropZone:(id<AtkDropZoneProtocol>) dropZone point:(CGPoint)point;
- (void)dragMoved:(AtkDragAndDropManager *)manager dropZone:(id<AtkDropZoneProtocol>) dropZone point:(CGPoint)point;
- (void)dragDropped:(AtkDragAndDropManager *)manager dropZone:(id<AtkDropZoneProtocol>) dropZone point:(CGPoint)point;

@end
