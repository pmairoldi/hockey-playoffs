//
//  TeamHandler.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2013-09-29.
//  Copyright (c) 2013 Pierre-Marc Airoldi. All rights reserved.
//

#import "TeamHandler.h"
#import "Colours.h"

@implementation TeamHandler

+(NSString *)getTeamCity:(NSString *)teamABR{
    
    teamABR = [teamABR uppercaseString];
    
    if ([teamABR isEqualToString:@"ANA"]) {
        return @"Anaheim";
    }
    
    else if ([teamABR isEqualToString:@"BOS"]){
        return @"Boston";
    }
    
    else if ([teamABR isEqualToString:@"BUF"]){
        return @"Buffalo";
    }
    
    else if ([teamABR isEqualToString:@"CGY"]){
        return @"Calgary";
    }
    
    else if ([teamABR isEqualToString:@"CAR"]){
        return @"Carolina";
    }
    
    else if ([teamABR isEqualToString:@"CHI"]){
        return @"Chicago";
    }
    
    else if ([teamABR isEqualToString:@"COL"]){
        return @"Colorado";
    }
    
    else if ([teamABR isEqualToString:@"CBJ"]){
        return @"Columbus";
    }
    
    else if ([teamABR isEqualToString:@"DAL"]){
        return @"Dallas";
    }
    
    else if ([teamABR isEqualToString:@"DET"]){
        return @"Detroit";
    }
    
    else if ([teamABR isEqualToString:@"EDM"]){
        return @"Edmonton";
    }
    
    else if ([teamABR isEqualToString:@"FLA"]){
        return @"Florida";
    }
    
    else if ([teamABR isEqualToString:@"LAK"]){
        return @"Los Angeles";
    }
    
    else if ([teamABR isEqualToString:@"MIN"]){
        return @"Minnesota";
    }
    
    else if ([teamABR isEqualToString:@"MTL"]){
        return @"Montr\u00E9al";
    }
    
    else if ([teamABR isEqualToString:@"NSH"]){
        return @"Nashville";
    }
    
    else if ([teamABR isEqualToString:@"NJD"]){
        return @"New Jersey";
    }
    
    else if ([teamABR isEqualToString:@"NYI"]){
        return @"New York";
    }
    
    else if ([teamABR isEqualToString:@"NYR"]){
        return @"New York";
    }
    
    else if ([teamABR isEqualToString:@"OTT"]){
        return @"Ottawa";
    }
    
    else if ([teamABR isEqualToString:@"PHI"]){
        return @"Philadelphia";
    }
    
    else if ([teamABR isEqualToString:@"PHX"]){
        return @"Phoenix";
    }
    
    else if ([teamABR isEqualToString:@"PIT"]){
        return @"Pittsburgh";
    }
    
    else if ([teamABR isEqualToString:@"SJS"]){
        return @"San Jose";
    }
    
    else if ([teamABR isEqualToString:@"STL"]){
        return @"St.Louis";
    }
    
    else if ([teamABR isEqualToString:@"TBL"]){
        return @"Tampa Bay";
    }
    
    else if ([teamABR isEqualToString:@"TOR"]){
        return @"Toronto";
    }
    
    else if ([teamABR isEqualToString:@"VAN"]){
        return @"Vancouver";
    }
    
    else if ([teamABR isEqualToString:@"WSH"]){
        return @"Washington";
    }
    
    else if ([teamABR isEqualToString:@"WPG"]){
        return @"Winnipeg";
    }
    
    else {
        return @"";
    }
    
    return @"";
}

+(NSString *)getTeamName:(NSString *)teamABR{
    
    teamABR = [teamABR uppercaseString];

    if ([teamABR isEqualToString:@"ANA"]) {
        return @"Ducks";
    }
    
    else if ([teamABR isEqualToString:@"BOS"]){
        return @"Bruins";
    }
    
    else if ([teamABR isEqualToString:@"BUF"]){
        return @"Sabres";
    }
    
    else if ([teamABR isEqualToString:@"CGY"]){
        return @"Flames";
    }
    
    else if ([teamABR isEqualToString:@"CAR"]){
        return @"Hurricanes";
    }
    
    else if ([teamABR isEqualToString:@"CHI"]){
        return @"Blackhawks";
    }
    
    else if ([teamABR isEqualToString:@"COL"]){
        return @"Avalanche";
    }
    
    else if ([teamABR isEqualToString:@"CBJ"]){
        return @"Blue Jackets";
    }
    
    else if ([teamABR isEqualToString:@"DAL"]){
        return @"Stars";
    }
    
    else if ([teamABR isEqualToString:@"DET"]){
        return @"Red Wings";
    }
    
    else if ([teamABR isEqualToString:@"EDM"]){
        return @"Oilers";
    }
    
    else if ([teamABR isEqualToString:@"FLA"]){
        return @"Panthers";
    }
    
    else if ([teamABR isEqualToString:@"LAK"]){
        return @"Kings";
    }
    
    else if ([teamABR isEqualToString:@"MIN"]){
        return @"Wild";
    }
    
    else if ([teamABR isEqualToString:@"MTL"]){
        return @"Canadiens";
    }
    
    else if ([teamABR isEqualToString:@"NSH"]){
        return @"Predators";
    }
    
    else if ([teamABR isEqualToString:@"NJD"]){
        return @"Devils";
    }
    
    else if ([teamABR isEqualToString:@"NYI"]){
        return @"Islanders";
    }
    
    else if ([teamABR isEqualToString:@"NYR"]){
        return @"Rangers";
    }
    
    else if ([teamABR isEqualToString:@"OTT"]){
        return @"Senators";
    }
    
    else if ([teamABR isEqualToString:@"PHI"]){
        return @"Flyers";
    }
    
    else if ([teamABR isEqualToString:@"PHX"]){
        return @"Coyotes";
    }
    
    else if ([teamABR isEqualToString:@"PIT"]){
        return @"Penguins";
    }
    
    else if ([teamABR isEqualToString:@"SJS"]){
        return @"Sharks";
    }
    
    else if ([teamABR isEqualToString:@"STL"]){
        return @"Blues";
    }
    
    else if ([teamABR isEqualToString:@"TBL"]){
        return @"Lightning";
    }
    
    else if ([teamABR isEqualToString:@"TOR"]){
        return @"Maple Leafs";
    }
    
    else if ([teamABR isEqualToString:@"VAN"]){
        return @"Canucks";
    }
    
    else if ([teamABR isEqualToString:@"WSH"]){
        return @"Capitals";
    }
    
    else if ([teamABR isEqualToString:@"WPG"]){
        return @"Jets";
    }
    
    else {
        return @"";
    }
    
    return @"";
}

+(NSString *)getTeamABR:(NSString *)teamName{
    
    teamName = [teamName lowercaseString];
    
    if ([teamName isEqualToString:@"ducks"]) {
        return @"ANA";
    }
    
    else if ([teamName isEqualToString:@"bruins"]) {
        return @"BOS";
    }
    
    else if ([teamName isEqualToString:@"sabres"]) {
        return @"BUF";
    }
    
    else if ([teamName isEqualToString:@"flames"]) {
        return @"CGY";
    }
    
    else if ([teamName isEqualToString:@"hurricanes"]) {
        return @"CAR";
    }
    
    else if ([teamName isEqualToString:@"blackhawks"]) {
        return @"CHI";
    }
    
    else if ([teamName isEqualToString:@"avalanche"]) {
        return @"COL";
    }
    
    else if ([teamName isEqualToString:@"bluejackets"]) {
        return @"CBJ";
    }
    
    else if ([teamName isEqualToString:@"stars"]) {
        return @"DAL";
    }
    
    else if ([teamName isEqualToString:@"redwings"]) {
        return @"DET";
    }
    
    else if ([teamName isEqualToString:@"oilers"]) {
        return @"EDM";
    }
    
    else if ([teamName isEqualToString:@"panthers"]) {
        return @"FLA";
    }
    
    else if ([teamName isEqualToString:@"kings"]) {
        return @"LAK";
    }
    
    else if ([teamName isEqualToString:@"wild"]) {
        return @"MIN";
    }
    
    else if ([teamName isEqualToString:@"canadiens"]) {
        return @"MTL";
    }
    
    else if ([teamName isEqualToString:@"predators"]) {
        return @"NSH";
    }
    
    else if ([teamName isEqualToString:@"devils"]) {
        return @"NJD";
    }
    
    else if ([teamName isEqualToString:@"islanders"]) {
        return @"NYI";
    }
    
    else if ([teamName isEqualToString:@"rangers"]) {
        return @"NYR";
    }
    
    else if ([teamName isEqualToString:@"senators"]) {
        return @"OTT";
    }
    
    else if ([teamName isEqualToString:@"flyers"]) {
        return @"PHI";
    }
    
    else if ([teamName isEqualToString:@"coyotes"]) {
        return @"PHX";
    }
    
    else if ([teamName isEqualToString:@"penguins"]) {
        return @"PIT";
    }
    
    else if ([teamName isEqualToString:@"sharks"]) {
        return @"SJS";
    }
    
    else if ([teamName isEqualToString:@"blues"]) {
        return @"STL";
    }
    
    else if ([teamName isEqualToString:@"lightning"]) {
        return @"TBL";
    }
    
    else if ([teamName isEqualToString:@"mapleleafs"]) {
        return @"TOR";
    }
    
    else if ([teamName isEqualToString:@"canucks"]) {
        return @"VAN";
    }
    
    else if ([teamName isEqualToString:@"capitals"]) {
        return @"WSH";
    }
    
    else if ([teamName isEqualToString:@"jets"]) {
        return @"WPG";
    }
    
    else {
        return @"";
    }
    
    return @"";
}

+(UIColor *)getTeamColor:(NSString *)team{
    
    if (team.length > 3) {
        team = [team stringByPaddingToLength:3 withString:@"" startingAtIndex:0];
    }
    
    if (team.length == 0) {
        
        return LIGHT_GRAY_COLOUR;
    }
    
    NSDictionary *colors = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TeamColors" ofType:@"plist"]];
    
    NSDictionary *teamDict = (NSDictionary *)[colors objectForKey:[team uppercaseString]];
    
    if (teamDict == nil) {
        return LIGHT_GRAY_COLOUR;
    }
    
//    if (team.length == 0) {
//        
//        NSUInteger randomIndex = arc4random() % [[colors allKeys] count];
//        team = [[colors allKeys] objectAtIndex:randomIndex];
//    }
    
    //    NSNumber *redB = [[colors objectForKey:team] objectForKey:@"bottomRed"];
    //    NSNumber *greenB = [[colors objectForKey:team] objectForKey:@"bottomGreen"];
    //    NSNumber *blueB = [[colors objectForKey:team] objectForKey:@"bottomBlue"];
    //    NSNumber *redT = [[colors objectForKey:team] objectForKey:@"topRed"];
    //    NSNumber *greenT = [[colors objectForKey:team] objectForKey:@"topGreen"];
    //    NSNumber *blueT = [[colors objectForKey:team] objectForKey:@"topBlue"];
    
    NSNumber *red = [teamDict objectForKey:@"bottomRed"];
    NSNumber *green = [teamDict objectForKey:@"bottomGreen"];
    NSNumber *blue = [teamDict objectForKey:@"bottomBlue"];
    
    return [UIColor colorWithRed:[[self class] convertToPercentValue:red] green:[[self class] convertToPercentValue:green] blue:[[self class] convertToPercentValue:blue] alpha:1.0];
}

+(CGFloat)convertToPercentValue:(NSNumber *)colorComponent {
    
    return [colorComponent floatValue]/255.0;
}

@end
