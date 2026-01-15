# Learn Kubernetes in a Month of Lunches

[book](https://www.manning.com/books/learn-kubernetes-in-a-month-of-lunches)

[source github repo](https://github.com/sixeyed/kiamol)

# Kubernetes overview

[docs](https://kubernetes.io/docs/home/)

Need these things installed to run kubernetes
- A container builder thing (docker or podman)

High level terms
- `Kubernetes` (or `k8s`) is a platform to run containers on servers
- A `node` is a server with a container runtime installed on it
- A `cluster` is a group of nodes that are each registered to the k8s orchestrator

K8S basically receives a manifest of the application that you want to run and decides when and how to run it
- Compares old version of manifest to new and determines how to resolve differences
- Allocates different resources depending on different needs
- Distributes the containers around the cluster for high availability
- Each container can talk to each other through the virtual network that k8s manages

Key terms in k8s
- `pod`: The smallest k8s resource. Responsible for managing containers
- `service`
- `volume`
- `deployment`
- `replicaset`
- `statefulset`
- `configmap`
- `secret`
