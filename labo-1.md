# Analysegedeelte

evt. vraag p3 (sharpen pencil)
multiple choice vraag p6
verbindingsvraag p7
evt intro tot notatie (service, pijl, database) ⇒ kan duidelijker wat een "service" precies is ⇒ zie definitie hieronder, moet toelichten dat "een applicatie die alles doet" niet is wat we op grote schaal doen
evt vraag rond beslissingen p9
matchingvraag p14
"sharpen your pencil" p18, 21, 23, 25, 27

"In colloquial terms, a service is a cohesive collection of functionality deployed as
an independent executable. Most of the concepts we discuss with regard to serv‐
ices apply broadly to distributed architectures, and specifically microservices
architectures."

# Implementatiegedeelte

Je kent Docker Compose reeds uit het vak DevOps. Met deze tool kan je applicaties deployen die bestaan uit verschillende containers die samenwerken. In essentie runt het automatisch low-level Docker commando's zoals `docker network create` om containers vlot te laten samenwerken en haalt het opstartparameters (zoals voor port forwarding of volume mounts) uit een simpele file.

Docker Compose is geschikt voor productiegebruik, maar heeft ook grenzen. Voornamelijk met betrekking tot **gedistribueerde** systemen, dus systemen waarvan onderdelen over verschillende machines verspreid zijn. Deze zijn misschien minder zeldzaam dan je denkt: een systeem dat werkt met replica's is al een simpel voorbeeld van gedistribueerd systeem. In dit soort systemen is het moeilijker containers te beheren. Wat als er bijvoorbeeld een netwerkstoring optreedt waarbij de containers in het systeem wel blijven werken, maar niet meer met elkaar kunnen communiceren? Docker Compose is hier niet echt op voorzien, maar Kubernetes wel. Zie Kubernetes dus als een stap na Docker Compose.

Met Kubernetes kunnen we gedistribueerde applicaties runnen, zoals bijvoorbeeld applicaties met de microservices architectuur. Een "echte" Kubernetes veronderstelt eigenlijk dat je meerdere (al dan niet virtuele) machines ter beschikking hebt, maar je kan Kubernetes wel leren met de ingebouwde single-node versie van Docker Desktop.

Voor het labo van vandaag: doorloop [deze tutorial](https://birthday.play-with-docker.com/kubernetes-docker-desktop/) van Docker voor een eerste kennismaking met Kubernetes.

Tot slot (voor na de tutorial):

- Je kan Kubernetes ook runnen in (liefst 3 of 5) virtuele machines met behulp van bijvoorbeeld Proxmox of Multipass.
- De provider Civo heeft ook een goede trialperiode.
- Ook Docker Swarm bestaat en dat is "de Kubernetes van Docker zelf", maar Kubernetes is populairder en biedt meer features. Swarm is wel iets eenvoudiger.
