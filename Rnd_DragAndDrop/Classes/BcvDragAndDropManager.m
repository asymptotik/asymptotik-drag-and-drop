//
//  BcvDragAndDropManager.m
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "BcvDragAndDropManager.h"
#import "UIView+DragAndDrop.h"
#import "BcvDropZoneProtocol.h"
#import "BcvInterestedDropZone.h"

@interface BcvDragAndDropManager ()

@property (nonatomic, retain) UIView *rootView;
@property (nonatomic, retain) id<BcvDragSourceProtocol> dragSource;
@property (nonatomic, retain) UIView *dragShadowView;
@property (nonatomic, retain) UIPanGestureRecognizer *recognizer;
@property (nonatomic, retain) NSArray *interestedDropZones;

- (void)dragStart:(UIGestureRecognizer *)recognizer;
- (void)dragEnded:(UIGestureRecognizer *)recognizer;
- (void)dragMoved:(UIGestureRecognizer *)recognizer;
- (void)dragDropped:(UIGestureRecognizer *)recognizer;
- (void)positionDragShadow:(UIGestureRecognizer *)recognizer;

@end

@implementation BcvDragAndDropManager

NSString *const BcvPasteboardNameDragAndDrop = @"com.comcast.bcv.draganddrop.pasteboard";

static BcvDragAndDropManager *_instance;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        _instance = [[BcvDragAndDropManager alloc] init];
    }
}

+ (BcvDragAndDropManager *)instance
{
    return _instance;
}

- (id)init
{
    if((self = [super init]))
    {
        
    }
    
    return self;
}

- (void)dealloc
{
    self.rootView = nil;
    self.dragSource = nil;
    self.dragShadowView = nil;
    self.recognizer = nil;
    self.interestedDropZones = nil;
    
    [super dealloc];
}

- (void)start
{
    NSLog(@"BcvDragAndDropManager.start");
    
    self.recognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)] autorelease];
    [[[UIApplication sharedApplication] keyWindow] addGestureRecognizer:self.recognizer];
}

- (void)start:(UIView *)rootView
{
    NSLog(@"BcvDragAndDropManager.start:rootView");
    
    if(_rootView)
        [self stop];
    
    if(rootView)
    {
        self.rootView = rootView;
        self.recognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)] autorelease];
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
    return [UIPasteboard pasteboardWithName:BcvPasteboardNameDragAndDrop create:YES];
}

- (UIView *)rootView
{
    return self.recognizer ? self.recognizer.view : nil;
}

- (CGPoint)convertPoint:(CGPoint)point toView:(UIView *)view
{
    if(self.recognizer && self.recognizer.view)
        return [self.recognizer.view convertPoint:point toView:view];
    else
        return CGPointZero;
}

- (void)setDragSource:(id<BcvDragSourceProtocol>)dragSource
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
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            [window addSubview:_dragShadowView];
        }
    }
}

- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    switch(recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            {
                [self dragStart:recognizer];
            }
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
        case UIGestureRecognizerStateFailed:
            if(_dragSource)
            {
                [self dragEnded:recognizer];
            }
            break;
        case UIGestureRecognizerStatePossible:
            break;
    }
}

- (UIPasteboard *)pasteboardWithObject:(NSObject *)obj forKey:(NSString *)key
{
    UIPasteboard *ret = self.pasteboard;
    [ret setValue:obj forPasteboardType:key];
    return ret;
}

- (id<BcvDragSourceProtocol>)findDragSource:(UIGestureRecognizer *)recognizer
{
    BOOL dragStarted = NO;
    UIView *recognizerView = recognizer.view;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *hitView = [window hitTest:[recognizer locationInView:recognizerView] withEvent:nil];
    
    while(!dragStarted && hitView)
    {
        if([hitView conformsToProtocol:@protocol(BcvDragSourceProtocol)])
        {
            if([hitView respondsToSelector:@selector(dragStarted)])
                dragStarted = [(UIView<BcvDragSourceProtocol> *)hitView dragStarted];
            else
                dragStarted = YES;
        }
        
        if(!dragStarted)
        {
            hitView = hitView.superview;
        }
    }
    
    return dragStarted ? (id<BcvDragSourceProtocol>)hitView : nil;
}

- (NSMutableArray *)findInterestedDropZones:(NSMutableArray *)interestedViews root:(UIView *)view recognizer:(UIGestureRecognizer *)recognizer
{
    if([view conformsToProtocol:@protocol(BcvDropZoneProtocol)] && [(id<BcvDropZoneProtocol>)view dragStarted])
    {
        if(!interestedViews)
            interestedViews = [NSMutableArray array];
        
        [interestedViews addObject:[[[BcvInterestedDropZone alloc] initWithDropZone:(id<BcvDropZoneProtocol>)view] autorelease]];
    }
    
    for (UIView *subview in view.subviews)
    {
        interestedViews = [self findInterestedDropZones:interestedViews root:subview recognizer:recognizer];
    }
    
    return interestedViews;
}

- (NSArray *)findInterestedDropZones:(UIGestureRecognizer *)recognizer
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NSMutableArray *ret = [self findInterestedDropZones:nil root:window recognizer:recognizer];
    
    return ret ? [NSArray arrayWithArray:ret] : nil;
}

- (BOOL)pointInDropZone:(id<BcvDropZoneProtocol>)dropZone recognizer:(UIGestureRecognizer *)recognizer
{
    BOOL ret = false;
    
    if([dropZone respondsToSelector:@selector(containsPoint:point:)])
    {
        ret = [dropZone containsPoint:recognizer.view point:[recognizer locationInView:recognizer.view]];
    }
    else if([dropZone isKindOfClass:[UIView class]])
    {
        UIView<BcvDropZoneProtocol> *dropView = (UIView<BcvDropZoneProtocol> *)dropZone;
        CGPoint pointRelativeToDropView = [recognizer locationInView:dropView];
        
        ret = [dropView pointInside:pointRelativeToDropView withEvent:nil];
    }
    
    return ret;
}

- (void)checkMovement:(UIGestureRecognizer *)recognizer
{
    CGPoint pointInRootView = [recognizer locationInView:recognizer.view];
    
    for(BcvInterestedDropZone *interestedDropZone in self.interestedDropZones)
    {
        if([self pointInDropZone:interestedDropZone.dropZone recognizer:recognizer])
        {
            if(!interestedDropZone.isInside)
            {
                // transitioned to inside
                interestedDropZone.isInside = YES;
                [interestedDropZone.dropZone dragEntered:pointInRootView];
                
                if([self.dragSource respondsToSelector:@selector(dragEnteredDropZone:point:)])
                    [self.dragSource dragEnteredDropZone:interestedDropZone.dropZone point:pointInRootView];
            }
            else
            {
                [interestedDropZone.dropZone dragMoved:pointInRootView];
                
                if([self.dragSource respondsToSelector:@selector(dragMovedOnDropZone:point:)])
                    [self.dragSource dragMovedOnDropZone:interestedDropZone.dropZone point:pointInRootView];
            }
        }
        else if(interestedDropZone.isInside)
        {
            // transitioned to outside
            interestedDropZone.isInside = NO;
            [interestedDropZone.dropZone dragExited:pointInRootView];
            
            if([self.dragSource respondsToSelector:@selector(dragExitedDropZone:point:)])
                [self.dragSource dragExitedDropZone:interestedDropZone.dropZone point:pointInRootView];
        }
    }
}

- (void)dragStart:(UIGestureRecognizer *)recognizer
{
    NSLog(@"BcvDragAndDropManager.dragStart");
    
    self.dragShadowView = nil;
    self.interestedDropZones = nil;
    
    if((self.dragSource = [self findDragSource:recognizer]))
    {
        self.interestedDropZones = [self findInterestedDropZones:recognizer];
        
        if([self.dragSource respondsToSelector:@selector(dragStartedOnDropZone:)])
        {
            for(BcvInterestedDropZone *interestedDropZone in self.interestedDropZones)
                [self.dragSource dragStartedOnDropZone:interestedDropZone.dropZone];
        }
        
        [self positionDragShadow:recognizer];
    }
}

- (void)dragEnded:(UIGestureRecognizer *)recognizer
{
    NSLog(@"BcvDragAndDropManager.dragEnded");
    
    for(BcvInterestedDropZone *interestedDropZone in self.interestedDropZones)
    {
        [interestedDropZone.dropZone dragEnded];
        if([self.dragSource respondsToSelector:@selector(dragEndedOnDropZone:)])
            [self.dragSource dragEndedOnDropZone:interestedDropZone.dropZone];
    }
    
    if([self.dragSource respondsToSelector:@selector(dragEnded)])
        [self.dragSource dragEnded];
    
    self.dragShadowView = nil;
    self.dragSource = nil;
    self.interestedDropZones = nil;
}

- (void)dragMoved:(UIGestureRecognizer *)recognizer
{
    //NSLog(@"BcvDragAndDropManager.dragMoved");
    
    [self checkMovement:recognizer];
    [self positionDragShadow:recognizer];
}

- (void)dragDropped:(UIGestureRecognizer *)recognizer
{
    NSLog(@"BcvDragAndDropManager.dragDropped");
    
    for(int n = [self.interestedDropZones count] - 1; n >= 0; n--)
    {
        BcvInterestedDropZone *interestedDropZone = [self.interestedDropZones objectAtIndex:n];
        if(interestedDropZone.isInside)
        {
            [interestedDropZone.dropZone dragDropped:[recognizer locationInView:recognizer.view]];
            
            if([self.dragSource respondsToSelector:@selector(dragEndedOnDropZone:)])
                [self.dragSource dragDroppedOnDropZone:interestedDropZone.dropZone point:[recognizer locationInView:recognizer.view]];
        }
    }
}

- (void)positionDragShadow:(UIGestureRecognizer *)recognizer
{
    if(_dragShadowView)
    {
        CGPoint point = [recognizer locationInView:[[UIApplication sharedApplication] keyWindow]];
        CGRect frame = _dragShadowView.frame;
        frame.origin = CGPointMake(point.x - (frame.size.width / 2.0), point.y - (frame.size.height / 2.0));
        _dragShadowView.frame = frame;
    }
}

@end
