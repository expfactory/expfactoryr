#!/bin/bash

function usage() {
    echo "Usage: /run.sh <command> <args>"
}

function check_return_value() {
    RETVAL=${1}
    if [ "${RETVAL}" -ne 0 ]
        then
            exit ${RETVAL}
    fi
}

if [ "$#" -eq 0 ]
    then
    usage
    exit 1
fi

while true; do
    case ${1:-} in
        -h|--help|help)
            usage
            exit
        ;;
        test|--test)
            shift
            EXPFACTORY_PACKAGE=${1:-/data} 
            export EXPFACTORY_PACKAGE

            # The directory must exist, and be a directory
            echo "Found ${EXPFACTORY_PACKAGE}"
            ls
            cd "${EXPFACTORY_PACKAGE}"
            R -e 'devtools::install_deps(dependencies=TRUE)'
            check_return_value $?
            R -e 'devtools::check()'
            check_return_value $?
            R -e 'devtools::test()'
            check_return_value $?
            exit 0
        ;;
        -*)
            echo "Unknown option: ${1:-}"
            exit 1
        ;;
        *)
            break
        ;;
    esac
done
