#!/bin/bash
start-master.sh -p 7077
start-worker.sh spark://spark-iceberg:7077
start-history-server.sh

jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root --NotebookApp.token=''

tail -f /dev/null