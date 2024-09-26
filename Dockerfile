### FROM registry.access.redhat.com/ubi8:latest
FROM registry.redhat.io/jboss-eap-7/eap74-openjdk8-runtime-openshift-rhel8:7.4.18

# Install the java-1.8.0-openjdk-devel package
# We also need the unzip package to unpack the JBoss .zip archive
#RUN yum install -y java-1.8.0-openjdk-devel unzip && yum clean all

# Create a system user and group for jboss, they both have a UID and GID of 1100
# Set the jboss user's home directory to /opt/jboss
### RUN groupadd -r -g 1100 jboss && useradd -u 1100 -r -m -g jboss -d /opt/jboss -s /sbin/nologin jboss

# Set the environment variable JBOSS_HOME to /opt/jboss/jboss-eap-7.4.0
ENV JBOSS_HOME="/opt/jboss/jboss7.4/jboss-eap-7.4.0"

# Set the working directory to jboss' user home directory
WORKDIR /opt/jboss/jboss7.4/jboss-eap-7.4.0/

# Unpack the jboss-eap-7.4.0.zip file to the /opt/jboss directory
#ADD ./jboss-eap-7.4.0.zip /opt/jboss
#RUN unzip /opt/jboss/jboss-eap-7.4.0.zip

# Recursively change the ownership of the jboss user's home directory to jbosis:jboss
# Make sure to RUN the chown after the ADD command and and before it, as ADD will
# create new files and directories with a UID and GID of 0 by default
RUN chown -R jboss:jboss /opt/jboss

# Make the container run as the jboss user
### USER jboss

# Expose JBoss port
EXPOSE 8080

# Start JBoss, use the exec form which is the preferred form
ENTRYPOINT ["/opt/jboss/jboss7.4/jboss-eap-7.4.0/bin/standalone.sh", "-b", "0.0.0.0" "-c", "standalone.xml"]
