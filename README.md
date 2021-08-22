# Kafka Docker Image
This is Kafka docker image based on azul/zulu-openjdk-alpine:13.0.6-13.37.21-jre-headless
- Kafka version 2.7.0
- Scala version 2.13
- glibc version 2.33-r0

## Build Steps
1. Clone from git repo
   ```
   git clone https://github.com/kcheung00/docker_kafka.git
   ```
2. Build the image
   ```
   docker build -t docker_kafka .
   ```
3. Exeecute the image in interactive mode
   ```
   docker run -it <Image ID> /bin/bash
   ```
4. Verify the image
   - Installed: wget, curl, docker, java
   
5. Tag the image
   ```
   docker tag <Image ID> kcheung00/docker_kafka:2.7.0
   ```
6. Upload to docker hub
   ```
   docker push kcheung00/docker_kafka:2.7.0
   ```