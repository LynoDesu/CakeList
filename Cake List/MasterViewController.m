//
//  MasterViewController.m
//  Cake List
//
//  Created by Stewart Hart on 19/05/2015.
//  Copyright (c) 2015 Stewart Hart. All rights reserved.
//

#import "MasterViewController.h"
#import "CakeCell.h"

@interface MasterViewController ()
@property (strong, nonatomic) NSArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor orangeColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(loadCakeData)
                  forControlEvents:UIControlEventValueChanged];
    
    [self loadCakeData];
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CakeCell *cell = (CakeCell*)[tableView dequeueReusableCellWithIdentifier:@"CakeCell"];
    
    NSDictionary *object = self.objects[indexPath.row];
    cell.titleLabel.text = object[@"title"];
    cell.descriptionLabel.text = object[@"desc"];

    NSURL *aURL = [NSURL URLWithString:object[@"image"]];
    
    //Asynchronously download cake image
    [self downloadCakeImage:aURL forImageView:cell.cakeImageView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)loadCakeData{
    
    NSURL *url = [NSURL URLWithString:@"https://gist.githubusercontent.com/hart88/198f29ec5114a3ec3460/raw/8dd19a88f9b8d24c23d9960f3300d0c917a4f07c/cake.json"];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSError *jsonError;
    id responseData = [NSJSONSerialization
                       JSONObjectWithData:data
                       options:kNilOptions
                       error:&jsonError];
    if (!jsonError){
        self.objects = responseData;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    } else {
        [self showErrorDialog];
    }
    
}

- (void)downloadCakeImage:(NSURL *)url forImageView:(UIImageView *)imageView
{
    imageView.alpha = 0;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
    queue:[NSOperationQueue mainQueue]
    completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
       if ( !error )
       {
           UIImage *image = [[UIImage alloc] initWithData:data];
           [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
               imageView.image = image;
               imageView.alpha = 1;
           } completion:^(BOOL finished) {}];
       } else {
           NSLog(@"%@", error);
       }
    }];
}

- (void)showErrorDialog
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Error"
                                 message:@"There was a problem loading the cakes."
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {}];
    
    UIAlertAction* retryButton = [UIAlertAction
                               actionWithTitle:@"Retry"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [self loadCakeData];
                               }];
    
    [alert addAction:okButton];
    [alert addAction:retryButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
