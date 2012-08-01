//
//  ArrayWithIndex.h
//  RezoImmoTest1
//
//  Created by Christophe Bergé on 23/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ArrayWithIndex : NSObject {
	int arrayIndex;
	NSMutableArray *array;
    NSString *titre;

}

@property (nonatomic,assign) int arrayIndex;
@property (nonatomic,assign) NSMutableArray *array;
@property (nonatomic,assign) NSString *titre;

- (id)initWithIndexAndArray:(int)index array:(NSMutableArray *) tableau info:(NSString *) info;

@end
