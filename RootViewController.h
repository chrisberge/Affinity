//
//  RootViewController.h
//  Affinity
//
//  Created by Christophe Bergé on 16/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ChoixVilleController3.h"
#import "SelectionTypeBienController.h"
#import "SelectionSurfaceController.h"
#import "SelectionNbPiecesController.h"
#import "SelectionBudgetController.h"
#import "AfficheListeAnnoncesController2.h"
#import "Intervalle.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "XMLParser.h"
#import "AffinityAppDelegate.h"

@class ASINetworkQueue;
@class AffinityAppDelegate;

@interface RootViewController : UIViewController {
	NSMutableArray *tableauAnnonces1;
	NSMutableDictionary *criteres1;
    NSMutableDictionary *criteres2;
    NSMutableDictionary *typeBien;
    NSMutableArray *indexPathsVilles;
    BOOL isConnectionErrorPrinted;
    ASINetworkQueue *networkQueue;
    UIImageView *coche;
    UILabel *labelVille;
    UILabel *labelTypeBien;
    UILabel *labelSurface;
    UILabel *labelNbPiece;
    UILabel *labelBudget;
    int nbRequetes;
    AffinityAppDelegate *appDelegate;
}

@property (nonatomic, copy) NSMutableArray *tableauAnnonces1;
@property (nonatomic, copy) NSMutableDictionary *criteres1;
@property (nonatomic, assign) NSMutableDictionary *criteres2;

-(UIImage *) getImage:(NSString *)cheminImage;
- (void) makeRequest;
- (void) sauvegardeRecherches;

@end
