//
//  DiapoController3.h
//  Affinity
//
//  Created by Christophe Bergé on 19/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArrayWithIndex.h"

@protocol DiapoController3Delegate;

@interface DiapoController3 : UIViewController <UIScrollViewDelegate>{
    ArrayWithIndex *arrayWithIndex;
    UIScrollView *diaporama;
    BOOL isFirstRotation;
    int scrollViewWidth;
    int scrollViewIndex;
    UINavigationBar *navBar;
    int page;
}
@property (nonatomic, assign) id <DiapoController3Delegate> delegate;

- (void)getImages:(NSMutableArray *)tableau;

@end

@protocol DiapoController3Delegate
- (void)diapoControllerDidFinish:(DiapoController3 *)controller;
@end
