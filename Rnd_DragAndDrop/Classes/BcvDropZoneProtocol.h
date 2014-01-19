//
//  BcvDropZoneProtocol.h
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BcvDropZoneProtocol <NSObject>

@optional

- (BOOL)containsPoint:(UIView *)baseView point:(CGPoint)point;

@required

- (BOOL)dragStarted;
- (void)dragEnded;
- (void)dragEntered:(CGPoint)point;
- (void)dragExited:(CGPoint)point;
- (void)dragMoved:(CGPoint)point;
- (void)dragDropped:(CGPoint)point;

@end
