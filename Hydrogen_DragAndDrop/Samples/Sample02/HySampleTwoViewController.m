//
//  HySampleTwoViewController.m
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/15/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "HySampleTwoViewController.h"
#import "HySampleTwoDragSourceWrapper.h"
#import "HySampleTwoDropZoneWrapper.h"
#import "HySampleTwoDropZoneScrollViewWrapper.h"

@interface HySampleTwoViewController ()

@property (nonatomic, retain) IBOutlet UIView *viewSource01;
@property (nonatomic, retain) IBOutlet UIView *viewSource02;
@property (nonatomic, retain) IBOutlet UIScrollView *scroller;
@property (nonatomic, retain) IBOutlet UIView *viewParent;
@property (nonatomic, retain) HyDragAndDropManager *dragAndDropManager;

@end

@implementation HySampleTwoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.navigationItem.title = @"Sample Two";
    self.dragAndDropManager = [[[HyDragAndDropManager alloc] init] autorelease];
    self.dragAndDropManager.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect viewParentFrame = _viewParent.frame;
    
    _scroller.contentSize = viewParentFrame.size;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.dragAndDropManager start:[[UIApplication sharedApplication] keyWindow] recognizerClass:[UILongPressGestureRecognizer class]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.dragAndDropManager stop];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * Finds the drag source.
 */
- (id<HyDragSourceProtocol>)findDragSource:(HyDragAndDropManager *)manager recognizer:(UIGestureRecognizer *)recognizer
{
    BOOL dragStarted = NO;
    
    UIView *hitView = [manager.rootView hitTest:[recognizer locationInView:manager.rootView] withEvent:nil];
    
    // Very simple find. Use any means you want to find the sources.
    if(hitView == _viewSource01 || hitView == _viewSource02)
        dragStarted = YES;
    
    HySampleTwoDragSourceWrapper * ret = nil;
    
    if(dragStarted)
    {
        ret = [[[HySampleTwoDragSourceWrapper alloc] initWithView:hitView] autorelease];
        [ret dragStarted:manager];
    }

    return ret;
}

/**
 * Recursively finds any drop zones (id<HyDropZoneProtocol>) in rootView and it's descendents that are interested in the gesture
 * recognizer and returns them.
 */
- (NSArray *)findDropZones:(HyDragAndDropManager *)manager recognizer:(UIGestureRecognizer *)recognizer
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:10];
    HySampleTwoDropZoneScrollViewWrapper *scrollViewDropZone = [[[HySampleTwoDropZoneScrollViewWrapper alloc] initWithScrollView:_scroller] autorelease];
    [scrollViewDropZone dragStarted:manager];
    [ret addObject:scrollViewDropZone];
    
    for(UIView *child in _viewParent.subviews)
    {
        HySampleTwoDropZoneWrapper *viewDropZone = [[[HySampleTwoDropZoneWrapper alloc] initWithView:child] autorelease];
        [viewDropZone dragStarted:manager];
        [ret addObject:viewDropZone];
    }
    
    return ret;
}

/**
 * Returns YES is the specified drop zone is active for the recognizer. Active means that if the
 * drop event were to occur immediately, that drop zone would be dropped upon.
 */
- (BOOL)isDropZoneActive:(HyDragAndDropManager *)manager dropZone:(id<HyDropZoneProtocol>)dropZone recognizer:(UIGestureRecognizer *)recognizer
{
    BOOL ret = false;
    
    if([dropZone respondsToSelector:@selector(isActive:point:)])
    {
        ret = [dropZone isActive:manager point:[recognizer locationInView:manager.rootView]];
    }
    
    return ret;
}

@end
