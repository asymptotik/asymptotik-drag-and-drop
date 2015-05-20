//
//  AtkSampleTwoDropZoneScrollViewWrapper.h
//  Atkdrogen_DragAndDrop
//
//  Created by Rick Boykin on 1/21/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AtkDragAndDrop.h"

@interface AtkSampleTwoDropZoneScrollViewWrapper : NSObject<AtkDropZoneProtocol>

@property (nonatomic, strong) UIScrollView *view;

- (id)initWithScrollView:(UIScrollView *)view;

@end
