//
//  HyDragAndDropManager.m
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "HyDragAndDropManager.h"
#import "UIView+HyDragAndDrop.h"
#import "HyDropZoneProtocol.h"
#import "HyDropZoneWrapper.h"
#import "HyDefaultDragAndDropManagerDelegate.h"

@interface HyDragAndDropManager ()<UIGestureRecognizerDelegate>

@property (nonatomic, retain) UIView *rootView;
@property (nonatomic, retain) id<HyDragSourceProtocol> dragSource;
@property (nonatomic, retain) UIView *dragShadowView;
@property (nonatomic, retain) UIPanGestureRecognizer *recognizer;
@property (nonatomic, retain) NSArray *uninterestedDropZones;
@property (nonatomic, retain) NSArray *interestedDropZones;
@property (nonatomic, retain) id<HyDragAndDropManagerDelegate> defaultDelegate;
@property (nonatomic, readonly) id<HyDragAndDropManagerDelegate> activeDelegate;

@end

@implementation HyDragAndDropManager

NSString *const HyPasteboardNameDragAndDrop = @"com.comcast.bcv.draganddrop.pasteboard";

static HyDragAndDropManager *_instance;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        _instance = [[HyDragAndDropManager alloc] init];
    }
}

+ (HyDragAndDropManager *)instance
{
    return _instance;
}

- (id)init
{
    if((self = [super init]))
    {
        self.pasteboardName = HyPasteboardNameDragAndDrop;
    }
    
    return self;
}

- (void)dealloc
{
    self.rootView = nil;
    self.dragSource = nil;
    self.dragShadowView = nil;
    self.recognizer = nil;
    self.uninterestedDropZones = nil;
    self.interestedDropZones = nil;
    
    [super dealloc];
}

- (void)start
{
    NSLog(@"HyDragAndDropManager.start");
    
    [self start:[[UIApplication sharedApplication] keyWindow]];
}

- (void)start:(UIView *)rootView
{
    NSLog(@"HyDragAndDropManager.start:rootView");
    
    if(_rootView)
        [self stop];
    
    if(rootView)
    {
        self.rootView = rootView;
        self.recognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)] autorelease];
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

- (id<HyDragSourceProtocol>)findDragSource:(UIGestureRecognizer *)recognizer
{
    return [self.activeDelegate findDragSource:self recognizer:recognizer];
}

- (NSArray *)findDropZones:(UIGestureRecognizer *)recognizer
{
    return [self.activeDelegate findDropZones:self recognizer:recognizer];
}

- (BOOL)isDropZoneActive:(id<HyDropZoneProtocol>)dropZone recognizer:(UIGestureRecognizer *)recognizer
{
    return [self.activeDelegate isDropZoneActive:self dropZone:dropZone recognizer:recognizer];
}

/**
 * Sets the drag source.
 */
- (void)setDragSource:(id<HyDragSourceProtocol>)dragSource
{
    if(_dragSource != dragSource)
    {
        [_dragSource release];
        _dragSource = [dragSource retain];
        
        if(_dragSource)
        {
            if([_dragSource respondsToSelector:@selector(createDragShadowView)])
                self.dragShadowView = [_dragSource createDragShadowView];
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
            [_dragShadowView release];
        }
        
        _dragShadowView = [view retain];
        
        if(_dragShadowView)
        {
            [self.rootView addSubview:_dragShadowView];
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)recognizer
{
    NSLog(@"HyDragAndDropManager:gestureRecognizerShouldBegin");
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
    
    for(HyDropZoneWrapper *dropZone in self.interestedDropZones)
    {
        if([self isDropZoneActive:dropZone.dropZone recognizer:recognizer])
        {
            if(!dropZone.isActive)
            {
                // transitioned to inside
                dropZone.isActive = YES;
                [dropZone.dropZone dragEntered:pointInRootView];
                
                if([self.dragSource respondsToSelector:@selector(dragEnteredDropZone:point:)])
                    [self.dragSource dragEnteredDropZone:dropZone.dropZone point:pointInRootView];
            }
            else
            {
                [dropZone.dropZone dragMoved:pointInRootView];
                
                if([self.dragSource respondsToSelector:@selector(dragMovedOnDropZone:point:)])
                    [self.dragSource dragMovedOnDropZone:dropZone.dropZone point:pointInRootView];
            }
        }
        else if(dropZone.isActive)
        {
            // transitioned to outside
            dropZone.isActive = NO;
            [dropZone.dropZone dragExited:pointInRootView];
            
            if([self.dragSource respondsToSelector:@selector(dragExitedDropZone:point:)])
                [self.dragSource dragExitedDropZone:dropZone.dropZone point:pointInRootView];
        }
    }
}

/**
 * Called when a drag operation starts. Returns true if a self.dragSource was set indicating
 * that a drag source was found and dragging will commence.
 */
- (BOOL)dragStart:(UIGestureRecognizer *)recognizer
{
    NSLog(@"HyDragAndDropManager.dragStart");
    
    self.dragShadowView = nil;
    self.interestedDropZones = nil;
    self.uninterestedDropZones = nil;
    
    if((self.dragSource = [self findDragSource:recognizer]))
    {
        NSArray *dropZones = [self findDropZones:recognizer];
        
        // Wrap the drop zones with HyDropZoneWrapper to track it's state.
        NSMutableArray *interestedDropZones = nil;
        NSMutableArray *uninterestedDropZones = nil;
        
        if(dropZones)
        {
            for(id<HyDropZoneProtocol> dropZone in dropZones)
            {
                if([dropZone respondsToSelector:@selector(isInterested)] && [dropZone isInterested])
                {
                    if(!interestedDropZones)
                        interestedDropZones = [NSMutableArray arrayWithCapacity:[dropZones count]];
                    [interestedDropZones addObject:[[[HyDropZoneWrapper alloc] initWithDropZone:dropZone interested:YES] autorelease]];
                }
                else
                {
                    if(!uninterestedDropZones)
                        uninterestedDropZones = [NSMutableArray arrayWithCapacity:[dropZones count]];
                    [uninterestedDropZones addObject:[[[HyDropZoneWrapper alloc] initWithDropZone:dropZone interested:NO] autorelease]];
                }
            }
        }
        
        self.interestedDropZones = interestedDropZones;
        self.uninterestedDropZones = uninterestedDropZones;
        
        if([self.dragSource respondsToSelector:@selector(dragStartedOnDropZone:)])
        {
            for(HyDropZoneWrapper *interestedDropZone in self.interestedDropZones)
                [self.dragSource dragStartedOnDropZone:interestedDropZone.dropZone];
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
    NSLog(@"HyDragAndDropManager.dragEnded");
    
    for(HyDropZoneWrapper *dropZone in self.uninterestedDropZones)
    {
        [dropZone.dropZone dragEnded];
        if([self.dragSource respondsToSelector:@selector(dragEndedOnDropZone:)])
            [self.dragSource dragEndedOnDropZone:dropZone.dropZone];
    }
    
    for(HyDropZoneWrapper *dropZone in self.interestedDropZones)
    {
        [dropZone.dropZone dragEnded];
        if([self.dragSource respondsToSelector:@selector(dragEndedOnDropZone:)])
            [self.dragSource dragEndedOnDropZone:dropZone.dropZone];
    }
    
    if([self.dragSource respondsToSelector:@selector(dragEnded)])
        [self.dragSource dragEnded];
    
    self.dragShadowView = nil;
    self.dragSource = nil;
    self.interestedDropZones = nil;
}

/**
 * Called when a drag moves.
 */
- (void)dragMoved:(UIGestureRecognizer *)recognizer
{
    //NSLog(@"HyDragAndDropManager.dragMoved");
    
    [self checkMovement:recognizer];
    [self positionDragShadow:recognizer];
}

/**
 * Called when a drag is dropped.
 */
- (void)dragDropped:(UIGestureRecognizer *)recognizer
{
    NSLog(@"HyDragAndDropManager.dragDropped");
    
    for(NSInteger n = [self.interestedDropZones count] - 1; n >= 0; n--)
    {
        HyDropZoneWrapper *interestedDropZone = [self.interestedDropZones objectAtIndex:n];
        if(interestedDropZone.isActive)
        {
            [interestedDropZone.dropZone dragDropped:[recognizer locationInView:self.rootView]];
            
            if([self.dragSource respondsToSelector:@selector(dragEndedOnDropZone:)])
                [self.dragSource dragDroppedOnDropZone:interestedDropZone.dropZone point:[recognizer locationInView:self.rootView]];
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

- (id<HyDragAndDropManagerDelegate>)activeDelegate
{
    return _delegate ? _delegate : self.defaultDelegate;
}

- (id<HyDragAndDropManagerDelegate>)defaultDelegate
{
    if(!_defaultDelegate)
    {
        self.defaultDelegate = [[[HyDefaultDragAndDropManagerDelegate alloc] init] autorelease];
    }
    
    return _defaultDelegate;
}

- (void)setDelegate:(id<HyDragAndDropManagerDelegate>)delegate
{
    if(_delegate != delegate)
    {
        [_delegate release];
        _delegate = [delegate retain];
    }
    
    if(_delegate)
        self.defaultDelegate = nil;
}

@end
