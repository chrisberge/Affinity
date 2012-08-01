//
//  ArrayWithIndex.m
//  RezoImmoTest1
//
//  Created by Christophe Bergé on 23/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ArrayWithIndex.h"


@implementation ArrayWithIndex
@synthesize arrayIndex, array, titre;

- (id)initWithIndexAndArray:(int)index array:(NSMutableArray *) tableau info:(NSString *) info

{
	
    self = [super init];
	
    if (self) {
		
        arrayIndex = index;
		array = tableau;
        titre = info;
		
    }
	
    return self;
	
}

@end
