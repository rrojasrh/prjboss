### FROM registry.access.redhat.com/ubi8:latest
FROM registry.redhat.io/jboss-eap-7/eap74-openjdk8-openshift-rhel8:7.4.18

# Set the environment variable JBOSS_HOME to /opt/jboss/jboss-eap-7.4.0
ENV JBOSS_HOME="/opt/eap"

### Add java opts parameters
#ENV JAVA_OPTS="-javaagent:'/opt/eap/jboss-modules.jar' -server -Xlog:gc*:file='/opt/eap/standalone/log/gc.log':time,uptimemillis:filecount=5,filesize=3M -Xms128m -Xmx512m -XX:MetaspaceSize=96m -Djava.net.preferIPv4Stack=true -Djboss.modules.system.pkgs=jdk.nashorn.api -Djava.awt.headless=true -XX:+UseParallelOldGC -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=20 -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -XX:ParallelGCThreads=1 -Djava.util.concurrent.ForkJoinPool.common.parallelism=1 -XX:CICompilerCount=2 -XX:+ExitOnOutOfMemoryError -Djava.security.egd=file:/dev/./urandom --add-exports=java.base/sun.nio.ch=ALL-UNNAMED --add-exports=jdk.unsupported/sun.misc=ALL-UNNAMED --add-exports=jdk.unsupported/sun.reflect=ALL-UNNAMED -Dmx.com.procesar.configuracion.properties='$JBOSS_HOME/cfg'"

# Set the working directory to jboss' user home directory
#WORKDIR /opt/eap/standalone/

# Make the container run as the jboss user
USER root

# RR: Copiar opciones de standalone.xml desde máquina de desarrollo a interior de imagen
COPY standalone-cfg/ /standalone-cfg/
RUN ln -s  /standalone-cfg/standalone-procesar.xml /opt/eap/standalone/configuration/standalone-a-usar.xml

# RR: Copiar toda la configuración específica de ProceSAR desde máquina de desarrollo a interior de imagen
#RUN mkdir /opt/eap/cfg
#COPY cfg/ /opt/eap/cfg/

# RR: Copiar OJDBC Driver desde máquina de desarrollo a interior de imagen
RUN mkdir /modules/
COPY modules/ /modules/
RUN ls -la /modules/
RUN ln -s /modules/com/ /opt/eap/modules

# RR: Copiar aplicación desde máquina de desarrollo a interior de imagen
COPY bin/ticket-monster.war /opt/eap/standalone/deployments/ROOT.war

# Recursively change the ownership of the jboss user's home directory to jbosis:jboss
# Make sure to RUN the chown after the ADD command and and before it, as ADD will
# create new files and directories with a UID and GID of 0 by default
RUN chown -R jboss:root /opt/eap

## RR: Verificaciones
RUN ls -la /standalone-cfg
RUN ls -la /opt/eap/standalone/configuration
RUN ls -la /opt/eap/modules
RUN ls -la /deployments

# RR: Usuario aplicativo
USER jboss

# Expose JBoss port
EXPOSE 8080

# Start JBoss, use the exec form which is the preferred form
CMD ["/opt/eap/bin/standalone.sh", "-b", "0.0.0.0", "-c", "standalone-a-usar.xml"]
