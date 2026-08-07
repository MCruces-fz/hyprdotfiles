#!/usr/bin/shell

WORKSPACE=$HOME/src/spark/bluecoins
USER_SETTINGS=$HOME/src/spark/config_jupyter

docker run -it -p 8888:8888 \
	-v $WORKSPACE:/home/jovyan/work \
	-v $USER_SETTINGS:/home/jovyan/.jupyter/lab/user-settings \
	jupyter/pyspark-notebook
