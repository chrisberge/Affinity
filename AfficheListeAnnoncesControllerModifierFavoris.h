//
//  AfficheListeAnnoncesControllerModifierFavoris.h
//  Affinity
//
//  Created by Christophe Bergé on 13/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//  UTILISEE DEPUIS MODIFIER FAVORIS

#import <UIKit/UIKit.h>
#import "Annonce.h"
#import "AfficheAnnonceControllerModifierFavoris.h"
#import "ProgressViewContoller.h"


@interface AfficheListeAnnoncesControllerModifierFavoris : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *listeAnnonces;
    NSMutableDictionary *criteres;
	Annonce *annonceSelected;
    UITableView *tableView1;
    UIButton *boutonPrix;
    UIButton *boutonSurface;
    UIButton *boutonDate;
    ProgressViewContoller *pvc;
    AffinityAppDelegate *appDelegate;
}

@property (nonatomic, copy) NSMutableArray *listeAnnonces;
@property (nonatomic, copy) NSMutableDictionary *criteres;
@property (nonatomic, copy) Annonce *annonceSelected;

-(NSString *)setTextMinMax:(NSString *)critere unit:(NSString *)unit texte:(NSString *)text;

@end
