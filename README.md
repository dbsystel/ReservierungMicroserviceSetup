# MicroserviceReservierung
Gemeinsames Projekt zwischen DB Systel und Hasso-Plattner-Institut zur Implementierung eines Protoypen für die Sitzplatzreservierung auf Basis von Microservices

Anleitung zum Aufsetzen auf mehreren Amazon Web Services-Instanzen:

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
