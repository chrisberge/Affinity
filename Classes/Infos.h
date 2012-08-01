//
//  Infos.h
//  Affinity
//
//  Created by Christophe Bergé on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Infos : NSObject{
    NSString *coordonnees_globales;
    NSString *coordonnees_postales;
    NSString *email_agence;
    NSString *fax_agence;
    NSString *nom_appli;
    NSString *presentation_agence;
    NSString *site_agence;
    NSString *telephone_agence;
}

@property (nonatomic, retain) NSString *coordonnees_globales;
@property (nonatomic, retain) NSString *coordonnees_postales;
@property (nonatomic, retain) NSString *email_agence;
@property (nonatomic, retain) NSString *fax_agence;
@property (nonatomic, retain) NSString *nom_appli;
@property (nonatomic, retain) NSString *presentation_agence;
@property (nonatomic, retain) NSString *site_agence;
@property (nonatomic, retain) NSString *telephone_agence;

@end
