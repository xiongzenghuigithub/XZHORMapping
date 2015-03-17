//
//  ViewController.m
//  FMDBWrapper
//
//  Created by sfpay on 15/3/17.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import "ViewController.h"

#import "FMDBWrapperKit.h"

#import "PersonList.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person *person = [[Person alloc] init];
    person.name = @"dzhangsan001";
    person.age = 21;
    person.isMan = YES;
    person.date = [NSDate date];
    person.data = [[NSData alloc] init];
    
    Person *person1 = [[Person alloc] init];
    person1.name = @"dzhangsan001";
    person1.age = 21;
    person1.isMan = YES;
    person1.date = [NSDate date];
    person1.data = [[NSData alloc] init];
    
    PersonList *list = [[PersonList alloc] init];
    list.personList = @[person, person1];
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [NSString stringWithFormat:@"%@/%@", documentPath, @"personArray"];

    [list writeToFile:path atomically:YES];
    
    id obj = [NSObject objectWithContentsOfFile:path];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
