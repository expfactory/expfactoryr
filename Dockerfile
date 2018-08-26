FROM rocker/tidyverse
# docker build -t expfactory/expfactoryr .
ENV DEBIAN_FRONTEND noninteractive
RUN mkdir -p /code /data
COPY . /code
RUN mkdir -p /code
LABEL maintainer vsochat@stanford.edu
ADD . /code
WORKDIR /code
RUN apt-get update && apt-get install -y texinfo texlive-fonts-extra links2 && \
    R -e "devtools::install_local('/code', quiet=FALSE, dependencies=TRUE)" && \
    chmod u+x /code/docker/run.sh && \
    echo "Running devtools checks and tests for expfactoryr" && \
    R -e 'devtools::check()' && \
    R -e 'devtools::test()'

# To test, the user will mount to /data
WORKDIR /data
ENTRYPOINT ["/bin/bash", "/code/docker/run.sh"]
