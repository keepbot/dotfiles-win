#!/usr/bin/env bash

# Tesing: format_time_diff_from_ns $(date +%s%N; sleep N)
format_time_diff_from_ns()
{
    # Colors:
    local  K="\033[0;30m"   # black
    local  R="\033[0;31m"   # red
    local  G="\033[0;32m"   # green
    local  Y="\033[0;33m"   # yellow
    local  B="\033[0;34m"   # blue
    local  M="\033[0;35m"   # magenta
    local  C="\033[0;36m"   # cyan
    local  W="\033[0;37m"   # white
    local GR="\033[0;090m"  # gray
    local BK="\033[1;30m"   # bolded black
    local BR="\033[1;31m"   # bolded red
    local BG="\033[1;32m"   # bolded green
    local BY="\033[1;33m"   # bolded yellow
    local BB="\033[1;34m"   # bolded blue
    local BM="\033[1;35m"   # bolded magenta
    local BC="\033[1;36m"   # bolded cyan
    local BW="\033[1;37m"   # bolded white
    local ZZ="\033[0m"      # Reset

    local _timestamp_start
    local _timestamp_stop
    local _out

    if [[ -z ${1} ]]
    then
        echo "Error: $0 - wrong arguments..."
        echo "Usage: $0 <timestamp_in_ns_before> [timestamp_in_ns_after]"
        return
        # Fallback to current time
        # _timestamp_start=$(date +%s%N)
    else
        _timestamp_start=$1
    fi

    if [[ -z ${2} ]]
    then
        # Fallback to current time
        _timestamp_stop=$(date +%s%N)
        # _timestamp_stop=${_timestamp_start}
    else
        _timestamp_stop=$2
    fi

    # local 1k=1000
    # local 1m=1000000

    local delta_ns=$((${_timestamp_stop} - ${_timestamp_start}))
    local ns=$(((${delta_ns} % 1000)))
    local us=$(((${delta_ns} / 1000) % 1000))
    local ms=$(((${delta_ns} / 1000000) % 1000))
    local  s=$(((${delta_ns} / 1000000000) % 60))
    local  m=$(((${delta_ns} / 60000000000) % 60))
    local  h=$(((${delta_ns} / 3600000000000)))

    # printf " start: ${_timestamp_start}ns\n stop: ${_timestamp_stop}ns\n"
    # printf "  delta: ${delta_ns} ns\n\
    # ${ns} ns\n    ${us} µs\n    ${ms} ms\n      ${s} s\n      ${m} m\n      ${h} h\n"
    # printf '%02d:%02d:%02d.%03d\n' ${h} ${m} ${s} ${ms}
    # printf '%02d:%02d:%02d\n' ${h} ${m} ${s}

    # Format:1 Always show around 3 digits of accuracy
    # if   ((h > 0));     then _out=${h}h${m}m
    # elif ((m > 0));     then _out=${m}m${s}s
    # elif ((s >= 10));   then _out=${s}.$((ms / 100))s
    # elif ((s > 0));     then _out=${s}.$(printf %03d $ms)s
    # elif ((ms >= 100)); then _out=${ms}ms
    # elif ((ms > 0));    then _out=${ms}.$((us / 100))ms
    # else _out=${us}us
    # fi


    # Format 2:
    # elif ((s > 0));     then _out=$(printf "${BY}%ds${ZZ}"            ${s}             )
    # elif ((ms > 0));    then _out=$(printf "${BC}%dms${ZZ}"           ${ms}            )

    if   ((m  >    0))
    then
        _out=$(printf "${BR}%02d:%02d:%02d${ZZ}" ${h}   ${m} ${s} )
    elif ((s  >=   5))
    then
        _out=$(printf "${BY}%d.%03ds${ZZ}"       ${s}  ${ms}      )
    elif ((s  >    0))
    then
        _out=$(printf "${BC}%d.%03ds${ZZ}"       ${s}  ${ms}      )
    elif ((ms >= 100))
    then
        _out=$(printf "${BC}%dms${ZZ}"           ${ms}            )
    elif ((ms >    0))
    then
        _out=$(printf "${BC}%d.%03dms${ZZ}"      ${ms} ${us}      )
    elif ((us >    0))
    then
        _out=$(printf "${GR}%dµs${ZZ}"           ${us}            )
    else
        _out=$(printf "${GR}%dns${ZZ}"           ${ns}            )
    fi

    printf "$_out"
}

format_time_from_ns()
{
    if [[ -z ${1} ]]
    then
        echo "Usage: $0 <timestamp_in_nanoseconds>"
        return
    fi

    local _timestamp=$1
    local _out

    local ns=$(((${_timestamp} % 1000)))
    local us=$(((${_timestamp} / 1000) % 1000))
    local ms=$(((${_timestamp} / 1000000) % 1000))
    local  s=$(((${_timestamp} / 1000000000) % 60))
    local  m=$(((${_timestamp} / 60000000000) % 60))
    local  h=$(((${_timestamp} / 3600000000000)))

    if   ((h  >    0))
    then
        _out=$(printf "%02d:%02d:%02d"  ${h}  ${m} ${s} )
    elif ((m  >    0))
    then
        _out=$(printf "%dm%ds"          ${m}  ${s}      )
    elif ((s  >    0))
    then
        _out=$(printf "%d.%03ds"        ${s} ${ms}      )
    elif ((ms >= 100))
    then
        _out=$(printf "%dms"           ${ms}            )
    elif ((ms >    0))
    then
        _out=$(printf "%d.%03dms"      ${ms} ${us}      )
    elif ((us >    0))
    then
        _out=$(printf "%dµs"           ${us}            )
    else
        _out=$(printf "%dns"           ${ns}            )
    fi

    printf "${_out}"
}

function timer_now
{
    date +%s%N
}

function timer_start
{
    # preserve exit status
    local exit=$?

    # do nothing if completing
    [ -n "$COMP_LINE" ] && return

    # don't cause a preexec for $PROMPT_COMMAND
    [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return

    unset timer_output
    timer_start_timestamp=${timer_start_timestamp:-$(timer_now)}

    return $exit
}

function timer_stop
{
    # preserve exit status
    local exit=$?

    timer_stop_timestamp=$(timer_now)
    timer_output=${timer_output:-$(format_time_diff_from_ns $timer_start_timestamp $timer_stop_timestamp)}

    if [ ! -z ${timer_start_timestamp} ] && [ ! -z ${timer_stop_timestamp} ]
    then
        timer_elapsed=$(((${timer_stop_timestamp} - ${timer_start_timestamp})))
    fi

    # Cleanup timer
    unset timer_stop_timestamp
    unset timer_start_timestamp

    return $exit
}

function timer_get_elapsed()
{
    if [[ -z ${1} ]]
    then
        printf ${timer_elapsed}
    elif [[ '-v' == ${1} ]]
    then
        format_time_from_ns ${timer_elapsed}
        printf '\n'
    else
        echo "Usase"
        echo "  timer_get_elapsed    | without arguments prints elapsed timestamp in nanoseconds"
        echo "  timer_get_elapsed -v | with '-v' argument prints elapsed timestamp in human readable format"
        echo
    fi
}
