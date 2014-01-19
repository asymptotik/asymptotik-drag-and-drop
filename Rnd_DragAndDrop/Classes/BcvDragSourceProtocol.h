//
//  BcvDragSourceProtocol.h
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BcvDropZoneProtocol.h"

@protocol BcvDragSourceProtocol <NSObject>

@optional

- (BOOL)dragStarted;
- (void)dragEnded;
- (UIView *)createDragShadowView;

- (void)dragStartedOnDropZone:(id<BcvDropZoneProtocol>) dropZone;
- (void)dragEndedOnDropZone:(id<BcvDropZoneProtocol>) dropZone;
- (void)dragEnteredDropZone:(id<BcvDropZoneProtocol>) dropZone point:(CGPoint)point;
- (void)dragExitedDropZone:(id<BcvDropZoneProtocol>) dropZone point:(CGPoint)point;
- (void)dragMovedOnDropZone:(id<BcvDropZoneProtocol>) dropZone point:(CGPoint)point;
- (void)dragDroppedOnDropZone:(id<BcvDropZoneProtocol>) dropZone point:(CGPoint)point;

@end
