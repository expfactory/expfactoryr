#!/bin/bash

if [ "$#" -ne 1 ];
    then
    echo "Usage: /install.sh <expfactory-package-folder>"
fi

# The directory must exist, and be a directory
if [ ! -d "${EXPFACTORY_PACKAGE}" ]
    then
    echo "Cannot find ${EXPFACTORY_PACKAGE}"
    exit 1
fi


EXPFACTORY_PACKAGE="${1}"

echo "Found ${EXPFACTORY_PACKAGE}"
ls
cd "${EXPFACTORY_PACKAGE}"
R -e 'devtools::install_deps(dependencies = TRUE)'
R -e 'devtools::check()'
R -e 'devtools::test()'
