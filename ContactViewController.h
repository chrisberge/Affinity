//
//  ContactViewController.h
//  Affinity
//
//  Created by Christophe Bergé on 14/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeolocViewController.h"
#import "Coordonnees.h"
#import "PresentationAkios.h"

@interface ContactViewController : UIViewController <GeolocViewControllerDelegate, CoordonneesDelegate, PresentationAkiosDelegate>{
    
}

@end
