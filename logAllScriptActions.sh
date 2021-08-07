#!/bin/bash

# some basic initialization steps including `NEST_LVL` and `SCRIPTS_LOGS_ROOT variables...
source ".../__myinit__.sh"

# no local logging if nested call
((!IMPL_MODE && !NEST_LVL)) && {
	export IMPL_MODE=1
	exec 3>&1 4>&2
	trap 'exec 2>&4 1>&3' EXIT HUP INT QUIT RETURN

	[[ ! -e "${SCRIPTS_LOGS_ROOT}/.log" ]] && mkdir "${SCRIPTS_LOGS_ROOT}/.log"

	# RANDOM instead of milliseconds
	case $BASH_VERSION in
	# < 4.2
	[123].* | 4.[01] | 4.0* | 4.1[^0-9]*)
		LOG_FILE_NAME_SUFFIX=$(date "+%Y'%m'%d_%H'%M'%S''")$((RANDOM % 1000))
		;;
	# >= 4.2
	*)
		printf -v LOG_FILE_NAME_SUFFIX "%(%Y'%m'%d_%H'%M'%S'')T$((RANDOM % 1000))" -1
		;;
	esac

	( 
		(
			myfoo1
			#...
			myfooN

			# self script reentrance...
			exec $0 "$@"
		) | tee -a "${SCRIPTS_LOGS_ROOT}/.log/${LOG_FILE_NAME_SUFFIX}.myscript.log" 2>&1
	) 1>&3 2>&4

	exit $?
}

((NEST_LVL++))

# usual script body goes here...
