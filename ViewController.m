#import "Record.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#import "ViewController.h"
#import "FlightsController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UITextField *cityFrom;
@property (weak, nonatomic) IBOutlet UITextField *cityTo;

@property int isCity;
@property MKPointAnnotation *annotatiionFrom;
@property MKPointAnnotation *annotatiionTo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.map addGestureRecognizer:longPressGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleLongPressGesture:(UIGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint point = [sender locationInView:self.map];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        CLLocationCoordinate2D coord = [self.map convertPoint:point toCoordinateFromView:self.map];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
        {
             if (error) {
                 NSLog(@"Geocode failed with error: %@", error);
                 return;
             }
             for (CLPlacemark * placemark in placemarks) {
                  [self setAnnotationToMap:self.isCity :placemark.locality :coord];
             }
        }];
    }
}

-(void)setAnnotationToMap:(int)type :(NSString *)title :(CLLocationCoordinate2D)coordinate
{
    if (type == 0) {
        [self.map removeAnnotation:self.annotatiionFrom];
        self.annotatiionFrom = [[MKPointAnnotation alloc] init];
        self.annotatiionFrom.title = title;
        self.annotatiionFrom.coordinate = coordinate;
        [self.map addAnnotation:self.annotatiionFrom];
        self.cityFrom.text = title;
    }
    else
    {
        [self.map removeAnnotation:self.annotatiionTo];
        self.annotatiionTo = [[MKPointAnnotation alloc] init];
        self.annotatiionTo.title = title;
        self.annotatiionTo.coordinate = coordinate;
        [self.map addAnnotation:self.annotatiionTo];
        self.cityTo.text = title;
    }
}

- (IBAction)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.cityFrom)
        self.isCity = 0;
    else if (textField == self.cityTo)
        self.isCity = 1;
    [textField resignFirstResponder];
}

- (IBAction)showFlights:(id)sender {
    BOOL fail = NO;
    if (self.cityFrom.text.length == 0) {
        [self shake:self.cityFrom direction:1 times:5];
        fail = YES;
    }
    if (self.cityTo.text.length == 0) {
        [self shake:self.cityTo direction:1 times:5];
        fail = YES;
    }
    if (!fail) {
        FlightsController *flights =[[FlightsController alloc] initWithCityFrom:self.cityFrom.text withCityTo:self.cityTo.text];
        [self presentViewController:flights animated:YES completion:nil];
    }
}

-(void)shake:(UIView *)theOneYouWannaShake direction:(int)direction times:(int)times
{
    [UIView animateWithDuration:0.1 animations:^
    {
        theOneYouWannaShake.transform = CGAffineTransformMakeTranslation(5*direction, 0);
    }
    completion:^(BOOL finished)
    {
        if(times <= 0)
        {
            theOneYouWannaShake.transform = CGAffineTransformIdentity;
            return;
        }
        [self shake:theOneYouWannaShake direction:-direction times:times-1];
    }];
}

@end
