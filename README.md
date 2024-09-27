### Workshop al aire de JBoss EAP en contenedor.

## Descarga de imagen base (intermediate)
$ podman login registry.redhat.io
$ podman pull registry.redhat.io/jboss-eap-7/eap74-openjdk8-openshift-rhel8:7.4.18
$ podman images

$ cd <ruta de Dockerfile>
$ podman build . -t procesar-jboss-app1:7.4.18
$ podman run -dt -p 8080:8081/tcp localhost/procesar-jboss-app1:7.4.18 -v
$ podman logs -l

$ podman ps -a
$ podman rm <nombre container fallido>

$ podman images
$ podman rmi <imagen a purgar>

## Parking lot
https://www.wildfly.org/news/2022/08/04/wildfly-maven-docker/
