# Project + Kubernetes

---

## Project

note:
- opgave staat op DigitAP
  - Markdown formaat, ook formaat waarin ik oplossing verwacht ⇒ Markdown preview van VSC is geschikt
- kan al een deel maken, maar nog niet alles
- overlopen

---

## Kubernetes

- **container** orchestrator
- ↔ Docker Compose
  - scaling
  - self-healing
  - rollouts
  - rollbacks
  - load balancing

---

## Imperatief vs. declaratief

note:
- twee manieren om Kubernetes te gebruiken
  - door één voor één commando's te runnen (**imperatieve** werkwijze)
  - door YAML files te schrijven met de gewenste configuratie (≈Docker Compose, Ansible,...) (**declaratief**)
- wij zullen (zoals bijna iedereen) declaratieve manier verkiezen

---

<!--TODO: laten matchen!-->
<div style="display: flex">
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```
<div>

</div>
<div>
```yaml
kind: Service 
apiVersion: v1 
metadata:
  name: hostname-service 
spec:
  type: NodePort
  selector:
    app: echo-hostname 
  ports:
    - nodePort: 30163
      port: 8080 
      targetPort: 80
```
</div>
</div>

note:
- dit zijn typische voorbeelden van declaratieve config
- kunnen volledige config in één file zetten door te scheiden via `---` of aparte files maken
  - gevolg: we kunnen deze zaken los van elkaar deployen

---

## Belangrijkste Concepten

- Cluster
- Node
- Pod
- Deployment
- Service

note:
- verzameling machines waarop Kubernetes runt
  - opgedeeld in control plane en worker plane, nog niet zo belangrijk nu
- node: één "fysieke" machine
- pod: wrapper voor (meestal) containers, meestal één per container
- deployment: wrapper voor pods, voegt zaken toe zoals replicatie
- service: abstractielaag voor netwerktoegang tot pods, zie als "postbus"

---

Cluster Overzicht

```mermaid
graph TD
  subgraph Cluster
    Master[Kubernetes Control Plane]
    Node1[Worker Node 1]
    Node2[Worker Node 2]
  end
  Master --> Node1
  Master --> Node2
  Node1 -->|Pod A| Pod1[Container(s)]
  Node2 -->|Pod B| Pod2[Container(s)]
```

---

Control Plane Componenten

kube-apiserver: ontvangt requests (via kubectl/UI)

etcd: key-value store met configuratie en status

kube-scheduler: kiest op welke node pods draaien

kube-controller-manager: voert logica uit (bv. replicatie)

Node Componenten

kubelet: beheert de status van pods op de node

kube-proxy: zorgt voor netwerkverkeer naar de juiste pod

Container runtime: voert de containers uit (bv. containerd, Docker)

Pods

Een pod bevat:

Eén of meerdere containers

Een IP-adres

Shared storage & netwerk

Wordt als één eenheid gescheduled

graph TD
  Pod[Pod]
  Pod --> Container1[Container: app]
  Pod --> Container2[Container: sidecar]

Deployments

Declaratieve manier om pods te beheren

Kubernetes zorgt voor:

Juist aantal pods (replica's)

Rolling updates

Rollbacks

apiVersion: apps/v1
kind: Deployment
metadata:
  name: example-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: example
  template:
    metadata:
      labels:
        app: example
    spec:
      containers:
      - name: app
        image: myapp:latest

Services

Zorgt voor stabiele toegang tot pods

Types:

ClusterIP: intern netwerk (default)

NodePort: toegankelijk via poort op node

LoadBalancer: externe toegang via cloud LB

graph TD
  Service[Service: example]
  Service --> Pod1
  Service --> Pod2

Samenvatting

Kubernetes organiseert en beheert containers

Belangrijkste objecten:

Cluster, Node, Pod, Deployment, Service

Declaratief & automatisch beheer
