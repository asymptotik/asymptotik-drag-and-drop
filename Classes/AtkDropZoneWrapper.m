//
//  AtkDropZoneWrapper.m
//  AtkDragAndDrop
//
//  Created by Rick Boykin on 1/18/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import "AtkDropZoneWrapper.h"

@implementation AtkDropZoneWrapper

- (id)initWithDropZone:(id<AtkDropZoneProtocol>)dropZone interested:(BOOL)interested;
{
    if((self = [super init]))
    {
        self.dropZone = dropZone;
        self.isActive = NO;
        self.isInterested = interested;
    }
    
    return self;
}


@end
