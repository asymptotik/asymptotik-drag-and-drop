//
//  HyDropZoneWrapper.h
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/18/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyDropZoneProtocol.h"

@interface HyDropZoneWrapper : NSObject

@property (nonatomic, retain) id<HyDropZoneProtocol> dropZone;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL isInterested;

- (id)initWithDropZone:(id<HyDropZoneProtocol>)dropZone interested:(BOOL)interested;

@end
