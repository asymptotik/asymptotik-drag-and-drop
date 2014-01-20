//
//  HyDragSourceProtocol.h
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyDropZoneProtocol.h"

@protocol HyDragSourceProtocol <NSObject>

@optional

- (BOOL)dragStarted;
- (void)dragEnded;
- (UIView *)createDragShadowView;

- (void)dragStartedOnDropZone:(id<HyDropZoneProtocol>) dropZone;
- (void)dragEndedOnDropZone:(id<HyDropZoneProtocol>) dropZone;
- (void)dragEnteredDropZone:(id<HyDropZoneProtocol>) dropZone point:(CGPoint)point;
- (void)dragExitedDropZone:(id<HyDropZoneProtocol>) dropZone point:(CGPoint)point;
- (void)dragMovedOnDropZone:(id<HyDropZoneProtocol>) dropZone point:(CGPoint)point;
- (void)dragDroppedOnDropZone:(id<HyDropZoneProtocol>) dropZone point:(CGPoint)point;

@end
