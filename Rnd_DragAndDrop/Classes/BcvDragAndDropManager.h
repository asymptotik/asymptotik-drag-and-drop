//
//  BcvDragAndDropManager.h
//  Rnd_DragAndDrop
//
//  Created by Rick Boykin on 1/17/14.
//  Copyright (c) 2014 Mondo Robot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BcvDragSourceProtocol.h"

@interface BcvDragAndDropManager : NSObject

@property (nonatomic, readonly) UIPasteboard* pasteboard;
@property (nonatomic, readonly) UIView* rootView;

+ (BcvDragAndDropManager *)instance;

- (void)start;
- (void)stop;

- (UIPasteboard *)pasteboardWithObject:(NSObject *)obj forKey:(NSString *)key;
- (CGPoint)convertPoint:(CGPoint)point toView:(UIView *)view;

@end
