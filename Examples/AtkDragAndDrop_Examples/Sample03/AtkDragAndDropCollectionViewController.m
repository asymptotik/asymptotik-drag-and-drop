//
//  AtkDragAndDropCollectionViewController.m
//  AtkDragAndDrop_Examples
//
//  Created by Rick Boykin on 4/17/14.
//  Copyright (c) 2014 Asymptotik Limited. All rights reserved.
//

//
//  Ideas borrowed from Luke Scott
//  https://github.com/lukescott/DraggableCollectionView
//

#import "AtkDragAndDropCollectionViewController.h"
#import "AtkDraggableCollectionViewDataSource.h"
#import "AtkDragAndDropCollectionViewLayoutProtocol.h"

static int kObservingCollectionViewLayoutContext;

@interface AtkDragAndDropCollectionViewController ()
{
    NSIndexPath *lastIndexPath;
    UIImageView *mockCell;
    CGPoint mockCenter;
    BOOL canWarp;
    BOOL canScroll;
}

@end

@implementation AtkDragAndDropCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self layoutChanged];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id<AtkDragAndDropCollectionViewLayoutProtocol>)layoutProtocol
{
    id<AtkDragAndDropCollectionViewLayoutProtocol> ret = nil;
    
    if([self.collectionViewLayout conformsToProtocol:@protocol(AtkDragAndDropCollectionViewLayoutProtocol)])
    {
        ret = (id<AtkDragAndDropCollectionViewLayoutProtocol>)self.collectionViewLayout;
    }
    return ret;
}

- (void)layoutChanged
{
    canWarp = [self.collectionView.collectionViewLayout respondsToSelector:@selector(modifiedLayoutAttributesForElements:)];
    canScroll = [self.collectionView.collectionViewLayout respondsToSelector:@selector(scrollDirection)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &kObservingCollectionViewLayoutContext) {
        [self layoutChanged];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (UIImage *)imageFromCell:(UICollectionViewCell *)cell {
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, cell.isOpaque, 0.0f);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (NSIndexPath *)indexPathForItemClosestToPoint:(CGPoint)point
{
    NSArray *layoutAttrsInRect;
    NSInteger closestDist = NSIntegerMax;
    NSIndexPath *indexPath;
    NSIndexPath *toIndexPath = self.layoutProtocol.toIndexPath;
    
    // We need original positions of cells
    self.layoutProtocol.toIndexPath = nil;
    layoutAttrsInRect = [self.collectionView.collectionViewLayout layoutAttributesForElementsInRect:self.collectionView.bounds];
    self.layoutProtocol.toIndexPath = toIndexPath;
    
    // What cell are we closest to?
    for (UICollectionViewLayoutAttributes *layoutAttr in layoutAttrsInRect)
    {
        CGFloat xd = layoutAttr.center.x - point.x;
        CGFloat yd = layoutAttr.center.y - point.y;
        NSInteger dist = sqrtf(xd*xd + yd*yd);
        if (dist < closestDist)
        {
            closestDist = dist;
            indexPath = layoutAttr.indexPath;
        }
    }
    
    // Are we closer to being the last cell in a different section?
    NSInteger sections = [self.collectionView numberOfSections];
    for (NSInteger i = 0; i < sections; ++i) {
        if (i == self.layoutProtocol.fromIndexPath.section)
        {
            continue;
        }
        NSInteger items = [self.collectionView numberOfItemsInSection:i];
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:items inSection:i];
        UICollectionViewLayoutAttributes *layoutAttr;
        CGFloat xd, yd;
        
        if (items > 0)
        {
            layoutAttr = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:nextIndexPath];
            xd = layoutAttr.center.x - point.x;
            yd = layoutAttr.center.y - point.y;
        }
        else
        {
            // Trying to use layoutAttributesForItemAtIndexPath while section is empty causes EXC_ARITHMETIC (division by zero items)
            // So we're going to ask for the header instead. It doesn't have to exist.
            layoutAttr = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                  atIndexPath:nextIndexPath];
            xd = layoutAttr.frame.origin.x - point.x;
            yd = layoutAttr.frame.origin.y - point.y;
        }
        
        NSInteger dist = sqrtf(xd*xd + yd*yd);
        if (dist < closestDist) {
            closestDist = dist;
            indexPath = layoutAttr.indexPath;
        }
    }
    
    return indexPath;
}

- (void)warpToIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath == nil || [lastIndexPath isEqual:indexPath])
    {
        return;
    }
    lastIndexPath = indexPath;
    
    if ([self.collectionView.dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:toIndexPath:)] == YES
        && [(id<AtkDraggableCollectionViewDataSource>)self.collectionView.dataSource
            collectionView:self.collectionView
            canMoveItemAtIndexPath:self.layoutProtocol.fromIndexPath
            toIndexPath:indexPath] == NO) {
            return;
        }
    [self.collectionView performBatchUpdates:^{
        self.layoutProtocol.hideIndexPath = indexPath;
        self.layoutProtocol.toIndexPath = indexPath;
    } completion:nil];
}

#pragma - mark AtkDropZoneProtocol

- (BOOL)isActive:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    return [self.view isActiveDropZone:manager point:point];
}

- (BOOL)shouldDragStart:(AtkDragAndDropManager *)manager
{
    return YES;
}

- (void)dragStarted:(AtkDragAndDropManager *)manager
{
    NSLog(@"AtkSampleThreeCollectionViewController.dragStarted");
    [self.collectionView autoScrollDragStarted];
}

- (BOOL)isInterested:(AtkDragAndDropManager *)manager
{
    NSLog(@"AtkSampleThreeCollectionViewController.isInterested");
    return YES;
}

- (void)dragEnded:(AtkDragAndDropManager *)manager
{
    NSLog(@"AtkSampleThreeCollectionViewController.dragEnded");
    [self.collectionView autoScrollDragEnded];
}

- (void)dragEntered:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    //NSLog(@"AtkSampleThreeCollectionViewController.dragEntered");
    
    NSIndexPath *indexPath = [self indexPathForItemClosestToPoint:[manager.rootView convertPoint:point toView:self.collectionView]];
    
    if (indexPath == nil) {
        return;
    }
    if (![(id<AtkDraggableCollectionViewDataSource>)self.collectionView.dataSource
          collectionView:self.collectionView
          canMoveItemAtIndexPath:indexPath]) {
        return;
    }
    
    // Start warping
    lastIndexPath = indexPath;
    self.layoutProtocol.fromIndexPath = indexPath;
    self.layoutProtocol.hideIndexPath = indexPath;
    self.layoutProtocol.toIndexPath = indexPath;
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)dragExited:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    NSLog(@"AtkSampleThreeCollectionViewController.dragExited");
}

- (void)dragMoved:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    [self.collectionView autoScrollDragMoved:[manager.rootView convertPoint:point toView:self.view]];
    NSIndexPath *indexPath = [self indexPathForItemClosestToPoint:[manager.rootView convertPoint:point toView:self.collectionView]];
    [self warpToIndexPath:indexPath];
}

- (void)dragDropped:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    NSLog(@"AtkSampleThreeCollectionViewController.dragDropped");
    
    if(manager.pasteboard.numberOfItems == 0)
    {
        return;
    }
    
    // Need these for later, but need to nil out layoutHelper's references sooner
    NSIndexPath *fromIndexPath = self.layoutProtocol.fromIndexPath;
    NSIndexPath *toIndexPath = self.layoutProtocol.toIndexPath;
    
    // Tell the data source to move the item
    id<AtkDraggableCollectionViewDataSource> dataSource = (id<AtkDraggableCollectionViewDataSource>)self.collectionView.dataSource;
    [dataSource collectionView:self.collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
    
    // Move the item
    [self.collectionView performBatchUpdates:^{
        [self.collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
        self.layoutProtocol.fromIndexPath = nil;
        self.layoutProtocol.toIndexPath = nil;
    } completion:^(BOOL finished) {
        if (finished) {
            if ([dataSource respondsToSelector:@selector(collectionView:didMoveItemAtIndexPath:toIndexPath:)]) {
                [dataSource collectionView:self.collectionView didMoveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
            }
        }
    }];
    
    // Reset
    lastIndexPath = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
