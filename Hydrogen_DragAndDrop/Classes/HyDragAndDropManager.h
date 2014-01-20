//
//  HyDragAndDropManager.h
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyDragSourceProtocol.h"

@class HyDragAndDropManager;

@protocol HyDragAndDropManagerDelegate <NSObject>

@required

/**
 * Finds the drag source based on the rootView and the recognizer.
 */
- (id<HyDragSourceProtocol>)findDragSource:(HyDragAndDropManager *)manager recognizer:(UIGestureRecognizer *)recognizer;

/**
 * Recursively finds any drop zones (id<HyDropZoneProtocol>) in rootView and it's descendents that are interested in the gesture
 * recognizer and returns them. In some cases the drag operation may include data set on the HyDragAndDropManagers UIPasteboard.
 * It's up to this method to determine if the drop zone is interested in the content of that UIPasteboard.
 */
- (NSArray *)findDropZones:(HyDragAndDropManager *)manager recognizer:(UIGestureRecognizer *)recognizer;

/**
 * Returns YES is the specified drop zone is active for the recognizer. Active means that if the
 * drop event were to occur immediately, that drop zone would be dropped upon. For example, if the 
 * current touch has dragged over the drop zone, the drop zone may then be active.
 */
- (BOOL)isDropZoneActive:(HyDragAndDropManager *)manager dropZone:(id<HyDropZoneProtocol>)dropZone recognizer:(UIGestureRecognizer *)recognizer;

@end

@interface HyDragAndDropManager : NSObject

extern NSString *const HyPasteboardNameDragAndDrop;

/**
 * The instance of HyDragAndDropManager.
 */
+ (HyDragAndDropManager *)instance;

/**
 * The HyDDragAndDropManager delegate.
 */
@property (nonatomic, retain) id<HyDragAndDropManagerDelegate> delegate;

/**
 * The pastbaord name. Defaults to HyPasteboardNameDragAndDrop which creates
 * a pastebaord unique to drag and drop. This may be changed to any unique name, including
 * the shared pastebaord.
 */
@property (nonatomic, retain) NSString* pasteboardName;

/**
 * Get the Drag and Drop pastebaord. The paasteboard is based on pasteboardName, which is configurable.
 */
@property (nonatomic, readonly) UIPasteboard* pasteboard;

/**
 * The root UIView as set by the call to start:(UIView *) or the UIApplication keyWindow
 * by default. All the players in the drag and drop scenerio must be descendants of rootView.
 */
@property (nonatomic, readonly) UIView* rootView;

/**
 * Starts the drag and drop manager. This sets up the gesture recognizer and UIApplication keyWindow
 * as the rootView.
 */
- (void)start;

/**
 * Starts the drag and drop manager. This sets up the gesture recognizer and the rootView.
 */
- (void)start:(UIView *)rootView;

/**
 * Stops the drag and drop manager. Any gesture recognizer is removed. Any drag operation in progress is ended.
 * The recognizer and rootViews are set to nil.
 */
- (void)stop;

@end
