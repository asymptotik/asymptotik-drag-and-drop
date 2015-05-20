//
//  AtkDefaultDragAndDropManagerDelegate.m
//  Atkdrogen_DragAndDrop
//
//  Created by Rick Boykin on 1/20/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import "AtkDefaultDragAndDropManagerDelegate.h"
#import "UIView+AtkDragAndDrop.h"

@implementation AtkDefaultDragAndDropManagerDelegate

/**
 * Finds the drag source.
 */
- (id<AtkDragSourceProtocol>)findDragSource:(AtkDragAndDropManager *)manager recognizer:(UIGestureRecognizer *)recognizer
{
    BOOL dragStarted = NO;
    
    CGPoint point = [recognizer locationInView:manager.rootView];
    UIView *hitView = [manager.rootView hitTest:point withEvent:nil];
    
    while(!dragStarted && hitView)
    {
        if([hitView conformsToProtocol:@protocol(AtkDragSourceProtocol)])
        {
            if([hitView respondsToSelector:@selector(shouldDragStart:point:)])
                dragStarted = [(UIView<AtkDragSourceProtocol> *)hitView shouldDragStart:manager point: point];
            else
                dragStarted = YES;
        }
        
        if(!dragStarted)
        {
            hitView = hitView.superview;
        }
    }
    
    return dragStarted ? (id<AtkDragSourceProtocol>)hitView : nil;
}

/**
 * Recursively finds any drop zones (id<AtkDropZoneProtocol>) in view and it's descendants that are interested in the gesture recognizer
 * and adds them to dropZones. The return value is the passed in dropZones. If a drop zone is found and dropZones is nil, a new
 * NSMutableArray will be constructed, filled and returned.
 */
- (NSMutableArray *)findDropZones:(AtkDragAndDropManager *)manager view:(UIView *)view recognizer:(UIGestureRecognizer *)recognizer dropZones:(NSMutableArray *)dropZones
{
    if([view conformsToProtocol:@protocol(AtkDropZoneProtocol)] &&
       [view respondsToSelector:@selector(dropZoneShouldDragStart:)] &&
       [(id<AtkDropZoneProtocol>)view dropZoneShouldDragStart:manager])
    {
        if(!dropZones)
            dropZones = [NSMutableArray array];
        
        [dropZones addObject:view];
    }
    
    for (UIView *subview in view.subviews)
    {
        dropZones = [self findDropZones:manager view:subview recognizer:recognizer dropZones:dropZones];
    }
    
    return dropZones;
}

/**
 * Recursively finds any drop zones (id<AtkDropZoneProtocol>) in rootView and it's descendants that are interested in the gesture
 * recognizer and returns them.
 */
- (NSArray *)findDropZones:(AtkDragAndDropManager *)manager recognizer:(UIGestureRecognizer *)recognizer
{
    NSMutableArray *ret = [self findDropZones:manager view:manager.rootView recognizer:recognizer dropZones:nil];
    return ret ? [NSArray arrayWithArray:ret] : nil;
}

/**
 * Returns YES is the specified drop zone is active for the recognizer. Active means that if the
 * drop event were to occur immediately, that drop zone would be dropped upon.
 */
- (BOOL)isDropZoneActive:(AtkDragAndDropManager *)manager dropZone:(id<AtkDropZoneProtocol>)dropZone recognizer:(UIGestureRecognizer *)recognizer
{
    BOOL ret = false;
    
    if([dropZone respondsToSelector:@selector(dropZoneIsActive:point:)])
    {
        ret = [dropZone dropZoneIsActive:manager point:[recognizer locationInView:manager.rootView]];
    }
    else if([dropZone isKindOfClass:[UIView class]])
    {
        UIView *dropView = (UIView *)dropZone;
        ret = [dropView isActiveDropZone:manager point:[recognizer locationInView:manager.rootView]];
    }
    else if([dropZone isKindOfClass:[UIViewController class]])
    {
        UIView *dropView = ((UIViewController *)dropZone).view;
        ret = [dropView isActiveDropZone:manager point:[recognizer locationInView:manager.rootView]];
    }

    return ret;
}

@end
