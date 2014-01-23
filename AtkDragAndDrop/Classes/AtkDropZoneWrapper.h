//
//  AtkDropZoneWrapper.h
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/18/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtkDropZoneProtocol.h"

@interface AtkDropZoneWrapper : NSObject

@property (nonatomic, retain) id<AtkDropZoneProtocol> dropZone;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL isInterested;

- (id)initWithDropZone:(id<AtkDropZoneProtocol>)dropZone interested:(BOOL)interested;

@end
