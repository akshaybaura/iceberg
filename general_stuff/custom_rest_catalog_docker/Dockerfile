FROM openjdk:11-jdk-slim

# Install necessary packages
RUN apt-get update && apt-get install -y git curl unzip && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Clone Iceberg repository
RUN git clone --depth 1 --branch apache-iceberg-1.5.0 https://github.com/apache/iceberg.git

# Build the REST server
WORKDIR /app/iceberg
RUN ./gradlew :iceberg-rest:jetty:shadowJar

# Copy the built JAR to a known location
RUN cp iceberg-rest/jetty/build/libs/iceberg-rest-jetty-all.jar /app/iceberg-rest-jetty-all.jar

# Download necessary Hadoop AWS and AWS SDK JARs for S3/MinIO integration
WORKDIR /app/resources/lib
RUN curl -O https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.1/hadoop-aws-3.3.1.jar
RUN curl -O https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.1026/aws-java-sdk-bundle-1.11.1026.jar

# Set environment variables for MinIO
ENV AWS_ACCESS_KEY_ID=admin
ENV AWS_SECRET_ACCESS_KEY=password
ENV CATALOG__WAREHOUSE=s3a://warehouse
ENV CATALOG__IO__IMPL=org.apache.iceberg.aws.s3.S3FileIO
ENV CATALOG__S3__ENDPOINT=http://minio:9000
ENV CATALOG__S3__PATH_STYLE_ACCESS=true

# Expose REST server port
EXPOSE 8181

# Set entrypoint
CMD ["java", "-cp", "/app/iceberg-rest-jetty-all.jar:/app/resources/lib/*", "org.apache.iceberg.rest.RESTCatalogServer", "server", "/config/rest-catalog.conf"]
