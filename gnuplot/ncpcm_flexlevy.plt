# Flexible Levy system in CAPRI
# =============================

# using the ncpcm smoothing function
ncpcm(x,y,z) = x - (z * log(1+exp((x-y)/z)))

# behaviour of ncpcm: for negative x the function gives back the x values
#            there's a 'smooth break' at zero
#             y defines the maximum
#             z defines the steepness (i.e. how smooth is the break), should be significantly smaller than the expected values of x


# levy = min[ tarspec,  max(0, minbordp - cif)]

# part 1.
#--------

# look at price differences
minbordp = 100
tc = 20

plot [75:120] -ncpcm(-(minbordp - (x+tc)),0,.1)
# this gives back a parameter which is zero when cif>minbordp, and equals to the difference when cif<minbordp

pause -1 

# part 2.
#-------------
# apply price difference to derive the applied tariff rate


tarspec = 25

# here x is the difference minbordp-cif (only if cif<minbordp)
plot [0:50] ncpcm(x,tarspec,.1)

# clearly you apply a variable tariff rate so cif=minbordp
# of course when cif falls below cif-tarspec you can not apply more than the maximum tariff rate (tarspec)


# Conclusions
#-------------


1. the system is driven by the price difference (v_flexLevyNotCut)
2. note that the system does not need to be calibrated! (no calibration parameters)
