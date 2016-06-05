//
//  MapViewController.m
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 5/17/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "MapViewController.h"
#import "DatabaseIntegration.h"

@interface MapViewController ()
{
    DatabaseIntegration * database;
    MKUserLocation * myLocation;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager * locationManager;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    self.mapView.delegate = self;
    self.mapView.showsScale = YES;
    self.mapView.showsCompass = YES;
    database = [DatabaseIntegration sharedInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playgroundsUpdatedNotificationHandler:) name:PLAYGROUNDS_DATA_UPDATED object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    
    UIBarButtonItem * findMeButton = [[UIBarButtonItem alloc] initWithTitle:@"Find me" style:UIBarButtonItemStylePlain target:self action:@selector(findMeButtonTapped:)];
    self.parentViewController.navigationItem.rightBarButtonItem = findMeButton;
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        //        NSLog(@"latitude %+.6f, longitude %+.6f\n",
        //              location.coordinate.latitude,
        //              location.coordinate.longitude);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    myLocation = userLocation;
}

- (void) addPointsToMap
{
    for(NSDictionary * aDictionary in database.playgrounds)
    {
        MKPointAnnotation * annotation = [[MKPointAnnotation alloc] init];
        annotation.title = [aDictionary objectForKey:@"name"];
        annotation.subtitle = [aDictionary objectForKey:@"description"];
        [annotation setCoordinate:
         CLLocationCoordinate2DMake(
                                    [[aDictionary objectForKey:@"latitude"] doubleValue],
                                    [[aDictionary objectForKey:@"longitude"] doubleValue])
         ];
        
        [self.mapView addAnnotation:annotation];
    }
}

- (void) playgroundsUpdatedNotificationHandler: (NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self addPointsToMap];
    });
}

- (void) findMeButtonTapped:(UIButton *)sender {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(myLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
}

@end
