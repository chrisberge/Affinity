//
//  Ville.h
//  AppliAgenceVilles
//
//  Created by Christophe Bergé on 04/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ville : NSObject{
    NSString *nom;
	NSString *cp;
	
}

@property (nonatomic, retain) NSString *nom;
@property (nonatomic, retain) NSString *cp;

@end
