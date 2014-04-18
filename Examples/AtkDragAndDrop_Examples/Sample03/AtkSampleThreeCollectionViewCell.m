//
//  AtkSampleThreeCollectionViewCell.m
//  AtkDragAndDrop_Examples
//
//  Created by Rick Boykin on 4/11/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import "AtkSampleThreeCollectionViewCell.h"

@implementation AtkSampleThreeCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setCellData:(AtkSampleThreeCellData *)cellData
{
    _cellData = cellData;
    _lblTitle.text = cellData.title;
    _lblSubtitle.text = cellData.subTitle;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
