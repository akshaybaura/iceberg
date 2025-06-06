FROM python:3.9-bullseye

RUN apt-get -qq update && \
    apt-get -qq install -y --no-install-recommends \
      sudo \
      curl \
      vim \
      unzip \
      openjdk-11-jdk \
      build-essential \
      software-properties-common \
      ssh && \
    apt-get -qq clean && \
    rm -rf /var/lib/apt/lists/*

# Optional env variables
ENV SPARK_HOME=${SPARK_HOME:-"/opt/spark"}
ENV HADOOP_HOME=${HADOOP_HOME:-"/opt/hadoop"}
ENV PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.9.7-src.zip:$PYTHONPATH

RUN mkdir -p ${HADOOP_HOME} && mkdir -p ${SPARK_HOME} && mkdir -p /home/iceberg/spark-events
WORKDIR ${SPARK_HOME}

# Remember to also update `tests/conftest`'s spark setting
ENV SPARK_VERSION=3.5.4
ENV ICEBERG_SPARK_RUNTIME_VERSION=3.5_2.12
ENV ICEBERG_VERSION=1.9.0-SNAPSHOT
ENV PYICEBERG_VERSION=0.9.0

RUN curl --retry 5 -s -C - https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz -o spark-${SPARK_VERSION}-bin-hadoop3.tgz \
 && tar xzf spark-${SPARK_VERSION}-bin-hadoop3.tgz --directory /opt/spark --strip-components 1 \
 && rm -rf spark-${SPARK_VERSION}-bin-hadoop3.tgz

# Download iceberg spark runtime
RUN curl --retry 5 -s https://repository.apache.org/content/groups/snapshots/org/apache/iceberg/iceberg-spark-runtime-3.5_2.12/1.9.0-SNAPSHOT/iceberg-spark-runtime-3.5_2.12-1.9.0-20250409.001855-44.jar \
      -Lo /opt/spark/jars/iceberg-spark-runtime-${ICEBERG_SPARK_RUNTIME_VERSION}-${ICEBERG_VERSION}.jar


# Download AWS bundle
RUN curl --retry 5 -s https://repository.apache.org/content/groups/snapshots/org/apache/iceberg/iceberg-aws-bundle/1.9.0-SNAPSHOT/iceberg-aws-bundle-1.9.0-20250409.002731-88.jar \
      -Lo /opt/spark/jars/iceberg-aws-bundle-${ICEBERG_VERSION}.jar

COPY spark-defaults.conf /opt/spark/conf
ENV PATH="/opt/spark/sbin:/opt/spark/bin:${PATH}"

RUN chmod u+x /opt/spark/sbin/* && \
    chmod u+x /opt/spark/bin/*

RUN pip3 install -q ipython

RUN pip3 install "pyiceberg[s3fs,hive]==${PYICEBERG_VERSION}"
RUN pip3 install pyarrow

COPY entrypoint.sh .
RUN chmod +x ./entrypoint.sh

COPY provision.py .

RUN pip3 install notebook

ENTRYPOINT ["./entrypoint.sh"]
CMD ["notebook"] # ignored