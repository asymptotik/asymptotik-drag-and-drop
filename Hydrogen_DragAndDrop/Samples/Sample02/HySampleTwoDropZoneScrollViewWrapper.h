//
//  HySampleTwoDropZoneScrollViewWrapper.h
//  Hydrogen_DragAndDrop
//
//  Created by Rick Boykin on 1/21/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyDragAndDrop.h"

@interface HySampleTwoDropZoneScrollViewWrapper : NSObject<HyDropZoneProtocol>

@property (nonatomic, retain) UIScrollView *view;

- (id)initWithScrollView:(UIScrollView *)view;

@end
