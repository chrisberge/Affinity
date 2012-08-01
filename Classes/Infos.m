//
//  Infos.m
//  Affinity
//
//  Created by Christophe Bergé on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Infos.h"

@implementation Infos

@synthesize coordonnees_globales,
            coordonnees_postales,
            email_agence,
            fax_agence,
            nom_appli,
            presentation_agence,
            site_agence,
            telephone_agence;

- (void) dealloc {
    [coordonnees_globales release];
    [coordonnees_postales release];
    [email_agence release];
    [fax_agence release];
    [nom_appli release];
    [presentation_agence release];
    [site_agence release];
    [telephone_agence release];
    [super dealloc]; 
}

@end
