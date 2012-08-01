//
//  Intervalle.h
//  Affinity
//
//  Created by Christophe Bergé on 15/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Intervalle : NSObject {
	int min;
	int max;
}

@property (nonatomic,assign) int min;
@property (nonatomic,assign) int max;

-(BOOL) setValueForKey: (NSString *) key WithString: (NSString *) string;

@end
