OBJ= \
	R013-stn2model \
	R013-convert

COPT=-O0 -Wall -Wextra 
FOPT=-O0 -Wall -fcheck=all
LD=/usr/bin/ld
#-fbounds-check 

all: $(OBJ)

R013-stn2model: R013-stn2model.cpp
	g++ $(COPT) R013-stn2model.cpp -o R013-stn2model

R013-convert: R013-convert.f90
	gfortran $(FOPT) R013-convert.f90 -o R013-convert
#
clean:
	-rm -f R013-convert R013-stn2model
#
