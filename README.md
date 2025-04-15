# Workshop de JBoss EAP en contenedor.

## Comandos de interes

### Descarga de imagen base (intermediate)
```
$ podman login registry.redhat.io
$ podman pull registry.redhat.io/jboss-eap-7/eap74-openjdk8-openshift-rhel8:7.4.18
$ podman images
```

### Construcción de imagen y ejecución de contenedor a partir de archivo de contenedor
```
$ cd <ruta de Dockerfile>
$ podman build . -t procesar-jboss-app1:7.4.18
$ podman run --name <nombre container> -dt -p 9099:8080/tcp localhost/procesar-jboss-app1:7.4.18
```

### Revisar los logs de podman para ver la salida estandar del contenedor
```
$ podman logs -l
```

### Revisar y eliminar los contenedores en ejecucion
```
$ podman ps -a
$ podman rm <ID o nombre container fallido>
```

### Revisar y eliminar las imagenes construidas
```
$ podman images
$ podman rmi <ID o nombre de imagen a purgar>
```

### Ejecutar bash en contenedor en ejecución
```
$ podman exec -it <nombre container> /bin/bash
```

### Revisar puertos expuestos en localhost
```
$ nmap -l localhost
```



## Parking lot
https://www.wildfly.org/news/2022/08/04/wildfly-maven-docker/
