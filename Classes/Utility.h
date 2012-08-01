//
//  Utility.h
//  Affinity
//
//  Created by Christophe Bergé on 24/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XMLParser.h"


@interface Utility : NSObject {

}

- (UITabBarItem *)getItem:(NSString *)itemTitle imagePath:(NSString *)imagePath tag:(NSInteger)tag;

@end
