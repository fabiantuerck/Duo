goal:   duo.x

tarball:
	tar cf duo.tar makefile *.f90

checkin:
	ci -l Makefile *.f90

PLAT = _0506

FOR  = gfortran

FFLAGS = -W -Wall -fbounds-check -std=f2003 -Wunderflow -O -fbacktrace -ffpe-trap=zero,overflow,underflow -g -ffixed-line-length-none  #Debug options for gfortran
#FFLAGS = -std=f2003 -O2 -march=native #Production options for gfortran
FFLAGS =  -ffixed-line-length-none -ffree-line-length-none -fbounds-check -std=f2003  -O3

LAPACK = -llapack -L/usr/lib/lapack -lblas -L/usr/lib/libblas

LIB     =   $(LAPACK)

###############################################################################

OBJ = atomic_and_nuclear_data.o grids.o accuracy.o lapack.o timer.o input.o diatom.o refinement.o functions.o  symmetry.o dipole.o header_info.o
#compilation_details.o

duo.x:	$(OBJ) duo.o
	$(FOR) -o j-duo$(PLAT).x $(OBJ) $(FFLAGS) duo.o $(LIB)

duo.o:	duo.f90 $(OBJ)
	$(FOR) -c duo.f90 $(FFLAGS)

grids.o:	grids.f90 accuracy.o input.o
	$(FOR) -c grids.f90 $(FFLAGS)

diatom.o:	diatom.f90 accuracy.o input.o lapack.o functions.o symmetry.o atomic_and_nuclear_data.o
	$(FOR) -c diatom.f90 $(FFLAGS)

refinement.o:	refinement.f90 accuracy.o input.o lapack.o diatom.o
	$(FOR) -c refinement.f90 $(FFLAGS)

functions.o:	functions.f90 accuracy.o input.o lapack.o
	$(FOR) -c functions.f90 $(FFLAGS)

dipole.o:	dipole.f90 accuracy.o input.o lapack.o diatom.o
	$(FOR) -c dipole.f90 $(FFLAGS)

accuracy.o:  accuracy.f90
	$(FOR) -c accuracy.f90 $(FFLAGS)

symmetry.o:  symmetry.f90
	$(FOR) -c symmetry.f90 $(FFLAGS)

lapack.o:  lapack.f90 accuracy.o timer.o
	$(FOR) -c lapack.f90 $(FFLAGS)

timer.o:  timer.f90
	$(FOR) -c timer.f90 $(FFLAGS)

input.o:  input.f90
	$(FOR) -c input.f90 $(FFLAGS)

#compilation_details.o: compilation_details.f90
#	$(FOR) -c compilation_details.f90 $(FFLAGS)

header_info.o:  accuracy.o
	$(FOR) -c header_info.f90 $(FFLAGS)

atomic_and_nuclear_data.o:  atomic_and_nuclear_data.f90
	$(FOR) -c atomic_and_nuclear_data.f90 $(FFLAGS)

clean:
	rm -f $(OBJ) *.mod *__genmod.f90 duo.o
