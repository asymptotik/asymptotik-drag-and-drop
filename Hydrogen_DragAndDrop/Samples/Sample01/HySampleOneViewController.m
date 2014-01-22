//
//  HySampleOneViewController.m
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/15/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "HySampleOneViewController.h"
#import "HyDragAndDropManager.h"

@interface HySampleOneViewController ()

@property (nonatomic, retain) IBOutlet UIView *viewSource;
@property (nonatomic, retain) IBOutlet UIScrollView *scroller;
@property (nonatomic, retain) IBOutlet UIView *viewParent;
@property (nonatomic, retain) IBOutlet UIView *viewTarget01;
@property (nonatomic, retain) IBOutlet UIView *viewTarget02;
@property (nonatomic, retain) IBOutlet UIView *viewTarget03;
@property (nonatomic, retain) IBOutlet UIView *viewTarget04;
@property (nonatomic, retain) IBOutlet UIView *viewTarget05;
@property (nonatomic, retain) IBOutlet UIView *viewTarget06;
@property (nonatomic, retain) IBOutlet UIView *viewTarget07;
@property (nonatomic, retain) IBOutlet UIView *viewTarget08;

@end

@implementation HySampleOneViewController

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
    self.navigationItem.title = @"Sample One";
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
    [[HyDragAndDropManager instance] start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[HyDragAndDropManager instance] stop];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
