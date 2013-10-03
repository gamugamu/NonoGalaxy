//
//  PCSkinTempProvider.m
//  picrossGame
//
//  Created by Abadie Loic on 01/04/13.
//
//

#import "PCSkinTempProvider.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"

@implementation PCSkinTempProvider

+ (void)replaceSkinWithTempSkin:(NSString*)skinPath{
#if REMPLACESKINLOCAL == 1 && IS_SERVER_MODE != 1
    NSURL *url              = [NSURL URLWithString: GamuGamuTempSkin];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    
    NSError *error = [request error];
    int statusCode = [request responseStatusCode];

    if (!error && statusCode != 404) {
             NSData *response   = [request responseData];
            BOOL didSucceed     = [response writeToFile: skinPath atomically: YES];
            didSucceed? printf("----- skin remplac\n") : printf("impossible de remplacé skin\n");
    }else{
        printf("impossible de récupérer les données skin\n");
    }
#endif
}

+ (void)replaceIndiceWithTempIndice:(NSString*)indicePath{
#if REMPLACESKINLOCAL == 1 && IS_SERVER_MODE != 1
    NSURL *url              = [NSURL URLWithString: GamuGamuTempIndi];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    
    NSError *error = [request error];
    int statusCode = [request responseStatusCode];

    if (!error && statusCode != 404) {
            NSData *response    = [request responseData];
            BOOL didSucceed     = [response writeToFile: indicePath atomically: YES];
            didSucceed? printf("---- indice remplac\n") : printf("impossible de remplacé indice\n");
    }else{
        printf("impossible de récupérer les données indices\n");
    }
#endif
}

+ (void)replaceColorWithTempColor:(NSString**)color subColor:(NSString**)subcolor{
#if REMPLACESKINLOCAL == 1 && IS_SERVER_MODE != 1
    NSURL *url              = [NSURL URLWithString: GamuGamuTempColor];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    
    NSError *error = [request error];
    int statusCode = [request responseStatusCode];
    
    if (!error && statusCode != 404) {
        NSDictionary *response = [[request responseString] JSONValue];
        // ! leaks. Juste bon pour les test. Pas de prod dessus.
        if(color)
            *color       = [[response valueForKey: mapInfoBagroundColor] retain];
        if(subcolor)
            *subcolor    = [[response valueForKey: mapInfoSubBagroundColor] retain];
        printf("---- couleur remplacée\n");
    }else{
        printf("impossible de récupérer les données couleurs\n");
    }
#endif
}

@end
