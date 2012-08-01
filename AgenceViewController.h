//
//  AgenceViewController.h
//  Affinity
//
//  Created by Christophe Bergé on 14/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgenceModalView.h"
#import "AFOpenFlowView.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "Annonce.h"
#import "ProgressViewContoller.h"
#import "XMLParser.h"
#import "AfficheAnnonceController3.h"
#import "AgenceModalVendre.h"
#import "AgenceModalEstimation.h"
#import "AffinityAppDelegate.h"

@class ASINetworkQueue;
@class AFOpenFlowView;
@class AffinityAppDelegate;

@interface AgenceViewController : UIViewController <AgenceModalViewDelegate, AgenceModalViewFicheDelegate, AgenceModalVendreDelegate, AgenceModalEstimationDelegate>{
    NSNumber *buttonTag;
    AFOpenFlowView *myOpenFlowView;
    ASINetworkQueue *networkQueue;
    NSMutableArray *tableauAnnonces1;
    BOOL isConnectionErrorPrinted;
    ProgressViewContoller *pvc;
    Annonce *annonceSelected;
    NSString *whichView;
    AffinityAppDelegate *appDelegate;
}

@property (nonatomic, assign) NSString *whichView;
@property (nonatomic, copy) NSMutableArray *tableauAnnonces1;

@end
