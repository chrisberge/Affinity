//
//  Annonce.m
//  RezoImmoTest1
//
//  Created by Christophe Bergé on 01/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Annonce.h"


@implementation Annonce

@synthesize ref,
            type,
            nb_pieces,
            surface,
            ville,
            codePostal,
            prix,
            description,
            bilan_ce,
            bilan_ges,
            etage,
            ascenseur,
            chauffage,
            photos,
            date;

- (void) dealloc {
    [ref release];
    [type release];
	[nb_pieces release];
	[surface release];
	[ville release];
	[codePostal release];
	[prix release];
	[description release];
    [bilan_ce release];
    [bilan_ges release];
	[photos release];
    [etage release];
    [ascenseur release];
    [chauffage release];
    [date release];
	[super dealloc];
}

@end
