//
//  XMLParserInfos.h
//  Affinity
//
//  Created by Christophe Bergé on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Infos.h"
#import "AffinityAppDelegate.h"

@class AffinityAppDelegate, Infos;

@interface XMLParserInfos : NSObject{
    NSMutableString *currentElementValue;
	Infos *infos;
	AffinityAppDelegate *appDelegate;
}

- (XMLParserInfos *) initXMLParser;

@end
