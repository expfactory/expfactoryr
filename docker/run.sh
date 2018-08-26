#!/bin/bash

function usage() {
    echo "Usage: /run.sh <command> <args>
          /run.sh test <folder>"
}

if [ "$#" -eq 0 ]
    then
    usage
    exit 1
fi

retval=0

while true; do
    case ${1:-} in
        -h|--help|help)
            usage
            exit ${retval}
        ;;
        test|--test)
            shift
            EXPFACTORY_PACKAGE=${1:-/data} 
            export EXPFACTORY_PACKAGE
            echo "Package folder ${EXPFACTORY_PACKAGE}"
            ls
            cd "${EXPFACTORY_PACKAGE}"
            echo "devtools::install_deps(dependencies=TRUE)"
            R -e 'devtools::install_deps(dependencies=TRUE)'
            # These commands don't return the correct codes, but display better
            echo "devtools::check()"
            R -e 'devtools::test()'
            # This will return a proper code
            echo "R CMD check ${EXPFACTORY_PACKAGE}"
            R CMD check "${EXPFACTORY_PACKAGE}"
            retval=$?
            exit $retval;
        ;;
        -*)
            echo "Unknown option: ${1:-}"
            retval=1
        ;;
        *)
            break
        ;;
    esac
done

exit ${retval}
