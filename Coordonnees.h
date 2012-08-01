//
//  Coordonnees.h
//  Affinity
//
//  Created by Christophe Bergé on 08/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CoordonneesDelegate;

@interface Coordonnees : UIViewController

@property (nonatomic, assign) id <CoordonneesDelegate> delegate;

@end

@protocol CoordonneesDelegate
- (void)coordonneesDidFinish:(Coordonnees *)controller;

@end
