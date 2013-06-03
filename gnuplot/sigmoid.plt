# modelling export subsidies in CAPRI 
# continous approximation of an if-then condition
#
# the original sigmoid definition: sigmoid(x) = exp[min(x,0)] / [1+exp(-abs(x))]
# rewritten with an ifthen structure as the min() function is not available in gnuplot
#

sigmoid1(x)=1/(1+exp(-x))
sigmoid2(x) = exp(x)/(1+exp(x))
sigmoid(x) = x<0?sigmoid2(x):sigmoid1(x)
plot [-5:5] sigmoid(x)


#
# the sigmoid function in GAMS is: sigmoid(x) = 1/(1+exp(-x))
# so it is simply the positive part of the above ...
#

#
# the actual implementation of the export subsidy function in CAPRI follows as:
#

# from the CAPRI working paper (old CAPRI implementation, outdated):
feoe_max = 100
alpha = 10
beta = 10
padm = 250

# x is the commodity market price in this case
exps(x) = feoe_max * (1-sigmoid( alpha/(beta*padm) * (x-beta*padm)))

#plot [210:300] exps(x)

# from the CAPRI code itself!
# x is the market price
sigmpar = 1
corrfact = 1
exps2(x) = feoe_max * sigmoid(sigmpar * (padm-(corrfact*x)) / padm )
plot [100:400] exps2(x)

# SA on sigmoid function parameters
# actual calibrated values can be found in sim_ini.gdx under pv_bevFuncSubsExpCorrFact and pv_sigmParSubsExports
# plot different values for the slope parameter
plot [100:400] sigmoid(5 * (padm-(corrfact*x)) / padm) ,\
sigmoid(15 * (padm-(corrfact*x)) / padm) ,\
sigmoid(30 * (padm-(corrfact*x)) / padm) ,\
sigmoid(50 * (padm-(corrfact*x)) / padm) 

# plot different values for the correction factor
plot [100:400] sigmoid(50 * (padm-(1*x)) / padm) ,\
sigmoid(50 * (padm-(1.1*x)) / padm) ,\
sigmoid(50 * (padm-(1.5*x)) / padm) ,\
sigmoid(50 * (padm-(.9*x)) / padm) ,\
sigmoid(50 * (padm-(.8*x)) / padm) 
