FROM jupyter/datascience-notebook
# https://github.com/jupyter/docker-stacks/blob/master/datascience-notebook/Dockerfile

USER root
RUN apt-get update && apt-get install -y git
RUN mkdir -p /code /data
COPY . /code

# Install expfactory-r into container package
RUN R -e "devtools::install_local('/code', quiet=FALSE)"

# To test, the user will mount to /code
WORKDIR /code
ENTRYPOINT ["/bin/bash", "/code/docker/run.sh"]
