//
//  Utility.m
//  Affinity
//
//  Created by Christophe Bergé on 24/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"


@implementation Utility

- (UITabBarItem *)getItem:(NSString *)itemTitle imagePath:(NSString *)imagePath tag:(NSInteger)tag{
	NSString *imageCompletePath = [[[NSBundle mainBundle] resourcePath]  stringByAppendingString:imagePath];
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageCompletePath];
	UITabBarItem *barItem = [[UITabBarItem alloc] initWithTitle:itemTitle image:image tag:tag];
	
	
	return barItem;
	[barItem release];
	[image release];
}

@end
