# ----------------------------------------------------------------------
# Config file for GFortran
# ----------------------------------------------------------------------

# ------- Define a possible parallel make ------------------------------
PMAKE = make -j 4

# ------- Define the MPI Compilers--------------------------------------
FF90 = mpifort
CC   = mpicc

# ----------- CGNS ------------------
CGNS_INCLUDE_FLAGS=-I$(CGNS_HOME)/include
CGNS_LINKER_FLAGS=-L$(CGNS_HOME)/lib -lcgns

# ------- Define Compiler Flags ----------------------------------------
FF90_GEN_FLAGS = -fPIC -g -fbounds-check
CC_GEN_FLAGS   = -fPIC

FF90_OPT_FLAGS   = -fPIC -fdefault-real-8 -O2 -fdefault-double-8
CC_OPT_FLAGS     = -O2

# ------- Define Archiver  and Flags -----------------------------------
AR       = ar
AR_FLAGS = -rvs

# ------- Define Linker Flags ------------------------------------------
LINKER_FLAGS = 

# Define potentially different python, python-config and f2py executables:
PYTHON = python
PYTHON-CONFIG = python3-config
F2PY = f2py
