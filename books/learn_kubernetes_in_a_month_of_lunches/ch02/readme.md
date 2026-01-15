# Chapter 2: Baby's first deployment

Container:
- Virtualized environment that runs an application component
- Think reproducible runtime environment (which is different from reproducible builds)
    - If two different nodes the same container, the container should run the same way
- k8s doesn't directly run containers. That's delegated to the container runtime that's installed on each node

Pod:
- Single unit of compute
- Containers are managed by pods and pods can contain many containers
- Pods can communicate with each other over the k8s virtual network even if they're on different nodes
- Each pod is assigned an IP address
- Containers within the pod all share that IP address and can communicate with each other over localhost
- Containers between pods communicate over the virtual k8s network

Deployment:
- Basically a declarative set of pods to be run in the cluster
- This declares the state that you want to see in the deployment, and then k8s resolves that by making pods


## Interacting with the cluster

```nu
# This will error if the pod with a matching name already exists
(kubectl run
    hello                               # The name of the pod to assign
    --image=kiamol/ch02-hello-kiamol    # Which container image to run in the pod
    --restart=Never                     # Don't restart the pod if the container exits
)

(kubectl wait                           # Wait for a k8s event to occur
    --for=condition=Ready               # Probably refers to pod.status.conditions
    pod hello                           # This is just naming the resource. Can name other ones too
)

(kubectl events                         # Grab the events (can output this to json)
    --for pod/hello                     # Specifier for the resource that you're interested in
)

(kubectl get pods
    --output jsonpath=".items"          # If you want to get subsets of the items
)

kubectl get pods | explore              # Just to explore the data in nushell

(kubectl create deployment              # Make a new resource
    hello-kiamol-2                      # Name of the resource
    --image=kiamol/ch2-hello-kiamol     # Not really sure how the image is used
)

# More likely just going to apply it from a file
(kubectl apply -f ./new-pod.yaml)

(kubectl logs                           # Get logs for a particular resource
    --tail=2                            # Most recent logds
    hello-pod-yaml
)

(kubectl exec                           # Execute a command in a resource
    pod/hello-pod-yaml
    --container container-name          # If you want to execute the command not in the default one
    -it                                 # If you want an interactive prompt
    -- bash                             # The command comes after `-- `
)
```

## Deployments

```nu
# Make a deployment that will add the label app=hello-kiamol-2 to the pod
kubectl create deployment hello-kiamol-2 --image=kiamol/ch2-hello-kiamol

# Get a list of pods and inspect their labels
nubectl get pods | get items | select metadata.name metadata.labels

# If you change a label on a pod, what will happen to the cluster?
kubectl label pods -l app=hello-kiamol-2 --overwrite app=hello-kiamol-x

nubectl get pods | get items | select metadata.name metadata.labels
```

Before
```
❯ : nubectl get pods | get items | select metadata.name metadata.labels
╭─────────────────────────────────┬────────────────────────────────────────╮
│          metadata.name          │            metadata.labels             │
├─────────────────────────────────┼────────────────────────────────────────┤
│ hello-kiamol-2-7d64888f8b-7dpmn │ ╭───────────────────┬────────────────╮ │
│                                 │ │ app               │ hello-kiamol-2 │ │
│                                 │ │ pod-template-hash │ 7d64888f8b     │ │
│                                 │ ╰───────────────────┴────────────────╯ │
╰─────────────────────────────────┴────────────────────────────────────────╯
```

After
```
❯ : nubectl get pods | get items | select metadata.name metadata.labels
╭─────────────────────────────────┬────────────────────────────────────────╮
│          metadata.name          │            metadata.labels             │
├─────────────────────────────────┼────────────────────────────────────────┤
│ hello-kiamol-2-7d64888f8b-4skdv │ ╭───────────────────┬────────────────╮ │
│                                 │ │ app               │ hello-kiamol-2 │ │
│                                 │ │ pod-template-hash │ 7d64888f8b     │ │
│                                 │ ╰───────────────────┴────────────────╯ │
│ hello-kiamol-2-7d64888f8b-7dpmn │ ╭───────────────────┬────────────────╮ │
│                                 │ │ app               │ hello-kiamol-x │ │
│                                 │ │ pod-template-hash │ 7d64888f8b     │ │
│                                 │ ╰───────────────────┴────────────────╯ │
╰─────────────────────────────────┴────────────────────────────────────────╯
```

It seems like the deployment and the pod are linked through the label. So what happened was
1. The label on the pod changed
2. K8S noticed that the deployment is no longer fullfilled
3. K8S booted up another pod to match the deployment requirements

If you change the label back with
```nu
kubectl label pods -l app=hello-kiamol-x --overwrite app=hello-kiamol-2
```
Then one of the pods is removed to fullfill the deployment


