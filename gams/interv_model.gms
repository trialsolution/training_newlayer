$ontext

         Allocation of intervention releases within a policy block
         Release shares are relative price dependent
         Note that the here the sum of releases is fixed. In CAPRI it's variable

$offtext



set RM /E15, E10, BUR/;
alias (RM,RM1);

set commodity /wheat/;

parameter numeraire(RM,commodity);
numeraire('E15',commodity) = 1;


table price(RM, commodity)
        wheat
E15      100
E10      90
BUR      85
;

table stock_shares(RM, commodity)
        wheat
E15      .7
E10      .2
BUR      .1
;

parameter
         release_EU(commodity)
         epsilons (RM, commodity) 'elasticities'
         p_results
;

epsilons(RM,commodity) = 5.;
release_EU('wheat') = 100;



variables
         release(RM, commodity) 'release quants'
         share(RM, commodity) 'shares (for non-numeraires)'
         beta (RM,commodity) 'constant term'
         objective  'dummy objective'
;

positive variables    release(RM, commodity), share(RM, commodity);

equation
         Releases_(RM,commodity)
         Releases_num(RM,commodity)
         Shares_(RM,commodity)
         dummy
;

Releases_(RM,commodity) $ (not numeraire(RM, commodity))..
         release(RM,commodity) =e= release_EU(commodity) * share(RM,commodity);

Releases_num(RM,commodity) $ numeraire(RM, commodity)..
         release(RM,commodity) =e= release_EU(commodity) - sum(RM1 $ (not numeraire(RM1, commodity)), release(RM1,commodity));

Shares_(RM,commodity) $ (not numeraire(RM, commodity))..

         log(share(RM,commodity)) =e= epsilons(RM,commodity) * log( price(RM,commodity))
                                         / sum(RM1 $ numeraire(RM1,commodity), price(RM1,commodity))
                                      + beta(RM,commodity);



dummy..
         objective =e= 10;

model calibration /Releases_, Releases_num, Shares_, dummy/;
* 1. calibration => betas
share.fx(RM,commodity) = stock_shares(RM, commodity);

solve calibration maximizing objective using nlp;

* fix the calibration parameters at calibrated levels
beta.fx(RM,commodity) = beta.L(RM,commodity);

p_results(RM,commodity,"calibration","shares") = share.L(RM,commodity);
p_results(RM,commodity,"calibration","releases") = release.L(RM,commodity);



* 2. simulation under fixed prices
model simulation /Releases_, Releases_num, Shares_, dummy/;

share.lo(RM,commodity) = 0.001;
share.up(RM,commodity) = 1;

* 2a)
price('E15','wheat') = 110;
solve simulation maximizing objective using nlp;

p_results(RM,commodity,"2a","shares") = share.L(RM,commodity);
p_results(RM,commodity,"2a","releases") = release.L(RM,commodity);


* 2b)
price('E15','wheat') = 80;
solve simulation maximizing objective using nlp;

p_results(RM,commodity,"2b","shares") = share.L(RM,commodity);
p_results(RM,commodity,"2b","releases") = release.L(RM,commodity);

* 2c)
price('E15','wheat') = 100;
price('BUR','wheat') = 110;
solve simulation maximizing objective using nlp;

p_results(RM,commodity,"2c","shares") = share.L(RM,commodity);
p_results(RM,commodity,"2c","releases") = release.L(RM,commodity);

