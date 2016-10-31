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
bool showCurrentLocationOnLoad = YES;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView.showsUserLocation = YES;
    self.mapView.showsBuildings = YES;
    self.mapView.delegate = self;
    
    database = [DatabaseIntegration sharedInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playgroundsUpdatedNotificationHandler:) name:PLAYGROUNDS_DATA_UPDATED object:nil];
    
    [database updatePlaygrounds];
    [self startLocationManager];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone; //whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestWhenInUseAuthorization]; // Add This Line
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (showCurrentLocationOnLoad == YES) {
        [self goToCurrentLoactionWithLocation:userLocation andMapView:mapView];
        showCurrentLocationOnLoad = NO;
    }
    myLocation = userLocation;
}

- (void)goToCurrentLoactionWithLocation:(MKUserLocation *)userLocation andMapView:(MKMapView *)mapView {
    MKMapCamera* camera = [MKMapCamera cameraLookingAtCenterCoordinate:userLocation.coordinate fromEyeCoordinate:CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude) eyeAltitude:10000];
    [mapView setCamera:camera animated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MKUserTrackingBarButtonItem *buttonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    self.parentViewController.navigationItem.rightBarButtonItem = buttonItem;
    
    showCurrentLocationOnLoad = YES;

    [database updatePlaygrounds];
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

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *pinView = nil;
    if(annotation != self.mapView.userLocation)
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        //pinView.tintColor = MKPinAnnotationColorWhite;
        pinView.canShowCallout = YES;
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //pinView.animatesDrop = YES;
        UIImage * pinImage = [UIImage imageNamed:@"locationPin.png"];
        CGRect imageRect;
        imageRect.size.height = 30;
        imageRect.size.width = 30;
        imageRect.origin = CGPointMake(0, 0);
        UIGraphicsBeginImageContext(imageRect.size);
        [pinImage drawInRect:imageRect];
        pinView.image = UIGraphicsGetImageFromCurrentImageContext();
//        pinView.layer.borderColor = [UIColor colorWithRed:1.0f green:0 blue:0.5f alpha:1.0f].CGColor;
//        pinView.layer.borderWidth = 1.0f;
        pinView.layer.cornerRadius = (imageRect.size.height + imageRect.size.width) / 4;
        
    }
    else {
        [self.mapView.userLocation setTitle:@"I am here"];
    }
    return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
   /*
    // navigation to point
    
    __block MKAnnotationView * blockAnnotationView = view;
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Navigation" message:@"Please select type of navigation to point" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * walkingOption = [UIAlertAction actionWithTitle:@"Walking"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               [self initiateNavigationTo:blockAnnotationView walking:YES];
                                                           }];
    UIAlertAction * drivingOption = [UIAlertAction actionWithTitle:@"Driving"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               [self initiateNavigationTo:blockAnnotationView walking:NO];
                                                           }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                          }];
    
    [alertController addAction:walkingOption];
    [alertController addAction:drivingOption];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^{
    }];
    
    */
}

- (void) initiateNavigationTo: (MKAnnotationView *) annotation walking: (BOOL) walking
{
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:annotation.annotation.coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:annotation.annotation.title];
        
        NSDictionary *launchOptions;
        if(walking == YES)
        {
            launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
        }
        else
        {
            launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        }
        
        
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
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

@end
