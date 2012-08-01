#import <UIKit/UIKit.h>
#import "AFItemView.h"
#import <QuartzCore/QuartzCore.h>


@protocol AFOpenFlowViewDataSource;
@protocol AFOpenFlowViewDelegate;

@interface AFOpenFlowViewDiapo : UIView {
	id <AFOpenFlowViewDataSource>	dataSource;
	id <AFOpenFlowViewDelegate>	viewDelegate;
	NSMutableSet					*offscreenCovers;
	NSMutableDictionary				*onscreenCovers;
	NSMutableDictionary				*coverImages;
	NSMutableDictionary				*coverImageHeights;
	UIImage							*defaultImage;
	CGFloat							defaultImageHeight;
    
	UIScrollView					*scrollView;
	int								lowerVisibleCover;
	int								upperVisibleCover;
	int								numberOfImages;
	int								beginningCover;
	
	AFItemView						*selectedCoverView;
    
	CATransform3D leftTransform, rightTransform;
	
	CGFloat halfScreenHeight;
	CGFloat halfScreenWidth;
	
	Boolean isSingleTap;
	Boolean isDoubleTap;
	Boolean isDraggingACover;
	CGFloat startPosition;
}

@property (nonatomic, assign) id <AFOpenFlowViewDataSource> dataSource;
@property (nonatomic, assign) id <AFOpenFlowViewDelegate> viewDelegate;
@property (nonatomic, retain) UIImage *defaultImage;
@property int numberOfImages;

- (void)setSelectedCover:(int)newSelectedCover;
- (void)centerOnSelectedCover:(BOOL)animated;
- (void)setImage:(UIImage *)image forIndex:(int)index;

@end

@protocol AFOpenFlowViewDelegate <NSObject>
@optional
- (void)openFlowView:(AFOpenFlowViewDiapo *)openFlowView selectionDidChange:(int)index;
@end

@protocol AFOpenFlowViewDataSource <NSObject>
- (void)openFlowView:(AFOpenFlowViewDiapo *)openFlowView requestImageForIndex:(int)index;
- (UIImage *)defaultImage;
@end