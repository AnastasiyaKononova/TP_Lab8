#import "FlightsController.h"
#import "AppDelegate.h"
#import "Record.h"

@interface FlightsController ()
@property (weak, nonatomic) IBOutlet UILabel *flightLabel;

@end

@implementation FlightsController {
    NSString* _cityFrom;
    NSString* _cityTo;
    NSArray* _flights;
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithCityFrom: (NSString*)cityFrom withCityTo: (NSString*)cityTo {
    if (self == [super init]) {
        _cityFrom = cityFrom;
        _cityTo = cityTo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _flights = [appDelegate getFlightsFrom:_cityFrom to:_cityTo];
    self.flightLabel.text = [NSString stringWithFormat:@"%@ -> %@", _cityFrom, _cityTo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_flights count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Record *flight = [_flights objectAtIndex:[indexPath indexAtPosition:1]];
    NSString *label = [NSString stringWithFormat:@"%@ %@", flight.aviaCompany, flight.price];
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = label;
    
    return cell;
}

@end
