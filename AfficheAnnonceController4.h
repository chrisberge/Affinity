//
//  AfficheAnnonceController4.h
//  Affinity
//
//  Created by Christophe Bergé on 08/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//  CLASSE CREEE POUR BIENS FAVORIS

#import <UIKit/UIKit.h>
#import "ArrayWithIndex.h"
#import "Annonce.h"
#import "DiapoController3.h"
#import "AFOpenFlowViewDiapo.h"
#import "ProgressViewContoller.h"
#import "AffinityAppDelegate.h"

@class AffinityAppDelegate;

@interface AfficheAnnonceController4 : UIViewController <DiapoController3Delegate>{
    Annonce *lAnnonce;
	NSMutableArray *imagesArray;
	ArrayWithIndex *arrayWithIndex;
    AFOpenFlowViewDiapo *myOpenFlowView;
    UIScrollView *scrollView;
    ProgressViewContoller *pvc;
    AffinityAppDelegate *appDelegate;
}

@end
