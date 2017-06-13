//
//  TableViewController.m
//  new-wether-app
//
//  Created by Mac on 26/02/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _resarr=[[NSMutableArray alloc]init];
    _imgarr=[[NSMutableArray alloc]initWithObjects:@"summary.jpeg",@"1",@"3",@"humidity.jpeg",@"cloud", nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1st.jpeg"]];
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _geocoder=[[CLGeocoder alloc]init];
    _queue=[[NSOperationQueue alloc]init];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 100;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v1=[[UIView alloc]initWithFrame:CGRectMake(0,50, 200, 200)];
    
  //  v1.backgroundColor=[UIColor colorWithRed:106/255.0 green:192/255.0 blue:201/255.0 alpha:1.0];
    v1.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"title.jpeg"]];
    _citytf.delegate=self;
    _citytf=[[UITextField alloc]initWithFrame:CGRectMake(10, 20, 100, 50)];
    _citytf.placeholder=@"city";
    _citytf.backgroundColor=[UIColor whiteColor];
    _findbtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    _findbtn.frame=CGRectMake(150, 20,100, 50);
    [_findbtn setTitle:@"find" forState:UIControlStateNormal];
    
    _findbtn.backgroundColor=[UIColor colorWithRed:161/255.0 green:130/255.0 blue:160/255.0 alpha:1.0];
    [_findbtn addTarget:self action:@selector(findclick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_citytf];
    [self.view addSubview:_findbtn];
    return v1;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(void)findclick{
    
    NSString *add=_citytf.text;
    NSLog(@"%@",add);
    
    [_geocoder geocodeAddressString:add completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *currentlocation=[placemarks objectAtIndex:0];
        CLLocation *location=currentlocation.location;
        CLLocationCoordinate2D cord=location.coordinate;
        _latitude=cord.latitude;
        _langitude=cord.longitude;
        
      
    
    [_resarr removeAllObjects];
    NSLog(@"%f %f",_latitude,_langitude);
    NSString *s=[NSString stringWithFormat:@"https://api.darksky.net/forecast/acdb16bf251f5f104eb5f067dd4b6f60/%f,%f",_latitude,_langitude];
    NSBlockOperation *op1=[NSBlockOperation blockOperationWithBlock:^{
        NSURL *url=[NSURL URLWithString:s];
        NSData *data=[NSData dataWithContentsOfURL:url];
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSDictionary *dict1=[dict valueForKey:@"currently"];
        
        [_resarr addObject:[NSString stringWithFormat:@"%@",[dict1 valueForKey:@"summary"]]];
        NSString *sum=[dict1 valueForKey:@"summary"];
    
               NSString *temp=[dict1 valueForKey:@"temperature"];
        NSString * deg=@"ºf";
        float t=[temp floatValue];
       // NSLog(@"%0.0f",t);
        [_resarr addObject:[NSString stringWithFormat:@"%0.0f %@",t,deg]];
      //  [_resarr addObject:[dict1 valueForKey:@"summary"]];
        
        [_resarr addObject:[NSString stringWithFormat:@"%@",[dict1 valueForKey:@"pressure"]]];
       [_resarr addObject:[NSString stringWithFormat:@"%@",[dict1 valueForKey:@"humidity"]]];
        
        
        [_resarr addObject:[NSString stringWithFormat:@"%@",[dict1 valueForKey:@"cloudCover"]]];
        
        [[NSOperationQueue mainQueue ]addOperationWithBlock:^{
           NSLog(@"%@",_resarr);
            if([sum isEqualToString:@"Clear"])
                self.tableView.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clearsky.jpeg"]];
            if([sum isEqualToString:@"Partly Cloudy"])
                self.tableView.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"partly-cloudy.jpeg"]];
            if([sum isEqualToString:@"Cloudy"])
                self.tableView.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cloudy.jpeg"]];
            if([sum isEqualToString:@"Dry"])
                self.tableView.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dry.jpeg"]];
            [self.tableView reloadData];
        }];
    }];
    [_queue addOperation:op1];
    
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return _resarr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
   
   
    // Configure the cell...
   [ cell setBackgroundColor:[UIColor clearColor]];
    cell.contentView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.1];

    cell.lbl1.text=[_resarr objectAtIndex:indexPath.row];
    cell.imgview.image=[UIImage imageNamed:[_imgarr objectAtIndex:indexPath.row]];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
