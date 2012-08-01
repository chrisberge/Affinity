//
//  XMLParserInfos.m
//  Affinity
//
//  Created by Christophe Bergé on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLParserInfos.h"

@implementation XMLParserInfos

- (XMLParserInfos *) initXMLParser {
    
	[super init];
	appDelegate = (AffinityAppDelegate *)[[UIApplication sharedApplication] delegate];
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"infos"]) {
		
		infos = [[Infos alloc] init];
		
		//Extract the attribute here.
		//uneAnnonce.idAnnonce = [[attributeDict objectForKey:@"id"] integerValue];
		
		//NSLog(@"Reading id value :%i", uneAnnonce.idAnnonce);
	}
	
	//NSLog(@"Processing Element: %@", elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
	
	//NSLog(@"Processing Value: %@", currentElementValue);
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if([elementName isEqualToString:@"infos_agence"])
		return;
    
	//There is nothing to do if we encounter the Books element here.
	//If we encounter the Book element howevere, we want to add the book object to the array
	// and release the object.
	if([elementName isEqualToString:@"infos"]) {
        [appDelegate.accueilView.tableauInfos addObject:infos];
        
		[infos release];
		infos = nil;
	}
	else{
        NSString *elementValueString = currentElementValue;
        
        elementValueString = [elementValueString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
		[infos setValue:elementValueString forKey:elementName];
    }
	
	[currentElementValue release];
	currentElementValue = nil;
}

@end
