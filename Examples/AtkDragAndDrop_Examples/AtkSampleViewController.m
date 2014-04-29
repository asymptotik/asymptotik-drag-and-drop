//
//  AtkSampleViewController.m
//  Atkdrogen_DragAndDrop
//
//  Created by Rick Boykin on 1/20/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import "AtkSampleViewController.h"
#import "AtkSampleOneViewController.h"
#import "AtkSampleTwoViewController.h"

@interface AtkSampleViewController ()

@end

@implementation AtkSampleViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

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
    self.navigationItem.title = @"Samples";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sampleOneFired:(id)sender
{
    [self.navigationController pushViewController:[[AtkSampleOneViewController alloc] initWithNibName:@"AtkSampleOneViewController" bundle:nil] animated: YES];
}

- (IBAction)sampleTwoFired:(id)sender
{
    [self.navigationController pushViewController:[[AtkSampleTwoViewController alloc] initWithNibName:@"AtkSampleTwoViewController" bundle:nil] animated: YES];
}

- (IBAction)sampleThreeFired:(id)sender
{
    //[self.navigationController pushViewController:[[AtkSampleThreeViewController alloc] initWithNibName:@"AtkSampleThreeViewController" bundle:nil] animated: YES];
}

@end
