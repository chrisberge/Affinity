//
//  XMLParserVilles.m
//  AppliAgenceVilles
//
//  Created by Christophe Bergé on 04/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLParserVilles.h"

@implementation XMLParserVilles

- (XMLParserVilles *) initXMLParser {
    
	[super init];
	appDelegate = (AffinityAppDelegate *)[[UIApplication sharedApplication] delegate];
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"ville"]) {
		
		uneVille = [[Ville alloc] init];
		
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
	
	if([elementName isEqualToString:@"villes"])
		return;
    
	//There is nothing to do if we encounter the Books element here.
	//If we encounter the Book element howevere, we want to add the book object to the array
	// and release the object.
	if([elementName isEqualToString:@"ville"]) {
        [appDelegate.accueilView.tableauVilles addObject:uneVille];
        
		[uneVille release];
		uneVille = nil;
	}
	else
    {
        NSString *elementValueString = currentElementValue;
        
        elementValueString = [elementValueString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
		[uneVille setValue:elementValueString forKey:elementName];
    }
	
	[currentElementValue release];
	currentElementValue = nil;
}

@end
