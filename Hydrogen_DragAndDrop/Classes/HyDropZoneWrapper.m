//
//  HyDropZoneWrapper.m
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/18/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "HyDropZoneWrapper.h"

@implementation HyDropZoneWrapper

- (id)initWithDropZone:(id<HyDropZoneProtocol>)dropZone interested:(BOOL)interested;
{
    if((self = [super init]))
    {
        self.dropZone = dropZone;
        self.isActive = NO;
        self.isInterested = interested;
    }
    
    return self;
}

- (void)dealloc
{
    self.dropZone = nil;
    
    [super dealloc];
}

@end
