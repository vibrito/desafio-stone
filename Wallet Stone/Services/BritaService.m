//
//  BritaService.m
//  Wallet Stone
//
//  Created by Vinicius Brito on 08/05/18.
//  Copyright © 2018 Vinicius Brito. All rights reserved.
//

#import "BritaService.h"
#import "AFHTTPSessionManager.h"

@implementation BritaService

+ (void)callServiceCotation:(NSString *)type onSuccess:(void (^)(Coin *coin))onSuccessBlock onFailure:(void (^)(NSError *error))onFailureBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/CotacaoDolarDia(dataCotacao=@dataCotacao)?%40dataCotacao=%2705-07-2018%27&%24format=json" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        Coin *brita = [[Coin alloc] init];
        brita.acronym = @"BRI";
        brita.priceSell =  [responseObject[@"value"][0][@"cotacaoCompra"]doubleValue];
        brita.priceBuy =  [responseObject[@"value"][0][@"cotacaoVenda"]doubleValue];
        brita.name = @"Brita";
        
        onSuccessBlock(brita);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        onFailureBlock(error);
    }];
}

@end
