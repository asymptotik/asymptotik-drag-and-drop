//
//  BcvInterestedDropZone.h
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/18/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BcvDropZoneProtocol.h"

@interface BcvInterestedDropZone : NSObject

@property (nonatomic, retain) id<BcvDropZoneProtocol> dropZone;
@property (nonatomic, assign) BOOL isInside;

- (id)initWithDropZone:(id<BcvDropZoneProtocol>)dropZone;

@end
