//
//  AtkDragAndDropManager.m
//  AtkDragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import "AtkDragAndDropManager.h"
#import "UIView+AtkDragAndDrop.h"
#import "AtkDropZoneProtocol.h"
#import "AtkDropZoneWrapper.h"
#import "AtkDefaultDragAndDropManagerDelegate.h"

@interface AtkDragAndDropManager ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, strong) id<AtkDragSourceProtocol> dragSource;
@property (nonatomic, assign) CGPoint locationOffset;
@property (nonatomic, strong) UIView *dragShadowView;
@property (nonatomic, strong) UIPanGestureRecognizer *recognizer;
@property (nonatomic, strong) NSArray *uninterestedDropZones;
@property (nonatomic, strong) NSArray *interestedDropZones;
@property (nonatomic, strong) id<AtkDragAndDropManagerDelegate> defaultDelegate;

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
    //NSLog(@"AtkDragAndDropManager.start");
    
    [self start:[[UIApplication sharedApplication] keyWindow]];
}

- (void)start:(UIView *)rootView
{
    //NSLog(@"AtkDragAndDropManager.start:");
    [self start:rootView recognizerClass:[UIPanGestureRecognizer class]];
}

- (void)start:(UIView *)rootView recognizerClass:(Class)recognizerClass
{
    //NSLog(@"AtkDragAndDropManager.start:recognizerClass: %@", [recognizerClass description]);
    
    assert([recognizerClass isSubclassOfClass:[UIGestureRecognizer class]]);
    
    if(_rootView)
        [self stop];
    
    if(rootView)
    {
        
        self.rootView = rootView;
        self.recognizer = [[recognizerClass alloc] initWithTarget:self action:@selector(handleGesture:)];
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
        [self onDragEnded:nil];
    }
    
    self.recognizer = nil;
    self.rootView = nil;
}

- (UIPasteboard *)pasteboard
{
    return [UIPasteboard pasteboardWithName:self.pasteboardName create:YES];
}

- (id<AtkDragSourceProtocol>)findDragSource:(UIGestureRecognizer *)recognizer
{
    if(_delegate && [_delegate respondsToSelector:@selector(findDragSource:recognizer:)])
        return [_delegate findDragSource:self recognizer:recognizer];
    else
        return [self.defaultDelegate findDragSource:self recognizer:recognizer];
}

- (NSArray *)findDropZones:(UIGestureRecognizer *)recognizer
{
    if(_delegate && [_delegate respondsToSelector:@selector(findDropZones:recognizer:)])
        return [_delegate findDropZones:self recognizer:recognizer];
    else
        return [self.defaultDelegate findDropZones:self recognizer:recognizer];
}

- (BOOL)isDropZoneActive:(id<AtkDropZoneProtocol>)dropZone recognizer:(UIGestureRecognizer *)recognizer
{
    if(_delegate && [_delegate respondsToSelector:@selector(isDropZoneActive:dropZone:recognizer:)])
        return [_delegate isDropZoneActive:self dropZone:dropZone recognizer:recognizer];
    else
        return [self.defaultDelegate isDropZoneActive:self dropZone:dropZone recognizer:recognizer];
}

- (void)dragWillStart
{
    if([self.dragSource respondsToSelector:@selector(dragWillStart:)])
        [self.dragSource dragWillStart:self];
    
    if(_delegate && [_delegate respondsToSelector:@selector(dragWillStart:)])
        [_delegate dragWillStart:self];
}

- (void)dragStarted
{
    for(AtkDropZoneWrapper *dropZone in self.uninterestedDropZones)
    {
        if([dropZone.dropZone respondsToSelector:@selector(dragStarted:)])
            [dropZone.dropZone dragStarted:self];
    }
    
    for(AtkDropZoneWrapper *dropZone in self.interestedDropZones)
    {
        if([dropZone.dropZone respondsToSelector:@selector(dragStarted:)])
            [dropZone.dropZone dragStarted:self];
    }
    
    if([self.dragSource respondsToSelector:@selector(dragStarted:)])
        [self.dragSource dragStarted:self];
    
    if(_delegate && [_delegate respondsToSelector:@selector(dragStarted:)])
        [_delegate dragStarted:self];
}

- (void)dragEnded
{
    for(AtkDropZoneWrapper *dropZone in self.uninterestedDropZones)
    {
        if([dropZone.dropZone respondsToSelector:@selector(dragEnded:)])
            [dropZone.dropZone dragEnded:self];
    }
    
    for(AtkDropZoneWrapper *dropZone in self.interestedDropZones)
    {
        if([dropZone.dropZone respondsToSelector:@selector(dragEnded:)])
            [dropZone.dropZone dragEnded:self];
    }
    
    if([self.dragSource respondsToSelector:@selector(dragEnded:)])
        [self.dragSource dragEnded:self];
    
    if(_delegate && [_delegate respondsToSelector:@selector(dragEnded:)])
        [_delegate dragEnded:self];
}

- (void)dragEntered:(id<AtkDropZoneProtocol>)dropZone point:(CGPoint)point
{
    if([dropZone respondsToSelector:@selector(dragEntered:point:)])
        [dropZone dragEntered:self point:point];
    
    if([self.dragSource respondsToSelector:@selector(dragEntered:dropZone:point:)])
        [self.dragSource dragEntered:self dropZone:dropZone point:point];
    
    if(_delegate && [_delegate respondsToSelector:@selector(dragEntered:dropZone:point:)])
        [_delegate dragEntered:self dropZone:dropZone point:point];
}

- (void)dragExited:(id<AtkDropZoneProtocol>)dropZone point:(CGPoint)point
{
    if([dropZone respondsToSelector:@selector(dragExited:point:)])
        [dropZone dragExited:self point:point];
    
    if([self.dragSource respondsToSelector:@selector(dragExited:dropZone:point:)])
        [self.dragSource dragExited:self dropZone:dropZone point:point];
    
    if(_delegate && [_delegate respondsToSelector:@selector(dragExited:dropZone:point:)])
        [_delegate dragExited:self dropZone:dropZone point:point];
}

- (void)dragMoved:(id<AtkDropZoneProtocol>)dropZone point:(CGPoint)point
{
    if([dropZone respondsToSelector:@selector(dragMoved:point:)])
        [dropZone dragMoved:self point:point];
    
    if([self.dragSource respondsToSelector:@selector(dragMoved:dropZone:point:)])
        [self.dragSource dragMoved:self dropZone:dropZone point:point];
    
    if(_delegate && [_delegate respondsToSelector:@selector(dragMoved:dropZone:point:)])
        [_delegate dragMoved:self dropZone:dropZone point:point];
}

- (void)dragDropped:(id<AtkDropZoneProtocol>)dropZone point:(CGPoint)point
{
    if([dropZone respondsToSelector:@selector(dragDropped:point:)])
        [dropZone dragDropped:self point:point];
    
    if([self.dragSource respondsToSelector:@selector(dragDropped:dropZone:point:)])
        [self.dragSource dragDropped:self dropZone:dropZone point:point];
    
    if(_delegate && [_delegate respondsToSelector:@selector(dragDropped:dropZone:point:)])
        [_delegate dragDropped:self dropZone:dropZone point:point];
}

#pragma mark - private methods

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
            else if([_dragSource respondsToSelector:@selector(createDefaultDragShadowView:)])
                self.dragShadowView = [_dragSource performSelector:@selector(createDefaultDragShadowView:) withObject:self];
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
    //NSLog(@"AtkDragAndDropManager:gestureRecognizerShouldBegin");
    // Only begin if we have a dragSource.
    return [self onDragStart:recognizer];
}

/**
 * Handles the gesture. 
 */
- (IBAction)handleGesture:(UIPanGestureRecognizer *)recognizer
{
    switch(recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            if(_dragSource)
            {
                [self onDragMoved:recognizer];
            }
            break;
        case UIGestureRecognizerStateEnded: // same as UIGestureRecognizerStateRecognized
            if(_dragSource)
            {
                [self onDragDropped:recognizer];
                [self onDragEnded:recognizer];
            }
            break;
        case UIGestureRecognizerStateCancelled:
            if(_dragSource)
            {
                //NSLog(@"UIGestureRecognizerStateCancelled");
                [self onDragEnded:recognizer];
            }
            break;
        case UIGestureRecognizerStateFailed:
            if(_dragSource)
            {
                //NSLog(@"UIGestureRecognizerStateFailed");
                [self onDragEnded:recognizer];
            }
            break;
        case UIGestureRecognizerStatePossible:
            //NSLog(@"UIGestureRecognizerStatePossible");
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
                
                [self dragEntered:dropZone.dropZone point:pointInRootView];
            }
            else
            {
                [self dragMoved:dropZone.dropZone point:pointInRootView];
            }
        }
        else if(dropZone.isActive)
        {
            // transitioned to outside
            dropZone.isActive = NO;
            [self dragExited:dropZone.dropZone point:pointInRootView];
        }
    }
}

/**
 * Called when a drag operation starts. Returns true if a self.dragSource was set indicating
 * that a drag source was found and dragging will commence.
 */
- (BOOL)onDragStart:(UIGestureRecognizer *)recognizer
{
    //NSLog(@"AtkDragAndDropManager.dragStart");
    
    self.dragShadowView = nil;
    self.interestedDropZones = nil;
    self.uninterestedDropZones = nil;
    
    if((self.dragSource = [self findDragSource:recognizer]))
    {
        [self dragWillStart];
        
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
        
        [self dragStarted];
        self.locationOffset = [recognizer locationInView:self.rootView];
        [self positionDragShadow:recognizer];
    }
    
    return _dragSource == nil ? NO : YES;
}

/**
 * Called when a drag operation ends.
 */
- (void)onDragEnded:(UIGestureRecognizer *)recognizer
{
    //NSLog(@"AtkDragAndDropManager.dragEnded");
    
    [self dragEnded];
    
    self.dragShadowView = nil;
    self.dragSource = nil;
    self.interestedDropZones = nil;
    self.uninterestedDropZones = nil;
}

/**
 * Called when a drag moves.
 */
- (void)onDragMoved:(UIGestureRecognizer *)recognizer
{
    //NSLog(@"AtkDragAndDropManager.dragMoved");
    
    [self checkMovement:recognizer];
    [self positionDragShadow:recognizer];
}

/**
 * Called when a drag is dropped.
 */
- (void)onDragDropped:(UIGestureRecognizer *)recognizer
{
    //NSLog(@"AtkDragAndDropManager.dragDropped");
    
    for(NSInteger n = [self.interestedDropZones count] - 1; n >= 0; n--)
    {
        AtkDropZoneWrapper *interestedDropZone = [self.interestedDropZones objectAtIndex:n];
        if(interestedDropZone.isActive)
            [self dragDropped:interestedDropZone.dropZone point:[recognizer locationInView:self.rootView]];
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
        
        CGPoint offset = CGPointMake(point.x - self.locationOffset.x, point.y - self.locationOffset.y);
        //NSLog(@"offset %f %f frame %f %f", offset.x, offset.y, frame.origin.x, frame.origin.y);
        
        frame.origin = CGPointMake(offset.x + frame.origin.x, offset.y + frame.origin.y);
        self.locationOffset = point;
        _dragShadowView.frame = frame;
    }
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
