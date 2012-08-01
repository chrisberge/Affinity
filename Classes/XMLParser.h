//
//  XMLParser.h
//  Affinity
//
//  Created by Christophe Bergé on 01/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Annonce.h"
#import "AffinityAppDelegate.h"

@class AffinityAppDelegate, Annonce;

@interface XMLParser : NSObject {
	NSMutableString *currentElementValue;
	Annonce *uneAnnonce;
	AffinityAppDelegate *appDelegate;
}

- (XMLParser *) initXMLParser;

@end
