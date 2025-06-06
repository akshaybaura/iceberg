# Start with Jupyter base image (Python 3.11)
FROM jupyter/base-notebook:python-3.11

USER root

# Install Java 11 and required tools
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk curl wget unzip && \
    ln -s /usr/lib/jvm/java-11-openjdk-* /usr/lib/jvm/java-11 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME and update PATH
ENV JAVA_HOME=/usr/lib/jvm/java-11
ENV PATH="$JAVA_HOME/bin:$PATH"

# Install Apache Spark 3.3.0 with Hadoop 3
ENV SPARK_VERSION=3.3.0
ENV HADOOP_VERSION=3
ENV SPARK_HOME=/opt/spark

RUN wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar -xzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /opt && \
    mv /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} $SPARK_HOME && \
    rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

ENV PATH="$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH"

# Install matching PySpark version
RUN pip install pyspark==3.3.0

# Set working directory and permissions
WORKDIR /home/jovyan/work
USER jovyan