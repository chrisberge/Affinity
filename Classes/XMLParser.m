//
//  XMLParser.m
//  Affinity
//
//  Created by Christophe Bergé on 01/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "XMLParser.h"


@implementation XMLParser

- (XMLParser *) initXMLParser {

	[super init];
	appDelegate = (AffinityAppDelegate *)[[UIApplication sharedApplication] delegate];
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	/*
	if([elementName isEqualToString:@"Annonces"]) {
		//Initialize the array.
		appDelegate.myTableViewController.tableauAnnonces = [[NSMutableArray alloc] init];
	}
	else*/
	if([elementName isEqualToString:@"Annonce"]) {
		
		//Initialize the book.
		uneAnnonce = [[Annonce alloc] init];
		
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
	
	if([elementName isEqualToString:@"Annonces"])
		return;

	//There is nothing to do if we encounter the Books element here.
	//If we encounter the Book element howevere, we want to add the book object to the array
	// and release the object.
	if([elementName isEqualToString:@"Annonce"]) {
        
        if(appDelegate.whichView == @"multicriteres")
            [appDelegate.accueilView.myTableViewController.tableauAnnonces1 addObject:uneAnnonce];
        
        if(appDelegate.whichView == @"carte")
            [appDelegate.accueilView.rechercheCarte.tableauAnnonces1 addObject:uneAnnonce];
        
        if(appDelegate.whichView == @"accueil")
            [appDelegate.accueilView.tableauAnnonces1 addObject:uneAnnonce];
        
        if (appDelegate.whichView == @"favoris_modifier") {
            [appDelegate.favorisView.rechercheMulti.tableauAnnonces1 addObject:uneAnnonce];
        }
        
        if (appDelegate.whichView == @"favoris") {
            [appDelegate.favorisView.tableauAnnonces1 addObject:uneAnnonce];
        }
        
        if (appDelegate.whichView == @"agence") {
            [appDelegate.agenceView.tableauAnnonces1 addObject:uneAnnonce];
        }
        
		[uneAnnonce release];
		uneAnnonce = nil;
	}
	else
    {
        NSString *elementValueString = currentElementValue;
        
        elementValueString = [elementValueString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
		[uneAnnonce setValue:elementValueString forKey:elementName];
    }
	
	[currentElementValue release];
	currentElementValue = nil;
}

@end
