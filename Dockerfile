FROM gato756/awt04webservice_1.0:1.0
WORKDIR /AWT04-WebService/
COPY build/libs/*.jar ./AWT04-WebService/
#ENTRYPOINT ["java","-jar","/AWT04-WebService/WebService-1.0-SNAPSHOT.jar"]