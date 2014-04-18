//
//  AtkSampleThreeCollectionViewCell.h
//  AtkDragAndDrop_Examples
//
//  Created by Rick Boykin on 4/11/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AtkSampleThreeCellData.h"

@interface AtkSampleThreeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;

@property (nonatomic) AtkSampleThreeCellData *cellData;

@end
