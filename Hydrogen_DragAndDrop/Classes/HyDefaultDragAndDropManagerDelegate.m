//
//  HyDefaultDragAndDropManagerDelegate.m
//  Hydrogen_DragAndDrop
//
//  Created by Rick Boykin on 1/20/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "HyDefaultDragAndDropManagerDelegate.h"

@implementation HyDefaultDragAndDropManagerDelegate

/**
 * Finds the drag source.
 */
- (id<HyDragSourceProtocol>)findDragSource:(HyDragAndDropManager *)manager recognizer:(UIGestureRecognizer *)recognizer
{
    BOOL dragStarted = NO;
    
    UIView *hitView = [manager.rootView hitTest:[recognizer locationInView:manager.rootView] withEvent:nil];
    
    while(!dragStarted && hitView)
    {
        if([hitView conformsToProtocol:@protocol(HyDragSourceProtocol)])
        {
            if([hitView respondsToSelector:@selector(dragStarted)])
                dragStarted = [(UIView<HyDragSourceProtocol> *)hitView dragStarted];
            else
                dragStarted = YES;
        }
        
        if(!dragStarted)
        {
            hitView = hitView.superview;
        }
    }
    
    return dragStarted ? (id<HyDragSourceProtocol>)hitView : nil;
}

/**
 * Recursively finds any drop zones (id<HyDropZoneProtocol>) in view and it's descendents that are interested in the gesture recognizer
 * and adds them to dropZones. The return value is the passed in dropZones. If a drop zone is found and dropZones is nil, a new
 * NSMutableArray will be constructed, filled and returned.
 */
- (NSMutableArray *)findDropZonesInView:(UIView *)view recognizer:(UIGestureRecognizer *)recognizer dropZones:(NSMutableArray *)dropZones
{
    if([view conformsToProtocol:@protocol(HyDropZoneProtocol)] && [(id<HyDropZoneProtocol>)view dragStarted])
    {
        if(!dropZones)
            dropZones = [NSMutableArray array];
        
        [dropZones addObject:view];
    }
    
    for (UIView *subview in view.subviews)
    {
        dropZones = [self findDropZonesInView:subview recognizer:recognizer dropZones:dropZones];
    }
    
    return dropZones;
}

/**
 * Recursively finds any drop zones (id<HyDropZoneProtocol>) in rootView and it's descendents that are interested in the gesture
 * recognizer and returns them.
 */
- (NSArray *)findDropZones:(HyDragAndDropManager *)manager recognizer:(UIGestureRecognizer *)recognizer
{
    NSMutableArray *ret = [self findDropZonesInView:manager.rootView recognizer:recognizer dropZones:nil];
    return ret ? [NSArray arrayWithArray:ret] : nil;
}

/**
 * Returns YES is the specified drop zone is active for the recognizer. Active means that if the
 * drop event were to occur immediately, that drop zone would be dropped upon.
 */
- (BOOL)isDropZoneActive:(HyDragAndDropManager *)manager dropZone:(id<HyDropZoneProtocol>)dropZone recognizer:(UIGestureRecognizer *)recognizer
{
    BOOL ret = false;
    
    if([dropZone respondsToSelector:@selector(containsPoint:point:)])
    {
        ret = [dropZone containsPoint:manager.rootView point:[recognizer locationInView:manager.rootView]];
    }
    else if([dropZone isKindOfClass:[UIView class]])
    {
        UIView<HyDropZoneProtocol> *dropView = (UIView<HyDropZoneProtocol> *)dropZone;
        CGPoint pointRelativeToDropView = [recognizer locationInView:dropView];
        
        ret = [dropView pointInside:pointRelativeToDropView withEvent:nil];
    }
    
    return ret;
}

@end
