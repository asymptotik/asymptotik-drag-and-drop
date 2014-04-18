//
//  AtkSampleThreeCellData.m
//  AtkDragAndDrop_Examples
//
//  Created by Rick Boykin on 4/11/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import "AtkSampleThreeCellData.h"

@implementation AtkSampleThreeCellData

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle
{
    if((self = [super init]))
    {
        self.title = title;
        self.subTitle = subtitle;
    }
    return self;
}

@end
