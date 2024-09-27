### FROM registry.access.redhat.com/ubi8:latest
FROM registry.redhat.io/jboss-eap-7/eap74-openjdk8-openshift-rhel8:7.4.18

# Create a system user and group for jboss, they both have a UID and GID of 1100
# Set the jboss user's home directory to /opt/jboss
### RUN groupadd -r -g 1100 jboss && useradd -u 1100 -r -m -g jboss -d /opt/jboss -s /sbin/nologin jboss

# Set the environment variable JBOSS_HOME to /opt/jboss/jboss-eap-7.4.0
### ENV JBOSS_HOME="/opt/jboss/jboss7.4/jboss-eap-7.4.0"
ENV JBOSS_HOME="/opt/eap"

### Agregar directorio para configuraciones especificas de ProceSAR
#RUN mkdir /opt/eap/cfg

### Add java opts parameters
#ENV JAVA_OPTS="-javaagent:'/opt/eap/jboss-modules.jar' -server -Xlog:gc*:file='/opt/eap/standalone/log/gc.log':time,uptimemillis:filecount=5,filesize=3M -Xms128m -Xmx512m -XX:MetaspaceSize=96m -Djava.net.preferIPv4Stack=true -Djboss.modules.system.pkgs=jdk.nashorn.api -Djava.awt.headless=true -XX:+UseParallelOldGC -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=20 -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -XX:ParallelGCThreads=1 -Djava.util.concurrent.ForkJoinPool.common.parallelism=1 -XX:CICompilerCount=2 -XX:+ExitOnOutOfMemoryError -Djava.security.egd=file:/dev/./urandom --add-exports=java.base/sun.nio.ch=ALL-UNNAMED --add-exports=jdk.unsupported/sun.misc=ALL-UNNAMED --add-exports=jdk.unsupported/sun.reflect=ALL-UNNAMED -Dmx.com.procesar.configuracion.properties='$JBOSS_HOME/cfg'"

# Set the working directory to jboss' user home directory
# WORKDIR /opt/jboss/jboss7.4/jboss-eap-7.4.0/
#WORKDIR /opt/eap/standalone/

# Unpack the jboss-eap-7.4.0.zip file to the /opt/jboss directory
#ADD ./jboss-eap-7.4.0.zip /opt/jboss
#RUN unzip /opt/jboss/jboss-eap-7.4.0.zip

# Recursively change the ownership of the jboss user's home directory to jbosis:jboss
# Make sure to RUN the chown after the ADD command and and before it, as ADD will
# create new files and directories with a UID and GID of 0 by default
#RUN chown -R jboss:jboss /opt/jboss

# Make the container run as the jboss user
USER root

# Copiar aplicacion de maquina de desarrollo a interior de imagen
COPY bin/ticket-monster.war /opt/eap/standalone/deployments/ROOT.war
## COPIAR TODA LA CONFIGURACION ESPECIFICA DE PROCESAR
## COPY <path relativo a Dockerfile>/configuracion_buena/ /opt/eap/cfg/

CMD ls -la /opt
CMD ls -la /opt/eap
CMD ls -la /opt/eap/bin


# Expose JBoss port
EXPOSE 8080

# Start JBoss, use the exec form which is the preferred form
ENTRYPOINT "/opt/eap/bin/standalone.sh -b 0.0.0.0 -c standalone.xml"
##ENTRYPOINT /opt/eap/bin/standalone.sh
