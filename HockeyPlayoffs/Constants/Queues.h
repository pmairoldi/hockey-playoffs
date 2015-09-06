//
//  Queues.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-06.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#define SYNCHRONIZE_QUEUE dispatch_queue_create([@"com.peteappdesigns.hockey.sync" UTF8String], DISPATCH_QUEUE_SERIAL)
#define DB_SAVE_QUEUE dispatch_queue_create([@"com.peteappdesigns.hockey.db.save" UTF8String], DISPATCH_QUEUE_CONCURRENT)
#define DB_FETCH_QUEUE dispatch_queue_create([@"com.peteappdesigns.hockey.db.fetch" UTF8String], DISPATCH_QUEUE_CONCURRENT)
#define DATE_PICKER_QUEUE dispatch_queue_create([@"com.peteappdesigns.hockey.datepicker" UTF8String], DISPATCH_QUEUE_CONCURRENT)
