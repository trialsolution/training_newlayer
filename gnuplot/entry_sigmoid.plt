# modelling the entry price system

# CAPRI applies a modified sigmoid function
# this is a function of the 'entry price driver'


# here's a plot with different slope parameters (in CAPRI it's 20)
# x=driver!
valx(x)=x<0?x:0
plot [-20:10] (exp(valx(x)) / ( 1 + 20*exp(-abs(x)))) ,\
(exp(valx(x)) / ( 1 + 10*exp(-abs(x)))) ,\
(exp(valx(x)) / ( 1 + 1*exp(-abs(x))))

pause -1

# the driver itself is calculated by a linear relationship
# Note that v_entryprice is either fixed or can be subject to preferential trigger prices
# (and so calculated by the tarSpec_ equation with the v_TRQSigmoidFunc variable)
# v_entryPrice = PrefTriggerP + (TriggerP - PrefTriggerP) * v_trqSigmoidFunc
# here we deal with the case when v_entryPrice is fixed

entryprice = 100
tc = 20
triggerp = 100
factor = 100
# the factor scales up the driver (calibrated to observed levels)
 

plot [65:120] (((entryprice * (.98+.92)/2) - (x+tc)) / triggerp * factor)



