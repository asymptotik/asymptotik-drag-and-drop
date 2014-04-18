//
//  AtkSampleTwoViewController.m
//  AtkDragAndDrop
//
//  Created by Rick Boykin on 1/15/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import "AtkSampleTwoViewController.h"
#import "AtkSampleTwoDragSourceWrapper.h"
#import "AtkSampleTwoDropZoneWrapper.h"
#import "AtkSampleTwoDropZoneScrollViewWrapper.h"
#import "AtkDragAndDrop.h"

@interface AtkSampleTwoViewController ()<AtkDragAndDropManagerDelegate>

@property (nonatomic, strong) IBOutlet UIView *viewSource01;
@property (nonatomic, strong) IBOutlet UIView *viewSource02;
@property (nonatomic, strong) IBOutlet UIScrollView *scroller;
@property (nonatomic, strong) IBOutlet UIView *viewParent;
@property (nonatomic, strong) AtkDragAndDropManager *dragAndDropManager;

@end

@implementation AtkSampleTwoViewController

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
    self.dragAndDropManager = [[AtkDragAndDropManager alloc] init];
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
- (id<AtkDragSourceProtocol>)findDragSource:(AtkDragAndDropManager *)manager recognizer:(UIGestureRecognizer *)recognizer
{
    BOOL dragStarted = NO;
    
    UIView *hitView = [manager.rootView hitTest:[recognizer locationInView:manager.rootView] withEvent:nil];
    
    // Very simple find. Use any means you want to find the sources.
    if(hitView == _viewSource01 || hitView == _viewSource02)
        dragStarted = YES;
    
    AtkSampleTwoDragSourceWrapper * ret = nil;
    
    if(dragStarted)
    {
        ret = [[AtkSampleTwoDragSourceWrapper alloc] initWithView:hitView];
    }

    return ret;
}

/**
 * Recursively finds any drop zones (id<AtkDropZoneProtocol>) in rootView and it's descendents that are interested in the gesture
 * recognizer and returns them.
 */
- (NSArray *)findDropZones:(AtkDragAndDropManager *)manager recognizer:(UIGestureRecognizer *)recognizer
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:10];
    AtkSampleTwoDropZoneScrollViewWrapper *scrollViewDropZone = [[AtkSampleTwoDropZoneScrollViewWrapper alloc] initWithScrollView:_scroller];
    [ret addObject:scrollViewDropZone];
    
    for(UIView *child in _viewParent.subviews)
    {
        AtkSampleTwoDropZoneWrapper *viewDropZone = [[AtkSampleTwoDropZoneWrapper alloc] initWithView:child];
        [ret addObject:viewDropZone];
    }
    
    return ret;
}

/**
 * Returns YES is the specified drop zone is active for the recognizer. Active means that if the
 * drop event were to occur immediately, that drop zone would be dropped upon.
 */
- (BOOL)isDropZoneActive:(AtkDragAndDropManager *)manager dropZone:(id<AtkDropZoneProtocol>)dropZone recognizer:(UIGestureRecognizer *)recognizer
{
    BOOL ret = false;
    
    if([dropZone respondsToSelector:@selector(isActive:point:)])
    {
        ret = [dropZone isActive:manager point:[recognizer locationInView:manager.rootView]];
    }
    
    return ret;
}

@end
