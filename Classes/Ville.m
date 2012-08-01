//
//  Ville.m
//  AppliAgenceVilles
//
//  Created by Christophe Bergé on 04/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ville.h"

@implementation Ville

@synthesize nom, cp;

- (void) dealloc {
    [nom release];
	[cp release];
	[super dealloc];
}

@end
