# Chapter 3: The virtual network!

Service
- A way of describing an endpoint that other things can talk to within the cluster
- Can control the degree of visibility (aka within the cluster or to external world)
- DNS resolution of services are affected by namespaces in kubernetes

Headless Service
- A service that doesn't have a label selector
- Basically means it's a service that doesn't map to a pod
- Used for external services

```nu
kubectl apply -f ./sleep/sleep1.yaml -f ./sleep/sleep2.yaml

# Grab the IP of a particular pod
let podIp = nubectl get pods -l app=sleep-2 | get items | first | get status.podIP

# Show that you can talk to a particular pod through its IP address
kubectl exec deploy/sleep-1 -- ping -c 2 $podIp
```

Note that the IP is assigned on pod creation and would be different if that particular
was recreated in the cluster. Networking through the IPs therefore is brittle and not
a good way to go about things

K8S has a DNS (domain names system) built in so you can use friendly names for urls and
they will automatically get routed to the correct pod

```nu
kubectl apply -f ./sleep/sleep2-service.yaml

# Now can use the name defined in the service to connect
kubectl exec deploy/sleep-1 -- ping -c 2 sleep-2
```

Default service type is `ClusterIP` which means that the service is only visible to things
within the cluster. It's meant for inter-pod communication

```nu
kubectl apply -f ./numbers/api.yaml -f ./numbers/web.yaml

# If you tried pressing the button here, the request would fail
kubectl port-forward deploy/numbers-web 8080:80

# Adding in the services will make the communication possible
kubectl apply -f ./numbers/api-service.yaml
```

Other service types

`LoadBalancer` for a load balancer to route to different pods in the cluster
```yaml
apiVersion: v1
kind: Service
metadata:
  name: numbers-web
spec:
  ports:
    - port: 8080
      targetPort: 80
  selector:
    app: numbers-web
  type: LoadBalancer
```

`NodePort` if you want a specific port on the node
```yaml
apiVersion: v1
kind: Service
metadata:
  name: numbers-web-node
spec:
  type: NodePort
  ports:
    - port: 8080
      targetPort: 80
      nodePort: 30080
  selector:
    app: numbers-web
```

`ExternalName` for services outside of the cluster. This can be useful for managed services like databases. Doesn't work well for http requests since the domain is also in the header of the request so the request may fail
```yaml
apiVersion: v1
kind: Service
metadata:
  name: numbers-api
spec:
  type: ExternalName
  externalName: raw.githubusercontent.com
```

You can observe the change in address by doing this

```nu
# Note the address on this one
nubectl get endpoints sleep-2 | select metadata.name subsets.addresses

kubectl delete pod -l app=sleep-2

# See how the address has changed
nubectl get endpoints sleep-2 | select metadata.name subsets.addresses

# If you delete the deployment, then the endpoint no longer exists
kubectl delete deployment sleep-2

nubectl get endpoints sleep-2
```

Kubectl is namespace aware. Every command goes to the "current-namespace" unless otherwise specified
```nu
# Default namespace is set by the cluster
# Adding `--namespace` restricts the query to that namespace
kubectl get service --namespace default
kubectl get service -n kube-system

# Can use `-A`/`--all-namespaces` to get from every namespace
kubectl get service -A

# DNS lookup for a fully qualified service
kubectl exec deploy/sleep-1 -- sh -c 'nslookup numbers-api.default.svc.cluster.local | grep "^[^*]"'

# DNS lookup for a service in the system namespace
kubectl exec deploy/sleep-1 -- sh -c 'nslookup kub-dns.kube-system.svc.cluster.local | grep "^[^*]"'

#< Note the difference between the two commands is the address that's being looked up
#< numbers-api.default.svc.cluster.local 
#< kub-dns.kube-system.svc.cluster.local 
#<
#< It looks like the format is
#< <service name>.<namespace name>.svc.cluster.local
#<
#< Can also omit the namespace name and it will go to the default namespace
```

Note that deleting a deployment will delete all of its pods, but not the services. Services are independent resources that are managed separately
```nu
kubectl delete deployments --all
kubectl delete services --all
kubectl delete pods --all # in the event that you manually added pods to the cluster
kubectl get all
```

# Lab

- [x] Setup deployment in ./lab/deployments.yaml
- [x] Check what versions of the pods are running
- [x] Write a service that will make the API available at `numbers-api` but only within the cluster
- [x] Write another service that will expose v2 to the public web at port `8088`

```
❯ : kubectl apply -f ./lab/deployments.yaml
❯ : nubectl get pods | get items.metadata | select name labels

╭─────────────────────────────────────┬─────────────────────────────────────────╮
│                name                 │                 labels                  │
├─────────────────────────────────────┼─────────────────────────────────────────┤
│ lab-numbers-api-5ccd59c757-tpgr8    │ ╭───────────────────┬─────────────────╮ │
│                                     │ │ app               │ lab-numbers-api │ │
│                                     │ │ pod-template-hash │ 5ccd59c757      │ │
│                                     │ │ version           │ v1              │ │
│                                     │ ╰───────────────────┴─────────────────╯ │
│ lab-numbers-web-77dd68fff-qgwpm     │ ╭───────────────────┬─────────────────╮ │
│                                     │ │ app               │ lab-numbers-web │ │
│                                     │ │ pod-template-hash │ 77dd68fff       │ │
│                                     │ │ version           │ v1              │ │
│                                     │ ╰───────────────────┴─────────────────╯ │
│ lab-numbers-web-v2-85c97695cd-6b59p │ ╭───────────────────┬─────────────────╮ │
│                                     │ │ app               │ lab-numbers-web │ │
│                                     │ │ pod-template-hash │ 85c97695cd      │ │
│                                     │ │ version           │ v2              │ │
│                                     │ ╰───────────────────┴─────────────────╯ │
╰─────────────────────────────────────┴─────────────────────────────────────────╯

❯ : kubectl apply -f ./lab/cluster-service.yaml
❯ : kubectl exec deploy/lab-numbers-web -- sh -c 'nslookup lab-numbers-api.svc.cluster.local | grep "^[^*]"'
❯ : kubectl apply -f ./lab/public-service.yaml
❯ : ping localhost:8088
```
