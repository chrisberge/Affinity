//
//  Intervalle.m
//  Affinity
//
//  Created by Christophe Bergé on 15/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Intervalle.h"


@implementation Intervalle

@synthesize min, max;

- (BOOL) setValueForKey: (NSString *) key
			 WithString: (NSString *) string {
	int valeur;
	BOOL result;
	NSScanner *scan = [NSScanner localizedScannerWithString:string];
	[scan scanInt:&valeur];
	result = [scan isAtEnd];
	if (result) {
		[self setValue:[NSNumber numberWithInt:valeur] forKey:key];
	}
	return result;
}

- (void) setMin: (int) newValue {
	min = newValue;
}

- (void) setMax: (int) newValue {
	max = newValue;
}


@end
