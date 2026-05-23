FROM alpine/git AS git-clone
WORKDIR /app
RUN git clone https://github.com/krishnadevopstraining-tech/simple-java-application.git

FROM maven:amazoncorretto AS build
WORKDIR /app
COPY --from=git-clone /app/simple-java-application .
RUN mvn package

FROM amazoncorretto:17
WORKDIR /app
COPY --from=build /app/target/krishna-devops-training-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
