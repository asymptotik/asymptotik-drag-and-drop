//
//  AtkSampleThreeCellData.h
//  AtkDragAndDrop_Examples
//
//  Created by Rick Boykin on 4/11/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AtkSampleThreeCellData : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle;

@end
