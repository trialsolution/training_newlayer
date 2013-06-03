# ncpcm smoothing function
# ========================


ncpcm(x,y,z) = x - (z * log(1+exp((x-y)/z)))

# behaviour: for negative x the function gives back the x values
#            there's a 'smooth break' at zero
#             y defines the maximum
#             z defines the steepness (i.e. how smooth is the break), should be significantly smaller than the expected values of x

# let's plot the TRQImports_ equation in a case where the TRQ~100 => z=.1, x=0
plot ncpcm(x,0,.1)

# Let's do a SA for the z parameter
 plot [-10:10] ncpcm(x,0,.10),\
 ncpcm(x,0,1),\
 ncpcm(x,0,2),\
 ncpcm(x,0,3)
  