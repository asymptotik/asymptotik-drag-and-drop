//
//  AtkDragAndDropManager.m
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "AtkDragAndDropManager.h"
#import "UIView+AtkDragAndDrop.h"
#import "AtkDropZoneProtocol.h"
#import "AtkDropZoneWrapper.h"
#import "AtkDefaultDragAndDropManagerDelegate.h"

@interface AtkDragAndDropManager ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, strong) id<AtkDragSourceProtocol> dragSource;
@property (nonatomic, strong) UIView *dragShadowView;
@property (nonatomic, strong) UIPanGestureRecognizer *recognizer;
@property (nonatomic, strong) NSArray *uninterestedDropZones;
@property (nonatomic, strong) NSArray *interestedDropZones;
@property (nonatomic, strong) id<AtkDragAndDropManagerDelegate> defaultDelegate;
@property (weak, nonatomic, readonly) id<AtkDragAndDropManagerDelegate> activeDelegate;

@end

@implementation AtkDragAndDropManager

NSString *const AtkPasteboardNameDragAndDrop = @"com.comcast.bcv.draganddrop.pasteboard";

- (id)init
{
    if((self = [super init]))
    {
        self.pasteboardName = AtkPasteboardNameDragAndDrop;
    }
    
    return self;
}

- (void)dealloc
{
    self.dragSource = nil;
    self.dragShadowView = nil;
    
}

- (void)start
{
    NSLog(@"AtkDragAndDropManager.start");
    
    [self start:[[UIApplication sharedApplication] keyWindow]];
}

- (void)start:(UIView *)rootView
{
    NSLog(@"AtkDragAndDropManager.start:");
    [self start:rootView recognizerClass:[UIPanGestureRecognizer class]];
}

- (void)start:(UIView *)rootView recognizerClass:(Class)recognizerClass
{
    NSLog(@"AtkDragAndDropManager.start:recognizerClass:");
    
    assert([recognizerClass isSubclassOfClass:[UIGestureRecognizer class]]);
    
    if(_rootView)
        [self stop];
    
    if(rootView)
    {
        
        self.rootView = rootView;
        self.recognizer = [[recognizerClass alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        self.recognizer.delegate = self;
        [self.rootView addGestureRecognizer:self.recognizer];
    }
}

- (void)stop
{
    if(self.recognizer && self.rootView)
    {
        [self.rootView removeGestureRecognizer:self.recognizer];
    }
    
    if(self.dragSource)
    {
        [self dragEnded:nil];
    }
    
    self.recognizer = nil;
    self.rootView = nil;
}

- (UIPasteboard *)pasteboard
{
    return [UIPasteboard pasteboardWithName:self.pasteboardName create:YES];
}

#pragma mark - private methods

- (id<AtkDragSourceProtocol>)findDragSource:(UIGestureRecognizer *)recognizer
{
    return [self.activeDelegate findDragSource:self recognizer:recognizer];
}

- (NSArray *)findDropZones:(UIGestureRecognizer *)recognizer
{
    return [self.activeDelegate findDropZones:self recognizer:recognizer];
}

- (BOOL)isDropZoneActive:(id<AtkDropZoneProtocol>)dropZone recognizer:(UIGestureRecognizer *)recognizer
{
    return [self.activeDelegate isDropZoneActive:self dropZone:dropZone recognizer:recognizer];
}

/**
 * Sets the drag source.
 */
- (void)setDragSource:(id<AtkDragSourceProtocol>)dragSource
{
    if(_dragSource != dragSource)
    {
        _dragSource = dragSource;
        
        if(_dragSource)
        {
            if([_dragSource respondsToSelector:@selector(createDragShadowView:)])
                self.dragShadowView = [_dragSource createDragShadowView:self];
            else if([_dragSource respondsToSelector:@selector(createDefaultDragShadowView)])
                self.dragShadowView = [_dragSource performSelector:@selector(createDefaultDragShadowView)];
        }
        else
        {
            self.dragShadowView = nil;
        }
    }
}

/**
 * Sets the drag shadow view.
 */
- (void)setDragShadowView:(UIView *)view
{
    if(_dragShadowView != view)
    {
        if(_dragShadowView)
        {
            [_dragShadowView removeFromSuperview];
        }
        
        _dragShadowView = view;
        
        if(_dragShadowView)
        {
            [self.rootView addSubview:_dragShadowView];
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)recognizer
{
    NSLog(@"AtkDragAndDropManager:gestureRecognizerShouldBegin");
    // Only begin if we have a dragSource.
    return [self dragStart:recognizer];
}

/**
 * Handles the gesture. 
 */
- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    switch(recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            if(_dragSource)
            {
                [self dragMoved:recognizer];
            }
            break;
        case UIGestureRecognizerStateEnded: // same as UIGestureRecognizerStateRecognized
            if(_dragSource)
            {
                [self dragDropped:recognizer];
                [self dragEnded:recognizer];
            }
            break;
        case UIGestureRecognizerStateCancelled:
            if(_dragSource)
            {
                NSLog(@"UIGestureRecognizerStateCancelled");
                [self dragEnded:recognizer];
            }
            break;
        case UIGestureRecognizerStateFailed:
            if(_dragSource)
            {
                NSLog(@"UIGestureRecognizerStateFailed");
                [self dragEnded:recognizer];
            }
            break;
        case UIGestureRecognizerStatePossible:
            NSLog(@"UIGestureRecognizerStatePossible");
            break;
    }
}

/**
 * Checks the movement of the recognizer and determines wheather and dropZones change their active status.
 */
- (void)checkMovement:(UIGestureRecognizer *)recognizer
{
    CGPoint pointInRootView = [recognizer locationInView:self.rootView];
    
    for(AtkDropZoneWrapper *dropZone in self.interestedDropZones)
    {
        if([self isDropZoneActive:dropZone.dropZone recognizer:recognizer])
        {
            if(!dropZone.isActive)
            {
                // transitioned to inside
                dropZone.isActive = YES;
                [dropZone.dropZone dragEntered:self point:pointInRootView];
                
                if([self.dragSource respondsToSelector:@selector(dragEntered:dropZone:point:)])
                    [self.dragSource dragEntered:self dropZone:dropZone.dropZone point:pointInRootView];
            }
            else
            {
                [dropZone.dropZone dragMoved:self point:pointInRootView];
                
                if([self.dragSource respondsToSelector:@selector(dragMoved:dropZone:point:)])
                    [self.dragSource dragMoved:self dropZone:dropZone.dropZone point:pointInRootView];
            }
        }
        else if(dropZone.isActive)
        {
            // transitioned to outside
            dropZone.isActive = NO;
            [dropZone.dropZone dragExited:self point:pointInRootView];
            
            if([self.dragSource respondsToSelector:@selector(dragExited:dropZone:point:)])
                [self.dragSource dragExited:self dropZone:dropZone.dropZone point:pointInRootView];
        }
    }
}

/**
 * Called when a drag operation starts. Returns true if a self.dragSource was set indicating
 * that a drag source was found and dragging will commence.
 */
- (BOOL)dragStart:(UIGestureRecognizer *)recognizer
{
    NSLog(@"AtkDragAndDropManager.dragStart");
    
    self.dragShadowView = nil;
    self.interestedDropZones = nil;
    self.uninterestedDropZones = nil;
    
    if((self.dragSource = [self findDragSource:recognizer]))
    {
        NSArray *dropZones = [self findDropZones:recognizer];
        
        // Wrap the drop zones with AtkDropZoneWrapper to track it's state.
        NSMutableArray *interestedDropZones = nil;
        NSMutableArray *uninterestedDropZones = nil;
        
        if(dropZones)
        {
            for(id<AtkDropZoneProtocol> dropZone in dropZones)
            {
                if([dropZone respondsToSelector:@selector(isInterested:)] && [dropZone isInterested:self])
                {
                    if(!interestedDropZones)
                        interestedDropZones = [NSMutableArray arrayWithCapacity:[dropZones count]];
                    [interestedDropZones addObject:[[AtkDropZoneWrapper alloc] initWithDropZone:dropZone interested:YES]];
                }
                else
                {
                    if(!uninterestedDropZones)
                        uninterestedDropZones = [NSMutableArray arrayWithCapacity:[dropZones count]];
                    [uninterestedDropZones addObject:[[AtkDropZoneWrapper alloc] initWithDropZone:dropZone interested:NO]];
                }
            }
        }
        
        self.interestedDropZones = interestedDropZones;
        self.uninterestedDropZones = uninterestedDropZones;
        
        if([self.dragSource respondsToSelector:@selector(dragStarted:dropZone:)])
        {
            for(AtkDropZoneWrapper *interestedDropZone in self.interestedDropZones)
                [self.dragSource dragStarted:self dropZone:interestedDropZone.dropZone];
        }
        
        [self positionDragShadow:recognizer];
    }
    
    return _dragSource == nil ? NO : YES;
}

/**
 * Called when a drag operation ends.
 */
- (void)dragEnded:(UIGestureRecognizer *)recognizer
{
    NSLog(@"AtkDragAndDropManager.dragEnded");
    
    for(AtkDropZoneWrapper *dropZone in self.uninterestedDropZones)
    {
        [dropZone.dropZone dragEnded:self];
        if([self.dragSource respondsToSelector:@selector(dragEnded:dropZone:)])
            [self.dragSource dragEnded:self dropZone:dropZone.dropZone];
    }
    
    for(AtkDropZoneWrapper *dropZone in self.interestedDropZones)
    {
        [dropZone.dropZone dragEnded:self];
        if([self.dragSource respondsToSelector:@selector(dragEnded:dropZone:)])
            [self.dragSource dragEnded:self dropZone:dropZone.dropZone];
    }
    
    if([self.dragSource respondsToSelector:@selector(dragEnded:)])
        [self.dragSource dragEnded:self];
    
    self.dragShadowView = nil;
    self.dragSource = nil;
    self.interestedDropZones = nil;
    self.uninterestedDropZones = nil;
}

/**
 * Called when a drag moves.
 */
- (void)dragMoved:(UIGestureRecognizer *)recognizer
{
    //NSLog(@"AtkDragAndDropManager.dragMoved");
    
    [self checkMovement:recognizer];
    [self positionDragShadow:recognizer];
}

/**
 * Called when a drag is dropped.
 */
- (void)dragDropped:(UIGestureRecognizer *)recognizer
{
    NSLog(@"AtkDragAndDropManager.dragDropped");
    
    for(NSInteger n = [self.interestedDropZones count] - 1; n >= 0; n--)
    {
        AtkDropZoneWrapper *interestedDropZone = [self.interestedDropZones objectAtIndex:n];
        if(interestedDropZone.isActive)
        {
            [interestedDropZone.dropZone dragDropped:self point:[recognizer locationInView:self.rootView]];
            
            if([self.dragSource respondsToSelector:@selector(dragDropped:dropZone:point:)])
                [self.dragSource dragDropped:self dropZone:interestedDropZone.dropZone point:[recognizer locationInView:self.rootView]];
        }
    }
}

/**
 * Positions the drag shadow.
 */
- (void)positionDragShadow:(UIGestureRecognizer *)recognizer
{
    if(_dragShadowView)
    {
        CGPoint point = [recognizer locationInView:self.rootView];
        CGRect frame = _dragShadowView.frame;
        frame.origin = CGPointMake(point.x - (frame.size.width / 2.0), point.y - (frame.size.height / 2.0));
        _dragShadowView.frame = frame;
    }
}

- (id<AtkDragAndDropManagerDelegate>)activeDelegate
{
    return _delegate ? _delegate : self.defaultDelegate;
}

- (id<AtkDragAndDropManagerDelegate>)defaultDelegate
{
    if(!_defaultDelegate)
    {
        self.defaultDelegate = [[AtkDefaultDragAndDropManagerDelegate alloc] init];
    }
    
    return _defaultDelegate;
}

- (void)setDelegate:(id<AtkDragAndDropManagerDelegate>)delegate
{
    if(_delegate != delegate)
    {
        _delegate = delegate;
    }
    
    if(_delegate)
        self.defaultDelegate = nil;
}

@end
