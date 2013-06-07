Quick Tour on the market model calibration
==========================================

The calibration routines are hidden in the create_sim_ini module. The aim of this module is to create a .gdx container with all necessary data for starting a simulation. The calibration parameters of the market model should be clearly part of the 'package'.

The basic idea is to 
1. solve a 'market balancing' problem to derive consistent balances
2. calibrate the behavioural blocks of the market model one by one to the consistent price/quantity framework

Under consistent I mean that the data set is consistent with the model equations, i.e. the data set can technically be a result of the model. Otherwise we can not calibrate the system to that data set.


market1.gms
-----------

The create_sim_ini module calls market1.gms which in turn steers the following calibration steps:
- Data preparation [data_prep]: initial data set for the calibration compiled, including data for base year and growth rates
- Market balancing in order to derive a consistent dataset in the calibration point
- Elasticity trimming (humand demand, supply, processing for oils and cakes, dairy and feed)
- Calibration of the two-tier Armington system (substitution elasticities are fixed)
- Calibration of the Biofuel demand system and the biofuel processing downstreams

All these calibrated parameters are stored in the sim_ini.gdx file in the results folder.


data_cal.gms
------------

The 'market balancing' includes a set of calibration models as well:
 - data_fit is the main balancing model with the following equations
  -- balancing identities for supply, the Armington demand system and for trade
  -- trade policy instruments [! => policy equations must be calibrated before entering data_fit !]
  -- accounting equations along the supply chain, i.e. feeding, processing and biofuel production
  -- price linkages (market price --> producer, consumer, cif, import and Armington prices) and processing margins
 - subsidized exports calibration
 - intervention trimming (both base and final year)
 - TRQ system calibration
 - calibration of feed conversion coeffs.

The 'data_cal' module also includes the preparation of policy related starting values. Tariffs and some policy variables (e.g. minimum border prices) are set here.
Other policy relevant settings are in create_sim_ini; for us mainly relevant is 'policy\mtr_market.gms' where the administrative prices are set.

prep_market.gms
---------------

The prep_market module set the starting values for the market model run and finalizes the calibration. Many of the constant terms are set in this part of the code.
The module include:
 - calibration of the constant terms (supply functions including processing and dairy)
 - calibration of 'commitments' in the demand system (i.e. price independent part of the demand)
 
 As a 'final act' prep_market solves the full market model. That's the first time in the calibration when the full system is tried to be solved. Here we can already check how successful the calibration was...
 