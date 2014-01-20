//
//  HyDropScrollView.h
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HyDragAndDrop.h"

@interface HyDropScrollView : UIScrollView <HyDropZoneProtocol> 

@property (nonatomic, assign) CGFloat autoScrollEdgeTollerance;
@property (nonatomic, assign) CGFloat autoScrollVelocity;

@end
