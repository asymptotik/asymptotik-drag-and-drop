//
//  AtkDropZoneWrapper.h
//  AtkDragAndDrop
//
//  Created by Rick Boykin on 1/18/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtkDropZoneProtocol.h"

@interface AtkDropZoneWrapper : NSObject

@property (nonatomic, strong) id<AtkDropZoneProtocol> dropZone;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL isInterested;

- (id)initWithDropZone:(id<AtkDropZoneProtocol>)dropZone interested:(BOOL)interested;

@end
