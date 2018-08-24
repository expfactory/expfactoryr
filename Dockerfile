FROM rocker/tidyverse
# docker build -t expfactory/expfactoryr .
RUN mkdir -p /code
LABEL maintainer vsochat@stanford.edu
ADD . /code
WORKDIR /code
RUN R -e "devtools::install_local('/code')" && \
            echo "Running devtools checks and tests for expfactoryr" && \
            R -e 'devtools::check()' && \
            R -e 'devtools::test()'
