#!/bin/bash

function usage() {
    echo "Usage: /run.sh <command> <args>"
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
            R -e 'devtools::check()'
            R -e 'devtools::test()'
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
