//
//  TableViewController.h
//  new-wether-app
//
//  Created by Mac on 26/02/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <MapKit/MapKit.h>
@interface TableViewController : UITableViewController<UITextFieldDelegate>
@property (nonatomic,retain)UITextField *citytf;
@property(nonatomic,retain)UIButton *findbtn;
//@property (nonatomic,retain)UIView *view;
@property(nonatomic,retain)NSMutableArray *resarr,*imgarr;
@property float latitude,langitude;
@property (nonatomic,retain)NSOperationQueue *queue;
@property(nonatomic,retain)CLGeocoder *geocoder;
@end
