FROM jupyter/datascience-notebook
# https://github.com/jupyter/docker-stacks/blob/master/datascience-notebook/Dockerfile

USER root
RUN apt-get update && apt-get install -y git
RUN mkdir -p /code /data
COPY . /code

# Install expfactory-r into container package
RUN ln -s /bin/tar /bin/gtar && \
    R -e "devtools::install_local('/code', quiet=FALSE, dependencies=TRUE)" && \
    chmod u+x /code/docker/run.sh

# To test, the user will mount to /code
WORKDIR /data
ENTRYPOINT ["/bin/bash", "/code/docker/run.sh"]
