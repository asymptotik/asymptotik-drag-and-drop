//
//  AtkSampleThreeViewController.m
//  AtkDragAndDrop_Examples
//
//  Created by Rick Boykin on 4/9/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>

#import "AtkSampleThreeViewController.h"
#import "AtkSampleThreeCollectionViewController.h"
#import "AtkDragAndDrop.h"
#import "AtkSampleThreeCellData.h"

@interface AtkSampleThreeViewController ()<AtkDragAndDropManagerDelegate>

@property (nonatomic) AtkSampleThreeCollectionViewController *collectionController;

@property (nonatomic, strong) IBOutlet UIView *viewSource01;
@property (nonatomic, strong) AtkDragAndDropManager *dragAndDropManager;

@end

@implementation AtkSampleThreeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init
{
    [self addChildViewController:self.collectionController];
    [self.collectionController didMoveToParentViewController:self];
    self.dragAndDropManager = [[AtkDragAndDropManager alloc] init];
    self.dragAndDropManager.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.collectionController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.collectionController.view];
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.collectionController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:200],
                                [NSLayoutConstraint constraintWithItem:self.collectionController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.collectionController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.collectionController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
        ]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.dragAndDropManager start:[[UIApplication sharedApplication] keyWindow] recognizerClass:[UIPanGestureRecognizer class]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.dragAndDropManager stop];
    [super viewWillDisappear:animated];
}

- (AtkSampleThreeCollectionViewController *)collectionController
{
    if(!_collectionController)
    {
        self.collectionController = [[AtkSampleThreeCollectionViewController alloc] initWithNibName:@"AtkSampleThreeCollectionViewController" bundle:nil];
    }
    
    return _collectionController;
}

#pragma - mark AtkDragAndDropManagerDelegate

- (id<AtkDragSourceProtocol>)findDragSource:(AtkDragAndDropManager *)manager recognizer:(UIGestureRecognizer *)recognizer
{
    BOOL dragStarted = NO;
    
    UIView *hitView = [manager.rootView hitTest:[recognizer locationInView:manager.rootView] withEvent:nil];
    
    // Very simple find. Use any means you want to find the sources.
    if(hitView == _viewSource01)
        dragStarted = YES;
    
    id<AtkDragSourceProtocol> ret = nil;
    
    if(dragStarted)
    {
        ret = (id<AtkDragSourceProtocol>)hitView;
        NSDictionary *values = @{ @"title" : @"DragSource",  @"subtitle": @"This is my drag source" };
        [manager.pasteboard setValue:values forPasteboardType:(NSString *)kUTTypeItem];
    }
    
    return ret;
}

- (NSArray *)findDropZones:(AtkDragAndDropManager *)manager recognizer:(UIGestureRecognizer *)recognizer
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:10];
    AtkSampleThreeCollectionViewController *dropZone = self.collectionController;
    [dropZone dragStarted:manager];
    [ret addObject:dropZone];
    
    return ret;
}

- (BOOL)isDropZoneActive:(AtkDragAndDropManager *)manager dropZone:(id<AtkDropZoneProtocol>)dropZone recognizer:(UIGestureRecognizer *)recognizer
{
    BOOL ret = false;
    
    if([dropZone respondsToSelector:@selector(isActive:point:)])
    {
        ret = [dropZone isActive:manager point:[recognizer locationInView:manager.rootView]];
    }
    
    return ret;
}

- (void)dragWillStart:(AtkDragAndDropManager *)manager
{
    NSLog(@"AtkSampleThreeViewController.dragWillStart");
}

- (void)dragStarted:(AtkDragAndDropManager *)manager
{
    NSLog(@"AtkSampleThreeViewController.dragStarted");
}

- (void)dragEnded:(AtkDragAndDropManager *)manager
{
    NSLog(@"AtkSampleThreeViewController.dragEnded");
}

- (void)dragEntered:(AtkDragAndDropManager *)manager dropZone:(id<AtkDropZoneProtocol>) dropZone point:(CGPoint)point
{
    NSLog(@"AtkSampleThreeViewController.dragEntered");
}

- (void)dragExited:(AtkDragAndDropManager *)manager dropZone:(id<AtkDropZoneProtocol>) dropZone point:(CGPoint)point
{
    NSLog(@"AtkSampleThreeViewController.dragExited");
}

- (void)dragMoved:(AtkDragAndDropManager *)manager dropZone:(id<AtkDropZoneProtocol>) dropZone point:(CGPoint)point
{
    //NSLog(@"AtkSampleThreeViewController.dragMoved");
}

- (void)dragDropped:(AtkDragAndDropManager *)manager dropZone:(id<AtkDropZoneProtocol>) dropZone point:(CGPoint)point
{
    NSLog(@"AtkSampleThreeViewController.dragDropped");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
