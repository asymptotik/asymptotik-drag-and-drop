//
//  AtkDragAndDropManager.h
//  AtkDragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtkDragSourceProtocol.h"

@class AtkDragAndDropManager;

@protocol AtkDragAndDropManagerDelegate <NSObject>

@optional

/**
 * Finds the drag source based on the rootView and the recognizer. If not implemented the default is used.
 */
- (id<AtkDragSourceProtocol>)findDragSource:(AtkDragAndDropManager *)manager recognizer:(UIGestureRecognizer *)recognizer;

/**
 * Recursively finds any drop zones (id<AtkDropZoneProtocol>) in rootView and it's descendents that are interested in the gesture
 * recognizer and returns them. In some cases the drag operation may include data set on the AtkDragAndDropManagers UIPasteboard.
 * It's up to this method to determine if the drop zone is interested in the content of that UIPasteboard.
 *
 * If not implemented the default is used.
 */
- (NSArray *)findDropZones:(AtkDragAndDropManager *)manager recognizer:(UIGestureRecognizer *)recognizer;

/**
 * Returns YES is the specified drop zone is active for the recognizer. Active means that if the
 * drop event were to occur immediately, that drop zone would be dropped upon. For example, if the 
 * current touch has dragged over the drop zone, the drop zone may then be active.
 *
 * If not implemented the default is used.
 */
- (BOOL)isDropZoneActive:(AtkDragAndDropManager *)manager dropZone:(id<AtkDropZoneProtocol>)dropZone recognizer:(UIGestureRecognizer *)recognizer;

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

@interface AtkDragAndDropManager : NSObject

extern NSString *const AtkPasteboardNameDragAndDrop;

/**
 * The AtkDDragAndDropManager delegate.
 */
@property (nonatomic, weak) id<AtkDragAndDropManagerDelegate> delegate;

/**
 * The pastbaord name. Defaults to AtkPasteboardNameDragAndDrop which creates
 * a pastebaord unique to drag and drop. This may be changed to any unique name, including
 * the shared pastebaord.
 */
@property (nonatomic, strong) NSString* pasteboardName;

/**
 * Get the Drag and Drop pastebaord. The paasteboard is based on pasteboardName, which is configurable.
 */
@property (weak, nonatomic, readonly) UIPasteboard* pasteboard;

/**
 * The root UIView as set by the call to start:(UIView *) or the UIApplication keyWindow
 * by default. All the players in the drag and drop scenerio must be descendants of rootView.
 */
- (UIView*)rootView;

/**
 * Starts the drag and drop manager. This sets up the gesture recognizer and UIApplication keyWindow
 * as the rootView.
 */
- (void)start;

/**
 * Starts the drag and drop manager. This sets up the rootView.
 */
- (void)start:(UIView *)rootView;

/**
 * Starts the drag and drop manager. This sets up the gesture recognizer and the rootView.
 */
- (void)start:(UIView *)rootView recognizerClass:(Class)recognizerClass;

/**
 * Stops the drag and drop manager. Any gesture recognizer is removed. Any drag operation in progress is ended.
 * The recognizer and rootViews are set to nil.
 */
- (void)stop;

#pragma mark - Protected

/**
 * Find the drag source by calling on the delegate. If the delegate does no implement findDragSource: then the default
 * delegate is used.
 */
- (id<AtkDragSourceProtocol>)findDragSource:(UIGestureRecognizer *)recognizer;

/**
 * Find the drop zones by calling on the delegate. If the delegate does no implement findDropZones: then the default
 * delegate is used.
 */
- (NSArray *)findDropZones:(UIGestureRecognizer *)recognizer;

/**
 * Determine if the drop zone is active. Typically active means that the touch point in the recognizer is over the drop zone.
 * Here (and/or in the delegate, it is possible to change that meaning)
 * If the delegate does no implement isDropZoneActive:recognizer: then the default delegate is used.
 */
- (BOOL)isDropZoneActive:(id<AtkDropZoneProtocol>)dropZone recognizer:(UIGestureRecognizer *)recognizer;

//
// Notifications for the drag and drop lifecycle. 
//

/**
 * Called when a drag has started but before searching for drop zones.
 * If overriding in a subclass the super method should be called to ensure proper functionality.
 */
- (void)dragWillStart;

/**
 * Called when a drag has started. 
 * If overriding in a subclass the super method should be called to ensure proper functionality.
 */
- (void)dragStarted;

/**
 * Called when a drag has ended.
 * If overriding in a subclass the super method should be called to ensure proper functionality.
 */
- (void)dragEnded;

/**
 * Called when a drag has endtered a drop zone.
 * If overriding in a subclass the super method should be called to ensure proper functionality.
 */
- (void)dragEntered:(id<AtkDropZoneProtocol>) dropZone point:(CGPoint)point;

/**
 * Called when a drag has exited a drop zone.
 * If overriding in a subclass the super method should be called to ensure proper functionality.
 */
- (void)dragExited:(id<AtkDropZoneProtocol>) dropZone point:(CGPoint)point;

/**
 * Called when a drag has moved within a drop zone. Only called after dragEntered and before dragExited.
 * If overriding in a subclass the super method should be called to ensure proper functionality.
 */
- (void)dragMoved:(id<AtkDropZoneProtocol>) dropZone point:(CGPoint)point;

/**
 * Called when a drag is dropped onto a drop zone.
 * If overriding in a subclass the super method should be called to ensure proper functionality.
 */
- (void)dragDropped:(id<AtkDropZoneProtocol>) dropZone point:(CGPoint)point;

@end
