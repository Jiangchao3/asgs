#!/bin/sh
#-------------------------------------------------------------------
# config.sh: 
# This file is read at the beginning of the execution of the ASGS to set up the
# runs  that follow. It is reread at the beginning of every cycle, every time
# it polls the datasource for a new advisory. This gives the user the
# opportunity to edit this file mid-storm to change config parameters (e.g.,
# the name of the queue to submit to, the addresses on the mailing list, etc)
#-------------------------------------------------------------------
#
# Copyright(C) 2006, 2007 Brett Estrade
# Copyright(C) 2006, 2007, 2008, 2009 Jason Fleming
#
# This file is part of the ADCIRC Surge Guidance System (ASGS).
#
# The ASGS is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ASGS is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with the ASGS.  If not, see <http://www.gnu.org/licenses/>.
#-------------------------------------------------------------------
#
#-------------------------------------------------------------------
# General configuration 
#-------------------------------------------------------------------
STORM=01             # storm number, e.g. 05=ernesto in 2006
YEAR=2009            # year of the storm (useful for historical storms)
COLDSTARTDATE="2008091000" # date corresponding to simulation coldstart
HOTORCOLD=coldstart  # "hotstart" or "coldstart"
LASTSUBDIR=          # if hotstarting, the subdir to get the hs file from
ADCIRCDIR=~/asgs2009/bin    # dir containing the ADCIRC executables
INPUTDIR=~/asgs2009/input   # dir containing grid and other input files 
OUTPUTDIR=~/asgs2009/output # dir containing post processing scripts
PERL5LIB=~/asgs2009/PERL    # dir with DateCale.pm perl module
NCPU=1000            # number of CPUs to use for all simulations
#
#-------------------------------------------------------------------
# Platform-related configuration
#-------------------------------------------------------------------
QUEUENAME=standard # for ERDC machines, non-emergency queue
#QUEUENAME=nbatch  # for ERDC machines, this is emergency queue name
#QUEUENAME=512cpu  # for UNC (topsail); can also use 128cpu or 32cpu
#QUEUENAME=workq   # for LSU (queenbee); non-emergency
#QUEUENAME=priority # for LSU (queenbee); emergency queue name
#QUEUENAME=desktop  # for workstations with no queue
#
#-------------------------------------------------------------------
# Input configuration
#-------------------------------------------------------------------
#FTPSITE=ftp.nhc.noaa.gov  # real anon ftp site for hindcast/forecast files 
#FDIR=/atcf/afst     # forecast dir on nhc ftp site
#HDIR=/atcf/btk      # hindcast dir on nhc ftp site
#  the following are used at UNC for test storms
FTPSITE=ftp.unc.edu
FDIR=/pub/ims/rick/ADCIRC/NHC_Advisories/fst # forecast dir on test site
HDIR=/pub/ims/rick/ADCIRC/NHC_Advisories/btk # hindcast dir on test site
#
# we will implement automation of the correct advisory number in a later
# release ... for now, we simply increment
STARTADVISORYNUM=1  # the starting advisory number
# 
# It is assumed that the following files are in the INPUTDIR defined above
#
# file that contains the mesh (fort.14)
GRIDFILE=sl15v3_2007_r10.grd
# file that acts as a template for the control file (fort.15)
CONTROLTEMPLATE=fort.15.sl15.corps.template
# nodal attributes file (fort.13)
NAFILE=sl15v3_2007_r09f.13
# archive of the fort.14 and fort.13 that have already been preprocessed
# for a certain number of CPUs (include the num of CPUs in the file name)
PREPPEDARCHIVE=prepped_sl15_corps_1000.tar.gz
# 
# size of the time step to use
TIMESTEPSIZE=1.0
#
# estimated wall clock time for queueing systems that require an
# estimate; must be set small when sending test problems to the debug queue;
# for production, must be set large enough for any run, including initial
# hindcast run, which may be longer than 5 days in some cases
WALLTIME="4:00:00"
#
#-------------------------------------------------------------------
# Storm ensemble configuration 
#-------------------------------------------------------------------
# 
# Vortex wind model configuration, used on the NWS line in ADCIRC;
# NWS=8: symmetric vortex, NWS=9: asymmetric vortex
# (only NWS=9 is currently supported)
NWS=9
#
ENSEMBLESIZE=1 # number of storms in the ensemble
#
# array of storm names that are to be run ... array length is ENSEMBLESIZE
STORMLIST[0]=1 # NHC consensus forecast  
#
NAME[0]="nowcast"
NAME[1]="nhcConsensus"
NAME[2]="higherMaxWindSpeed"
NAME[3]="slowerOverlandSpeed"
NAME[4]="veerRight"
NAME[5]="veerLeft"
NAME[6]="largerRmax"
NAME[7]="smallerRmax"
NAME[8]="" # fill in the blank for custom variation
#
PERCENT=
#
# The end time is used to cut the simulation off after a certain point, 
# e.g., if it has gone too far inland to be of interest
#ENDTIME=2008090200
#
#-------------------------------------------------------------------
# Notification configuration 
#-------------------------------------------------------------------
EMAILNOTIFY=NO # set to yes to have host platform email notifications
# the following list of addresses will receive an announcement when
# the ASGS is activated for a particular storm (some end users consider
# this to be junk mail)
ACTIVATE_LIST="jsn_flmng@yahoo.com jgflemin@email.unc.edu"
# addresses to receive notification that a new advisory is now running
NEW_ADVISORY_LIST="jsn_flmng@yahoo.com jgflemin@email.unc.edu"
# addresses to receive notification that new results are now available
RESULTS_LIST="jsn_flmng@yahoo.com jgflemin@email.unc.edu"
# this is the email address in the PBS job script
NOTIFYUSER=jgflemin@email.unc.edu
#
#-------------------------------------------------------------------
# Output configuration 
#-------------------------------------------------------------------
#
# It is assumed that these files are located in the asgs2009 directory
# in the "output" subdir
#
# this is the script that sets up post processing for each advisory, 
# before the run happens
INITPOST=post_init.sh
# this is the name of the post processing script
POSTPROCESS=corps_post.sh
# these are the output files that should be transmitted to another
# machine BY THE WORKFLOW (as opposed to the post processing script)
NUMOUTFILES=1
POSTFILE[0]=results.tar.gz
# the machine(s) to which result file(s) should be transferred
RESULTSHOST[0]=dove.he.net
RESULTSUSER[0]=seahrse
RESULTSPATH[0]=/home/seahrse/public_html/ASGS