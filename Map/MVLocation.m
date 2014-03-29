//
//  MVLocation.m
//  Map
//
//  Created by Matthew Voss on 3/4/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "MVLocation.h"
#import <AddressBook/AddressBook.h>

@implementation MVLocation


-(MKMapItem *)mapItem
{
    NSDictionary *addressDict = @{(NSString *)kABPersonAddressStateKey: _address};
    
    MKPlacemark *placeMark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placeMark];
    
    mapItem.name = self.title;
    
    return mapItem;
    
}

-(NSString *)title
{
    return _name;
}

-(NSString *)subtitle
{
    return _address;
}

-(CLLocationCoordinate2D)coordinate
{
    return _coordinate;
}

@end
