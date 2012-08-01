//
//  RechercheCarte2.h
//  Affinity
//
//  Created by Christophe Bergé on 18/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AfficheListeAnnoncesController2.h"
#import "XMLParser.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "ProgressViewContoller.h"

@class ASINetworkQueue;

@interface RechercheCarte2 : UIViewController {
    ASINetworkQueue *networkQueue;
    
    NSMutableDictionary *criteres1;
    NSMutableArray *tableauAnnonces1;
    NSMutableArray *tableauAnnoncesTab;
    //NSMutableArray *tableauAnnoncesPrestigeTab;
    NSMutableArray *labelTab;
    NSMutableArray *buttonTab;
    int indexAnnoncesTab;
    NSString *typeTransaction;
    BOOL isConnectionErrorPrinted;
    BOOL isRequestFinished;
    ProgressViewContoller *pvc;
    UIButton *boutonVente;
    UIButton *boutonLocation;
    UIButton *boutonPrestige;
    BOOL isBiensPrestige;
    
}

@property (nonatomic, copy) NSMutableDictionary *criteres1;
@property (nonatomic, copy) NSMutableArray *tableauAnnonces1;

- (void) sendRequest;
- (void) makeRequest:(NSString *)transaction;
- (void) makeRequestPrestige;
- (void) showButtonsAndLabels;

@end
