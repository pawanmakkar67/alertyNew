//
//  MapViewController.m
//  Alerty
//
//  Created by moni on 9/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "RouteAnnotation.h"
#import "config.h"
#import <QuartzCore/QuartzCore.h>
#import "AlertySettingsMgr.h"

#import "MapImage.h"
#import "MapImageOverlay.h"
#import "MapImageOverlayView.h"
#import "Polyline.h"
#import "IndoorMap.h"
#import "AlertyDBMgr.h"
#import "IconDownloader.h"
#import "AlertyAppDelegate.h"

@import Proximiio;
@import ProximiioMapbox;
@import Mapbox;


@interface MapViewController() <MGLMapViewDelegate>

@property (nonatomic, strong) MGLMapView* mapView;
@property (nonatomic, strong) ProximiioMapbox* mapBoxHelper;
@property (nonatomic, strong) NSTimer* timer;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSURL* styleURL = [NSURL URLWithString:@"https://portal.getalerty.com/style.json"];
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds /*styleURL:styleURL*/];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = NO;
    self.mapView.showsHeading = NO;
    [self.view addSubview:self.mapView];

    if (self.mapView) {
        ProximiioMapboxConfiguration* configuration = [[ProximiioMapboxConfiguration alloc] initWithToken:Proximiio.sharedInstance.token];
        configuration.showUserLocation = NO;
        self.mapBoxHelper = [[ProximiioMapbox alloc] init];
        [self.mapBoxHelper setupWithMapView:self.mapView configuration:configuration];
        self.mapBoxHelper.followingUser = NO;
        [self.mapBoxHelper initialize:^(enum ProximiioMapboxAuthorizationResult result) {
        }];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem.enabled = [[self.videoURLString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     
    // Draw the polygon after the map has initialized
    //[self drawShape];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.mapView.frame = self.view.bounds;
}

- (void)drawShape {

    /*CLLocationCoordinate2D coordinates[] = {
        CLLocationCoordinate2DMake(45.522585, -122.685699),
        CLLocationCoordinate2DMake(45.534611, -122.708873),
        CLLocationCoordinate2DMake(45.530883, -122.678833),
        CLLocationCoordinate2DMake(45.547115, -122.667503),
        CLLocationCoordinate2DMake(45.530643, -122.660121),
        CLLocationCoordinate2DMake(45.533529, -122.636260),
        CLLocationCoordinate2DMake(45.521743, -122.659091),
        CLLocationCoordinate2DMake(45.510677, -122.648792),
        CLLocationCoordinate2DMake(45.515008, -122.664070),
        CLLocationCoordinate2DMake(45.502496, -122.669048),
        CLLocationCoordinate2DMake(45.515369, -122.678489),
        CLLocationCoordinate2DMake(45.506346, -122.702007),
        CLLocationCoordinate2DMake(45.522585, -122.685699),
    };
    NSUInteger numberOfCoordinates = sizeof(coordinates) / sizeof(CLLocationCoordinate2D);
    
    MGLShapeSource* source = [[MGLShapeSource alloc] initWithIdentifier:@"polyline" shape:nil options:nil];
    source.shape = [MGLPolylineFeature polylineWithCoordinates:coordinates count:numberOfCoordinates];
    [self.mapBox.style addSource:source];
    
    MGLLineStyleLayer* layer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"polyline" source:source];
    layer.lineColor = [MGLStyleValue<UIColor*> valueWithRawValue:UIColor.redColor];
    //layer.lineWidth = [MGLStyleValue valueWithRawValue:@"mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, [14: 5, 18: 20])"];
    layer.lineWidth = [MGLStyleValue valueWithRawValue:@10];
    [self.mapBox.style addLayer:layer];*/
}

- (UIColor *)mapView:(MGLMapView *)mapView strokeColorForShapeAnnotation:(MGLShape *)annotation {
    return UIColor.redColor;
}

- (CGFloat)mapView:(MGLMapView *)mapView lineWidthForPolylineAnnotation:(MGLPolyline *)annotation {
    return 5.0;
}


/*- (CGFloat)mapView:(MGLMapView *)mapView alphaForShapeAnnotation:(MGLShape *)annotation {
// Set the alpha for shape annotations to 0.5 (half opacity)
return 0.5f;
}*/
 
/*- (UIColor *)mapView:(MGLMapView *)mapView strokeColorForShapeAnnotation:(MGLShape *)annotation {
// Set the stroke color for shape annotations
return [UIColor whiteColor];
}*/
 
/*- (UIColor *)mapView:(MGLMapView *)mapView fillColorForPolygonAnnotation:(MGLPolygon *)annotation {
// Mapbox cyan fill color
return [UIColor colorWithRed:59.0f/255.0f green:178.0f/255.0f blue:208.0f/255.0f alpha:1.0f];
}*/

#pragma mark - MapView

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    
    //[self.mapBoxHelper floorAt:0];

    self.mapView.showsUserLocation = NO;
    
    CLLocationCoordinate2D startLoc = CLLocationCoordinate2DMake(self.startLatitude.doubleValue, self.startLongitude.doubleValue);
    [self.mapView setCenterCoordinate:startLoc zoomLevel:14.0 animated:YES];

    if (self.bounds) {
        [self setMapBounds];
        [self drawPolyline];
    }
                            
    MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
    point.coordinate = startLoc;
    
    // Create a data source to hold the point data
    //MGLShapeSource *shapeSource = [[MGLShapeSource alloc] initWithIdentifier:@"marker-source" shape:point options:nil];
     
    // Create a style layer for the symbol
    //MGLSymbolStyleLayer *shapeLayer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"marker-style" source:shapeSource];
    
    // Add the image to the style's sprite
    //[style setImage:[UIImage imageNamed:@"ic_location"] forName:@"home-symbol"];
     
    // Tell the layer to use the image in the sprite
    //shapeLayer.iconImageName = [NSExpression expressionForConstantValue:@"home-symbol"];
     
    // Add the source and style layer to the map
    //[style addSource:shapeSource];
    //[style addLayer:shapeLayer];
    
    point.title = NSLocalizedString(@"Start", @"");
    point.subtitle = self.startDate;
    [self.mapView addAnnotation: point];
    
    /*ProximiioMarker* marker = [[ProximiioMarker alloc] initWithCoordinate:startLoc identifier:@"start" image:[UIImage imageNamed:@"alert_center"]];
    marker.title = NSLocalizedString(@"Start", @"");
    marker.subtitle = self.startDate;
    [self.mapView addMarker:marker];
            
    [self.mapView setCenter:startLoc animated:YES];*/
    
    if (self.mapId) {
        for (ProximiioFloor* floor in Proximiio.sharedInstance.floors) {
            NSInteger mapId = [floor.floorId integerValue];
            if (self.mapId == mapId) {
                
                /*for (MGLStyleLayer* layer in style.layers) {
                    if ([layer.identifier containsString:@"proximiio-raster_floorplan"]) {
                        //[style removeLayer:layer];
                        //[style addLayer:layer];
                        break;
                    }
                }*/
                
                [self.mapBoxHelper floorAt:[floor.level integerValue]];
                
                NSArray<ProximiioLocation*>* anchors = floor.anchors;
                CLLocationCoordinate2D c1 = anchors[0].coordinate;
                CLLocationCoordinate2D c2 = anchors[1].coordinate;
                CLLocationCoordinate2D c3 = anchors[2].coordinate;
                CLLocationCoordinate2D c4 = anchors[3].coordinate;
                double left = MIN(c1.longitude, MIN(c2.longitude, MIN(c3.longitude, c4.longitude)));
                double bottom = MIN(c1.latitude, MIN(c2.latitude, MIN(c3.latitude, c4.latitude)));
                double right = MAX(c1.longitude, MAX(c2.longitude, MAX(c3.longitude, c4.longitude)));
                double top = MAX(c1.latitude, MAX(c2.latitude, MAX(c3.latitude, c4.latitude)));
            
                MGLCoordinateBounds bounds = MGLCoordinateBoundsMake(CLLocationCoordinate2DMake(bottom, left), CLLocationCoordinate2DMake(top, right));
                [self.mapView setVisibleCoordinateBounds:bounds animated:NO];
                if (self.mapView.zoomLevel > 14.0) {
                    self.mapView.zoomLevel = 14.0;
                }
                
                //MapImage* mapImage = [[MapImage alloc] initWithProximiioFloor:floor];
                
                //NSURL* url = [NSURL URLWithString:floor.floorPlanImageURL];
                //MGLImageSource* imageSource = [[MGLImageSource alloc] initWithIdentifier:@"floormap" coordinateQuad:MGLCoordinateQuadMake(mapImage.overlayTopLeftCoordinate, mapImage.overlayBottomRightCoordinate, mapImage.overlayBottomLeftCoordinate, mapImage.overlayTopRightCoordinate) URL:url];
                //[self.mapView.style addSource:imageSource];
     
                //MGLRasterStyleLayer* layer = [[MGLRasterStyleLayer alloc] initWithIdentifier:@"floormap" source:imageSource];
                //layer.rasterOpacity = [MGLStyleValue alloc] init;
                //[style addLayer:layer];
                
                break;
            }
        }
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            NSArray<MGLStyleLayer*>* layers = self.mapView.style.layers;
            for (MGLStyleLayer* layer in layers) {
                layer.visible = YES;
            }
        }];
    }];
}

/*- (void)mapDidLoad:(ProximiioMap *)map {
    
    self.mapView.showUserLocation = NO;
    self.mapView.showPointsOfInterest = NO;
    self.mapView.cameraPitch = 0.0;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [self.mapView setTrackingMode: kProximiioTrackingModeDisabled];
        [self.mapView setCenter:CLLocationCoordinate2DMake(45.520486, -122.673541)];
        //[self.mapView setUserLocation:[ProximiioLocation locationWithLatitude:45.520486 longitude:-122.673541]];
    }];
        
    
    self.mapView.showUserLocation = NO;
    if (self.tracking) {
        [self drawTracking];
    }
    CLLocationCoordinate2D startLoc = CLLocationCoordinate2DMake(self.startLatitude.doubleValue, self.startLongitude.doubleValue);
    if (self.bounds) {
        [self setMapBounds];
        [self drawPolyline];
    } else {
        ProximiioMarker* marker = [[ProximiioMarker alloc] initWithCoordinate:startLoc identifier:@"start" image:[UIImage imageNamed:@"alert_center"]];
        marker.title = NSLocalizedString(@"Start", @"");
        marker.subtitle = self.startDate;
        [self.mapView addMarker:marker];
                
        [self.mapView setCenter:startLoc animated:YES];
        [self.mapView setZoomLevel:15.0];
    }
    
    if (self.mapId) {
        for (ProximiioFloor* floor in Proximiio.sharedInstance.floors) {
            NSInteger mapId = [floor.indoorAtlasFloorPlanId integerValue];
            if (self.mapId == mapId) {
                if (floor.floorPlanImageURL.length) {

                    [self.mapView addFloorPlanForFloor:floor];
                    break;
                }
            }
        }
    }
}*/

#pragma mark - Video button callback

- (void)didPressVideoButton:(id)sender {
    [self playVideo];
}

- (void)setMapBounds {
    
    NSDictionary *sw = [self.bounds objectForKey:VIDEO_MAP_SW];
    CLLocationCoordinate2D southWestPoint = CLLocationCoordinate2DMake([[sw objectForKey:@"latitude"] doubleValue],
                                                                        [[sw objectForKey:@"longitude"] doubleValue]);
    NSDictionary *ne = [self.bounds objectForKey:VIDEO_MAP_NE];
    CLLocationCoordinate2D northEastPoint = CLLocationCoordinate2DMake([[ne objectForKey:@"latitude"] doubleValue],
                                                                        [[ne objectForKey:@"longitude"] doubleValue]);
    
    MGLCoordinateBounds bounds = MGLCoordinateBoundsMake(southWestPoint, northEastPoint);
    [self.mapView setVisibleCoordinateBounds:bounds animated:NO];
    if (self.mapView.zoomLevel > 14.0) {
        self.mapView.zoomLevel = 14.0;
    }
}

- (void)drawPolyline {
    /*NSMutableString *pl = [self.polyline mutableCopy];*/
    
    NSMutableArray *coords = [self decodePolyLine:self.polyline];
    
    CLLocationCoordinate2D* pointArr = malloc(sizeof(CLLocationCoordinate2D) * coords.count);
    for(NSUInteger idx = 0; idx < coords.count; idx++) {
        pointArr[idx] = ((CLLocation*)[coords objectAtIndex:idx]).coordinate;
    }
    //Polyline *routeLine = [Polyline polylineWithCoordinates:pointArr count:coords.count];
    //free(pointArr);
    
    //CLLocation *startLoc = [coords objectAtIndex:0];
    /*RouteAnnotation *startAnn = [[RouteAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(startLoc.coordinate.latitude, startLoc.coordinate.longitude)];
    startAnn.title = NSLocalizedString(@"Start", @"");
    startAnn.subtitle = self.startDate;
    [self.mapView addAnnotation:startAnn];*/
    
    /*ProximiioMarker* marker = [[ProximiioMarker alloc] initWithCoordinate:startLoc.coordinate identifier:@"start"];
    marker.title = NSLocalizedString(@"Start", @"");
    marker.subtitle = self.startDate;
    [self.mapView addMarker:marker];
    
    CLLocation *endLoc = [coords objectAtIndex:[coords count] - 1];*/
    /*RouteAnnotation *endAnn = [[RouteAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(endLoc.coordinate.latitude, endLoc.coordinate.longitude)];
    endAnn.title = NSLocalizedString(@"End", @"");
    endAnn.subtitle = self.cancelDate;
    [self.mapView addAnnotation:endAnn];*/
    
    /*marker = [[ProximiioMarker alloc] initWithCoordinate:endLoc.coordinate identifier:@"end"];
    marker.title = NSLocalizedString(@"End", @"");
    marker.subtitle = self.cancelDate;
    [self.mapView addMarker:marker];*/
    
    //[self.mapView addOverlay:routeLine];
    
    //NSUInteger numberOfCoordinates = sizeof(pointArr) / sizeof(CLLocationCoordinate2D);
    if (coords.count > 0) {
        MGLShapeSource* source = [[MGLShapeSource alloc] initWithIdentifier:@"polyline" shape:nil options:nil];
        source.shape = [MGLPolylineFeature polylineWithCoordinates:pointArr count:coords.count];
        [self.mapView.style addSource:source];
        
        MGLLineStyleLayer* layer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"polyline" source:source];
        layer.lineColor = [NSExpression expressionForConstantValue:UIColor.redColor];     //[MGLStyleValue<UIColor*> valueWithRawValue:UIColor.redColor];
        //layer.lineWidth = [MGLStyleValue valueWithRawValue:@"mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, [14: 5, 18: 20])"];
        layer.lineWidth = [NSExpression expressionForConstantValue:@10]; // [MGLStyleValue valueWithRawValue:@10];
        [self.mapView.style addLayer:layer];
    }
}

- (void)drawTracking {
    /*NSMutableArray<CLLocation*>* coords = [NSMutableArray array];
    NSArray* coordinates = [self.tracking componentsSeparatedByString:@"|"];
    for (NSInteger i=0; i<coordinates.count/2; i++) {
        CLLocation* c = [[CLLocation alloc] initWithLatitude:[coordinates[2*i] doubleValue] longitude:[coordinates[2*i+1] doubleValue]];
        [coords addObject:c];
    }
    
    //    MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * coords.count);
    MKMapPoint* pointArr = malloc(sizeof(MKMapPoint) * coords.count);
    for(int idx = 0; idx < coords.count; idx++) {
        MKMapPoint point = MKMapPointForCoordinate(((CLLocation *)[coords objectAtIndex:idx]).coordinate);
        pointArr[idx] = point;
    }
    
    MKPolyline *routeLine = [Polyline polylineWithPoints:pointArr count:coords.count];
    [routeLine setTitle:@"tracking"];
    free(pointArr);*/
    
    /*CLLocation *startLoc = [coords objectAtIndex:0];
    RouteAnnotation *startAnn = [[RouteAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(startLoc.coordinate.latitude, startLoc.coordinate.longitude)];
    startAnn.title = NSLocalizedString(@"Start", @"");
    startAnn.subtitle = self.startDate;
    [self.mapView addAnnotation:startAnn];
    [startAnn release];
    
    CLLocation *endLoc = [coords objectAtIndex:[coords count] - 1];
    RouteAnnotation *endAnn = [[RouteAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(endLoc.coordinate.latitude, endLoc.coordinate.longitude)];
    endAnn.title = NSLocalizedString(@"End", @"");
    endAnn.subtitle = self.cancelDate;
    [self.mapView addAnnotation:endAnn];
    [endAnn release];*/
    
    //[self.mapView addOverlay:routeLine];
}

- (NSMutableArray *) decodePolyLine:(NSString *)encoded {
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    
    while (index < len) {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while ((b >= 0x20) && (index < len));
        if( index >= len )
        {
            break;
        }
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while ((b >= 0x20) && (index < len));
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        
        float latitude = lat * 1e-5;
        float longitude = lng * 1e-5;
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        [array addObject:loc];
    }
    return array;
}

#pragma mark - MKMapViewDelegate

/*- (MKAnnotationView *) mapView:(MKMapView *)MapView viewForAnnotation:(id <MKAnnotation>) annotation {
    if([annotation isKindOfClass:[RouteAnnotation class]] ) {
        MKPinAnnotationView *annView = (MKPinAnnotationView *)[MapView dequeueReusableAnnotationViewWithIdentifier:@"RouteAnnView"];
        if (annView == nil) annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"RouteAnnView"];
        
        if (annotation.title == NSLocalizedString(@"End", @"")) {
            annView.pinTintColor = UIColor.greenColor;
        } else {
            annView.pinTintColor = UIColor.redColor;
        }
        annView.opaque = NO;
        annView.canShowCallout = YES;
        return annView;
    }
    return nil;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:MapImageOverlay.class]) {
        MapImageOverlayView *overlayView = [[MapImageOverlayView alloc] initWithOverlay:overlay overlayImage:((MapImageOverlay*)overlay).overlayImage rotation:((MapImageOverlay*)overlay).rotation];
        return overlayView;
    }
    if ([overlay isKindOfClass:MKPolyline.class]) {
        MKPolylineRenderer* renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        renderer.strokeColor = [UIColor redColor];
        if ([overlay.title isEqualToString:@"tracking"]) {
            renderer.lineDashPhase = 15;
            NSArray* array = [NSArray arrayWithObjects:[NSNumber numberWithInt:20], [NSNumber numberWithInt:20], nil];
            renderer.lineDashPattern = array;
        } else {
            renderer.lineWidth = 10.0;
        }
        return renderer;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //[mapView setNeedsDisplay];
}*/

#pragma mark - View lifecycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
