//
//  AtkDragAndDropCollectionViewLayoutProtocol.h
//  AtkDragAndDrop_Examples
//
//  Created by Rick Boykin on 4/17/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AtkDragAndDropCollectionViewLayoutProtocol <NSObject>

@property (nonatomic) NSIndexPath *fromIndexPath;
@property (nonatomic) NSIndexPath *toIndexPath;
@property (nonatomic) NSIndexPath *hideIndexPath;

- (NSArray *)modifiedLayoutAttributesForElements:(NSArray *)elements;

@end
