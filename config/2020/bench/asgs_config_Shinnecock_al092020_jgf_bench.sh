#!/bin/sh
#-------------------------------------------------------------------
# config.sh: This file is read at the beginning of the execution of the ASGS to
# set up the runs  that follow. It is reread at the beginning of every cycle,
# every time it polls the datasource for a new advisory. This gives the user
# the opportunity to edit this file mid-storm to change config parameters
# (e.g., the name of the queue to submit to, the addresses on the mailing list,
# etc)
#-------------------------------------------------------------------
#
# Copyright(C) 2018--2020 Jason Fleming
#
# This file is part of the ADCIRC Surge Guidance System (ASGS).
#
# The ASGS is free software: you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# ASGS is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# the ASGS.  If not, see <http://www.gnu.org/licenses/>.
#-------------------------------------------------------------------
# The defaults for parameters that can be reset in this config file 
# are preset in the following scripts:
# {SCRIPTDIR/platforms.sh               # also contains Operator-specific info
# {SCRIPTDIR/config/config_defaults.sh
# {SCRIPTDIR/config/mesh_defaults.sh
# {SCRIPTDIR/config/forcing_defaults.sh
# {SCRIPTDIR/config/io_defaults.sh
# {SCRIPTDIR/config/operator_defaults.sh
#-------------------------------------------------------------------

# Fundamental

INSTANCENAME=Shinnecock_al092020_jgf_bench  # "name" of this ASGS process

# Input files and templates

GRIDNAME=Shinnecock
source $SCRIPTDIR/config/mesh_defaults.sh

# Physical forcing (defaults set in config/forcing_defaults)

TIDEFAC=on            # tide factor recalc
HINDCASTLENGTH=5.0    # duration of tidal spinup, from cold (days)
BACKGROUNDMET=off      # NAM download/forcing
   FORECASTCYCLE="18"
TROPICALCYCLONE=on   # tropical cyclone forcing
   STORM=09           # storm number, e.g. 05=ernesto in 2006
   YEAR=2020          # year of the storm
   TRIGGER=atcf
   RSSSITE=filesystem
   FTPSITE=filesystem
   FDIR=$SCRIPTDIR/input/sample_advisories/2020 
   HDIR=${FDIR}
   PSEUDOSTORM=no
WAVES=off              # wave forcing
#STATICOFFSET=0.1524
REINITIALIZESWAN=no   # used to bounce the wave solution
VARFLUX=off           # variable river flux forcing
CYCLETIMELIMIT="99:00:00"

# Computational Resources (related defaults set in platforms.sh)

NCPU=2                    # number of compute CPUs for all simulations
NUMWRITERS=1
NCPUCAPACITY=oneJobAtATime

# Post processing and publication

INTENDEDAUDIENCE=general    # can also be "developers-only" or "professional"
#POSTPROCESS=( createMaxCSV.sh cpra_slide_deck_post.sh includeWind10m.sh createOPeNDAPFileList.sh opendap_post.sh )
POSTPROCESS=(  )
#OPENDAPNOTIFY="asgs.cera.lsu@gmail.com,jason.g.fleming@gmail.com,mbilsk3@lsu.edu,shagen@lsu.edu,jikeda@lsu.edu,fsanti1@lsu.edu,rluettich1@gmail.com"
OPENDAPNOTIFY="jason.g.fleming@gmail.com"
TDS=( )
RMQMessaging_Enable="off"      # "on"|"off"
RMQMessaging_Transmit="off"    #  enables message transmission ("on" | "off")

# Initial state (overridden by STATEFILE after ASGS gets going)

COLDSTARTDATE=2020072800
HOTORCOLD=hotstart      # "hotstart" or "coldstart"
LASTSUBDIR=/scratch/asgs896/initialize

# Scenario package 

#PERCENT=default
SCENARIOPACKAGESIZE=6 # number of scenarios to run (may be smaller than the number defined below)
case $si in
 -2)
   ENSTORM=hindcast
   ;;
-1)
   # do nothing ... this is not a forecast
   ENSTORM=nowcast
   ;;
 0)
   ENSTORM=nhcConsensusNCPU31
   NCPU=31
   ;; 
 1)
   ENSTORM=nhcConsensusNCPU16
   NCPU=16
   ;;
 2)
   ENSTORM=nhcConsensusNCPU8
   NCPU=8
   ;;
 3)
   ENSTORM=nhcConsensusNCPU4
   NCPU=4
   ;;     
 4)
   ENSTORM=nhcConsensusNCPU2
   NCPU=2
   ;;
 5)
   ENSTORM=nhcConsensusNCPU1
   NCPU=1
   NUMWRITERS=0
   ;;        
*)
   echo "CONFIGRATION ERROR: Unknown scenario number: '$si'."
   ;;
esac

PREPPEDARCHIVE=prepped_${GRIDNAME}_${INSTANCENAME}_${NCPU}.tar.gz
HINDCASTARCHIVE=prepped_${GRIDNAME}_hc_${INSTANCENAME}_${NCPU}.tar.gz
