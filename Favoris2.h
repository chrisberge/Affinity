//
//  Favoris2.h
//  Affinity
//
//  Created by Christophe Bergé on 05/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "AfficheListeAnnoncesController3.h"
#import "Annonce.h"
#import "AfficheAnnonceController4.h"
#import "ProgressViewContoller.h"
#import "AffinityAppDelegate.h"
#import "RootViewControllerModifierFavoris.h"

@class RootViewControllerModifierFavoris;
@class ASINetworkQueue;
@class XMLParser;
@class AffinityAppDelegate;

@interface Favoris2 : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>{
    UITableView *tableView1;
    NSMutableArray *recherchesSauvees;
    NSMutableArray *biensSauves;
    
    UIButton *boutonRangee1;
    UIButton *boutonRangee2;
    UIButton *boutonRangee3;
    
    UIButton *modifierRangee1;
    UIButton *modifierRangee2;
    UIButton *modifierRangee3;
    
    UIButton *supprimerRangee1;
    UIButton *supprimerRangee2;
    UIButton *supprimerRangee3;
    
    BOOL noRecherche;
    UILabel *labelType1;
    UILabel *labelVille1;
    UILabel *labelPrix1;
    UILabel *labelSurface1;
    
    UILabel *labelType2;
    UILabel *labelVille2;
    UILabel *labelPrix2;
    UILabel *labelSurface2;
    
    UILabel *labelType3;
    UILabel *labelVille3;
    UILabel *labelPrix3;
    UILabel *labelSurface3;
    
    RootViewControllerModifierFavoris *rechercheMulti;
    NSString *whichView;
    NSMutableArray *tableauAnnonces1;
    
    BOOL isConnectionErrorPrinted;
    ASINetworkQueue *networkQueue;
    NSMutableDictionary *criteres2;
    
    ProgressViewContoller *pvc;
    
    Annonce *annonceSelected;
    int indexASupprimer;
    
    AffinityAppDelegate *appDelegate;
}

@property (nonatomic, assign) NSString *whichView;
@property (nonatomic, retain) RootViewControllerModifierFavoris *rechercheMulti;
@property (nonatomic, copy) NSMutableArray *tableauAnnonces1;
@property (nonatomic, copy) NSMutableArray *biensSauves;
@property (nonatomic, copy) Annonce *annonceSelected;
@property (nonatomic, assign) NSMutableDictionary *criteres2;

- (void)getBiens;

@end
