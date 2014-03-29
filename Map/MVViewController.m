//
//  MVViewController.m
//  Map
//
//  Created by Matthew Voss on 3/4/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "MVViewController.h"
#import <MapKit/MapKit.h>
#import "MVLocation.h"

#define METERS_PER_MILE 1609.344

@interface MVViewController ()

@property (nonatomic, strong) MKMapView *myMapView;
@property (nonatomic, strong) NSMutableArray *locaitonArray;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) NSArray *searchLoactions;

@end

@implementation MVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locaitonArray = [NSMutableArray new];

    
    self.myMapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    self.myMapView.delegate = self;
    
    
    [self.view addSubview:self.myMapView];
    
    
    
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    [self.view addSubview:self.searchTextField];
    self.searchTextField.delegate = self;
    self.searchTextField.backgroundColor = [UIColor blueColor];
    
    
    
    CLLocationCoordinate2D someLocation;
    
    someLocation.latitude = 47.6097;
    someLocation.longitude = -122.3331;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(someLocation, (3 * METERS_PER_MILE), (3 * METERS_PER_MILE));
    
    [self.myMapView setRegion:viewRegion animated:YES];
    
    [self downLoadTechCompanies];
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
}


-(void)downLoadTechCompanies
{
    NSString *searchString = [NSString stringWithFormat:@"http://opendata.socrata.com/resource/mg7b-2utv.json"];
    NSURL *searchURL = [NSURL URLWithString:searchString];
    
    NSData *searchData = [NSData dataWithContentsOfURL:searchURL];
    
    NSError *error;
    
    NSArray *techArray = [NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingMutableContainers error:&error];
    
    for (NSDictionary *dictionary in techArray) {
        MVLocation  *location = [MVLocation new];
        location.ceo = [dictionary objectForKey:@"ceo"];
        location.name   = [dictionary objectForKey:@"company_name"];
       
        NSDictionary *address = [dictionary objectForKey:@"location"];
        location.address = [address objectForKey:@"human_address"];
      
        CLLocationCoordinate2D tempCord;
        tempCord.latitude = [[address objectForKey:@"latitude"] doubleValue];
        tempCord.longitude = [[address objectForKey:@"longitude"] doubleValue];
        location.coordinate = tempCord;
        
        [self.locaitonArray addObject:location];
        [self.myMapView addAnnotation:location];
    }
    
    
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSString *identifier = @"MyLoacation";
    
    if ([annotation isKindOfClass:[MVLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *)[self.myMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        return annotationView;
        
    }

    return nil;
}

-(void)search
{
 
    MKCoordinateRegion region;
    region.center.latitude = 47.6097;
    region.center.latitude = -122.3331;
    
    region.span.latitudeDelta = 0.2;
    region.span.longitudeDelta  = 0.2;
    
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.region = region;
    
    request.naturalLanguageQuery = self.searchTextField.text;
    
    MKLocalSearchCompletionHandler completionHandler = ^(MKLocalSearchResponse *response, NSError *error)
    {
        if (error) {
            NSLog(@"error");
        } else{
            self.searchLoactions = response.mapItems;
            for (MKMapItem *item in self.searchLoactions) {
                MVLocation *loc = [MVLocation new];
                
                loc.coordinate = item.placemark.coordinate;
                loc.name = item.placemark.name;
                [self.myMapView addAnnotation:loc];
                
            }
        }
        
        
    };
    
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [localSearch startWithCompletionHandler:completionHandler];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self search];
    return true;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
