//
//  BcvInterestedDropZone.m
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/18/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import "BcvInterestedDropZone.h"

@implementation BcvInterestedDropZone

- (id)initWithDropZone:(id<BcvDropZoneProtocol>)dropZone
{
    if((self = [super init]))
    {
        self.dropZone = dropZone;
        self.isInside = NO;
    }
    
    return self;
}

- (void)dealloc
{
    self.dropZone = nil;
    
    [super dealloc];
}

@end
