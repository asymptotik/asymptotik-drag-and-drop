//
//  AtkSampleOneViewController.m
//  AtkDragAndDrop
//
//  Created by Rick Boykin on 1/15/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import "AtkSampleOneViewController.h"
#import "AtkDragAndDropManager.h"

@interface AtkSampleOneViewController ()

@property (nonatomic, strong) IBOutlet UIView *viewSource;
@property (nonatomic, strong) IBOutlet UIScrollView *scroller;
@property (nonatomic, strong) IBOutlet UIView *viewParent;
@property (nonatomic, strong) IBOutlet UIView *viewTarget01;
@property (nonatomic, strong) IBOutlet UIView *viewTarget02;
@property (nonatomic, strong) IBOutlet UIView *viewTarget03;
@property (nonatomic, strong) IBOutlet UIView *viewTarget04;
@property (nonatomic, strong) IBOutlet UIView *viewTarget05;
@property (nonatomic, strong) IBOutlet UIView *viewTarget06;
@property (nonatomic, strong) IBOutlet UIView *viewTarget07;
@property (nonatomic, strong) IBOutlet UIView *viewTarget08;
@property (nonatomic, strong) AtkDragAndDropManager *dragAndDropManager;

@end

@implementation AtkSampleOneViewController

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
    self.dragAndDropManager = [[AtkDragAndDropManager alloc] init];
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
    [self.dragAndDropManager start];
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

@end
