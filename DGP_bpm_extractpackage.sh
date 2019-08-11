#!/bin/ksh
#============================================================================================================
#Subversion Info
#============================================================================================================
# $HeadURL: url
# $Revision: 164032 $
# $Author: SaiManam $
# $Date: 2015-02-23 07:04:10 -0500 (Mon, 23 Feb 2015) $
trap 'self_log "F" "CNTL/c OS signal trapped, Script ${G_SCRIPTNAME} terminated"; exit 1' 2
trap 'self_log "F" "Kill Job Event Sent from the console, Script ${G_SCRIPTNAME} terminated"; exit 1' 15

#-----------------------------------------------------------------------------------------------------
#   Function Name: Usage
#   Input: None
#   Return Value: Example of required Input Parameters
#   Description: Displays example of required input parameters for DGP_services_startup.sh to execute.
#-----------------------------------------------------------------------------------------------------

Usage () {
    echo ""
    echo "Usage: 'basename $0' -f [<path>/ssi]"
    echo ""
    exit 1
}

self_log ()
{
    C_logmsg $1 "$2"
    echo $1 "$2"
}

#-----------------------------------------------------------------------------------------------------
#   Main
#-----------------------------------------------------------------------------------------------------

#   Source in common includes file  #
#########################################
G_SCRIPTNAME=$(basename $0)

#-----------------------------------------------------------------------------------------------------
#   Check and retrieve parameters
#-----------------------------------------------------------------------------------------------------

while getopts f: option
do 
    case $option in 
                    f) SSI_FILE=$OPTARG;;
                    *) Usage;;
    esac
done

#-----------------------------------------------------------------------------------------------------
#   Validate SSI File
#-----------------------------------------------------------------------------------------------------

if [[ -z ${SSI_FILE} ]]; then
        echo "ERROR: SSI File is required"
        echo " "
    Usage
fi
if [[ -z ${SSI_FILE} ]]; then
        echo "SSI file ${SSI_FILE} does not exist. Exiting Script."
        exit 1
fi

set -a
    .${SSI_FILE}
set +a

if [ ! -e ${G_LOGDIR} ]; then
    mkdir -p ${G_LOGDIR}
fi

export FPATH=/opt/local/shr/bin
#call common environment functions
.${FPATH}/C_common_functions
C_set_sys_level
C_set_common_env

#-----------------------------------------------------------------------------------------------------
#   Validate Input
#-----------------------------------------------------------------------------------------------------
self_log STARTED
self_log I "Begin Startup of Service Tier by ${USER}"

#Start up Services:
if [[ "${AS_HOSTNAME}" == "${DM_HOSTNAME}" ]]; then
    PRC=$(ps -ef | grep "dmgr" | grep -v grep)
    if [ -z ${PRC} ]; then
        if [[ -x ${WAS_BASEPATH}/bin/startManager.sh ]]; then
            self_log I "Starting Up DeploymentManager"
            ${WAS_BASEPATH}/bin/startManager.sh
            if [ $? != 0]; then
                self_log F "${WAS_BASEPATH}/bin/startManager.sh failed. exiting...."
                exit 1
            fi
        else
            self_log F "Cannot execute ${WAS_BASEPATH}/bin/startManager.sh script. Check Permissions of file. exiting...."
            exit 1
        fi
    else
        self_log I "dmgr app server already started."
    fi
fi

PRC=$(ps -ef | grep "nodeagent" | grep -v grep)
if [ -z ${PRC} ]; then
    if [[ -x ${WAS_BASEPATH}/bin/startNode.sh ]]; then
        self_log I "Starting Node"
        ${WAS_BASEPATH}/bin/startNode.sh
        if [ $? != 0 ] then 
            self_log F "${WAS_BASEPATH}/bin/startNode.sh Failed. exiting....... "
            exit 1
        fi
    else
        self_log F "Cannot execute ${WAS_BASEPATH}/bin/startNode.sh script. Check permissions of file. exiting..... "
        exit 1
    fi
else
    self_log I "nodeagent already started"
fi

if [[ "${AS_HOSTNAME}" == "${DM_HOSTNAME}" ]]; then
# start appserver on DMGR box
    PRC=$(ps -ef |grep "${APP_SERVER}" | grep -v grep)
    if [ -z ${PRC} ]; then
        if [[ -x ${WAS_BASEPATH}/bin/startServer.sh ]]; then
            self_log I "Starting Up Server"
            ${WAS_BASEPATH}/bin/startServer.sh ${APP_SERVER}
            if [ $? != 0 ]; then
                self_log F "${WAS_PROFILEPATH}/bin/startServer.sh ${APP_SERVER} failed. exiting..... "
                exit 1
            fi
        else
            self_log F "Cannot execute ${WAS_PROFILEPATH}/bin/startServer.sh ${APP_SERVER} script. Check permissions of file. exiting..... "
            exit 1
        fi
    else
        self_log I "${APP_SERVER} already started."
    fi
fi

self_log I "Removing log files from ${G_LOGDIR} that are more than ${G_LOG_DAYS} day(s) old."

find ${G_LOGDIR} -name "${G_SCRIPTNAME}.*" -mtime +${G_LOG_DAYS} -exec rm -f {} \;
if [[ $? != 0 ]]; then
    self_log I "Unable to remove logs and files more than ${G_LOG_DAYS} days(s) old."
fi

self_log I "Completed execution of ${G_SCRIPTNAME}.......@'date +%Y%m%d_%H:%M:%S'"
self_log FINISHED



