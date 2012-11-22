//
//  Annonce.h
//  RezoImmoTest1
//
//  Created by Christophe Bergé on 01/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Annonce : NSObject {
    NSString *ref;
    NSString *type;
	NSString *nb_pieces;
	NSString *surface;
	NSString *ville;
	NSString *codePostal;
	NSString *prix;
	NSString *description;
    NSString *bilan_ce;
    NSString *bilan_ges;
	NSString *photos;
    NSString *etage;
    NSString *ascenseur;
    NSString *chauffage;
    NSString *date;
	
}

@property (nonatomic, copy) NSString *ref;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *nb_pieces;
@property (nonatomic, copy) NSString *surface;
@property (nonatomic, copy) NSString *ville;
@property (nonatomic, copy) NSString *codePostal;
@property (nonatomic, copy) NSString *prix;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *bilan_ce;
@property (nonatomic, copy) NSString *bilan_ges;
@property (nonatomic, copy) NSString *photos;
@property (nonatomic, copy) NSString *etage;
@property (nonatomic, copy) NSString *ascenseur;
@property (nonatomic, copy) NSString *chauffage;
@property (nonatomic, copy) NSString *date;


@end
