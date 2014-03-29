//
//  MVLocation.h
//  Map
//
//  Created by Matthew Voss on 3/4/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MVLocation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *ceo;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic)         CLLocationCoordinate2D coordinate;



@end
