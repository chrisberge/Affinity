//
//  AddressAnnotation.m
//  Affinity
//
//  Created by Christophe Bergé on 16/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddressAnnotation.h"


@implementation AddressAnnotation

@synthesize coordinate;

- (NSString *)subtitle{
    NSError *error;
    NSString *fullPath;
    NSString *texte;
    
    error = nil;
    
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    texte = [NSString stringWithContentsOfFile: [directory stringByAppendingPathComponent:@"coordonnees-postales.txt"]
                                      encoding:NSUTF8StringEncoding
                                         error:&error];
    
    if (texte == nil) {
    
        fullPath = [[NSBundle mainBundle] pathForResource:@"coordonnees-postales" ofType:@"txt"];
        texte = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&error];
    }
    return texte;
}

- (NSString *)title{
    NSError *error;
    NSString *fullPath;
    NSString *texte;
    
    error = nil;
    
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    texte = [NSString stringWithContentsOfFile: [directory stringByAppendingPathComponent:@"nom-appli.txt"]
                                      encoding:NSUTF8StringEncoding
                                         error:&error];
    
    if (texte == nil) {
    
        fullPath = [[NSBundle mainBundle] pathForResource:@"nom-appli" ofType:@"txt"];
        texte = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&error];
    }
    return texte;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
    coordinate=c;
    //NSLog(@"%f,%f",c.latitude,c.longitude);
    return self;
}


@end
