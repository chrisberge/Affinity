//
//  GeolocViewController.h
//  Affinity
//
//  Created by Christophe Bergé on 16/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKReverseGeocoder.h>
#import "AddressAnnotation.h"


@protocol GeolocViewControllerDelegate;

@interface GeolocViewController : UIViewController <MKReverseGeocoderDelegate,MKMapViewDelegate>{
    
}

@property (nonatomic, assign) id <GeolocViewControllerDelegate> delegate;

- (CLLocationCoordinate2D)addressLocationWithAddress:(NSString *)address;

@end

@protocol GeolocViewControllerDelegate
- (void)geolocViewControllerDidFinish:(GeolocViewController *)controller;
@end
