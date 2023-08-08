# MicroserviceReservierung
===============

> 💡 Dieses Repository ist das Ergebnis einer Zusammenarbeit mit dem HPI im Rahmen einer Bachelorarbeit aus dem Jahre 2016. Ziel war es, eine prototypische Microservicearchitektur zu entwickeln. **Das Projekt wurde planmäßig nach Abschluss der Arbeit beendet.**

Dies ist ein gemeinsames Projekt zwischen DB Systel und Hasso-Plattner-Institut zur Implementierung eines Protoypen für die Sitzplatzreservierung auf Basis von Microservices

Anleitung zum Aufsetzen auf mehreren Amazon Web Services-Instanzen
---------------
1. Mehrere Instanzen aufsetzen 
2. Eine Instanz als Basis vor Etcd und Consul wählen (--> IP Adresse merken < backend-ip >): Consul und Etcd sind das Backend für die Erstellung von Docker Swarm und ein Overlay-Netzwerk

3. Auf jeder Instanz ausführen: ./init.sh < backend-ip >

4. Auf der Backend-Instanz: ./etcd.sh 

5. Auf der Backend-Instanz: ./consul_setup.sh

6. Auf den Verwalter-Instanzen: ./swarm_manager.sh < backend-ip >

7. Auf den Knoten-Instanzen: ./swarm_node.sh < backend-ip >

8. Auf einer Verwalter-Instanz: ./setup < Anzahl der Knoten Instanzen >

Die graphische Oberfläche ist unter den IP-Adressen der Knoten-Instanzen unter Port 3000 erreichbar.

Die RabbitMQ-Management-Oberfläche befindet auch auf einer der Knoten-Instanzenauf Port 15672.

Auf einem beliebigen Verwalterknoten kann der Zustand des Clusters überprüft werden. Alle Dienstknoten müssen angezeigt werden. Dazu wird der Befehl docker -H :4000 info verwendet. 

Erklärung
---------------
<b>init.sh</b> 

Das Skript init.sh löscht den bisheringen Key, den der Docker Deamon besitzt. Da die Instanzen alle auf demselben Snapshot beruhen können, ist dieser am Anfang für alle Instanzen gleich. Dadurch können die Knoten nicht voneinander unterschieden werdne. Indem man die Datei /etc/docker/key.json löscht und Docker neustartet, wird ein neuer Key generiert. Außerdem wird der Docker Deamon entsprechend der Nutzung für Overlay-Netzewrk und Docker Swarm konfiguriert: Dazu muss er dir Flags  --cluster-advertise --cluster-store  erhalten, in dem man in die Datei /etc/default/docker folgende Zeile eingeträgt: 

<i>DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --cluster-advertise eth0:2375 --cluster-store etcd://<etcd_ip>:2379" </i>
etcd.sh

Das Skript etcd.sh läd etcd herunter und legt es unter /usr/local/bin ab. Außerdem legt einen Hintergrundprozess an. Über etcd können Overlay-Netzwerke erstellt werden.

<b>consul_setup.sh</b>

Durch das consul.sh Skript wird das Overlay-Netzwerk reservierung erstellt und außerdem ein Consul-Container hochgefahren, durch den der die Knoten einander später finden und registrieren können.

<b>swarm_manager.sh</b>

swarm_manager.sh macht die Instanz zum Verwalter des Schwarms. Dazu muss bekannt sein, auf welcher Instanz sich consul und etcd befinden, daher wird diese IP-Adresse als Parameter übergeben.

Durch den Befehl <i>ADVERTISE_ADDRESS=`ifconfig eth0 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://'`</i> wird innerhalb des Skriptes die IP-Adresse von Docker ausgelesen, sodass diese bei der Registrierung verwendet werden kann, ohne, dass sie explizit angegeben werden muss. Dadurch ist das Skript auf einer beliebigen Maschine ausführbar. 

<b>swarm_node.sh</b>

swarm_node.sh macht die Instanz zum Dienstknoten. Auch dafür müssen die Adressen von consul und etcd bekannt sein.

Vor dem Starten des Containers werden alle bisherigen Container gestoppt und entfernt, sodass der Knoten durch dieses Skript auch zurückgesetzt werden kann.

Die Adresse des Knotens wird ebenfalls automatisch durch <i>ADVERTISE_ADDRESS=`ifconfig eth0 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://'`</i> ausgelesen.

<b>setup.sh</b>

setup.sh fährt anschließend die Infrastruktur hoch und befüllt sie mit Daten. Anschließend werden die Dienste gestartet. Die Zahl, die dazu übergeben wird, gibt an, wie viele Warteschlangen, Cassandra-Instanzen und Datenbank-Kopien, sowie wie viele Instanzen der einzelnen Dienste gestartet werden sollen.  
Der Ablauf ist dabei wie folgt:

1.Starte die Infrastruktur (infrastructure-installation/docker-compose)

2.Erstelle das Cassandra und RabbitMQ-Cluster in einer For-Schleife. 

Dies ist notwendig, da die einzelnen Knoten dieser Cluster eindeutige Hostnamen besitzen müssen und daher nicht durch die Docker-Compose-Skalierung gestartet werden können. Damit die einzelnen Knoten von außen trotzdem auch unter demselben Hostnamen erreichbar sind, wird zusätzlich das Flag net-alias für alle Knoten gleich gewählt.

3.Erstelle die Kopen der MySQL-Datenbank

4.Befülle die Infrastruktur mit den Testdaten (infrastructure-installation/testdata)

5.Starte die Dienste mit dem Skalierungsgrad (services-setup/docker-compose) 
