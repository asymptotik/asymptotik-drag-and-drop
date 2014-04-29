//
//  AtkDragSourceProtocol.h
//  AtkDragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtkDropZoneProtocol.h"
#import "AtkDragAndDropLifecycleProtocol.h"

@class AtkDragAndDropManager;

@protocol AtkDragSourceProtocol <AtkDragAndDropLifecycleProtocol>

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

@end
