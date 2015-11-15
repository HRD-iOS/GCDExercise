//
//  ViewController.m
//  GCDExercise
//
//  Created by Yin Kokpheng on 11/13/15.
//  Copyright © 2015 Yin Kokpheng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource ,NSURLConnectionDelegate>

@end

@implementation ViewController

NSMutableData *_responseData;
NSMutableArray* json;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.customTable.delegate = self;
    self.customTable.dataSource = self;
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL:
                                       [NSURL URLWithString:@"https://api.parse.com/1/classes/APUploadToParse"]];
    urlRequest.HTTPMethod = @"GET";
    [urlRequest addValue:@"jGJU4zicgO4Fiejw6sLwYqQn7qcQbqVvOQyo76Y3" forHTTPHeaderField:@"X-Parse-Application-Id"];
     [urlRequest addValue:@"ZiWq01FMNJTse8qc1vIyQ2NSUsu3UKgqt7DXdZVS"
       forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return json.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [_customTable dequeueReusableCellWithIdentifier:@"cellContact" forIndexPath:indexPath];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[[json objectAtIndex:indexPath.row] objectForKey:@"image"] objectForKey:@"url"]]];
    
    cell.imageView.frame = CGRectMake(0, 0, 80.0, 80.);
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.clipsToBounds = YES;
    cell.imageView.image = [UIImage imageWithData:data];
    cell.textLabel.text = [[json objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
       
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSError* error;
    NSArray *root =[NSJSONSerialization JSONObjectWithData:_responseData
                                                   options:kNilOptions
                                                     error:&error];
    
    json = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"results"]];
    
    
    NSLog(@"%@", json);
    [self.customTable reloadData];
    

    
}


@end
