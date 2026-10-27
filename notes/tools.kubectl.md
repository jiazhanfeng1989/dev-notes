---
id: nte8ivtsnx19w3t33pkcaw8
title: Kubectl
desc: ''
updated: 1793347977318
created: 1786002327977
---
# K8s Service Troubleshooting Guide

## 1. Quick diagnostics

```bash
# Deployment / ReplicaSet
kubectl -n common-eu get deploy evplanner-eu
kubectl -n common-eu get rs -l app=evplanner-eu
kubectl -n common-eu get pods -l app=evplanner-eu -o wide

# Service backends (empty endpoints → common cause of 503)
kubectl -n common-eu get svc evplanner-eu
kubectl -n common-eu get endpointslices -l kubernetes.io/service-name=evplanner-eu

# Ingress / HPA / PDB
kubectl -n common-eu get ingress evplanner-eu
kubectl -n common-eu get hpa
kubectl -n common-eu get pdb

# All resources for this app (Pod, Service, Deployment, ReplicaSet, etc.) with node and IP columns
kubectl -n common-eu get all -l app=evplanner-eu -o wide

# Deployment details: desired replicas, rollout strategy, image, conditions, recent events
kubectl -n common-eu describe deploy evplanner-eu | grep -E 'Replicas|Conditions|Strategy'

# Namespace events sorted by time; correlate with evictions, probe failures, scheduling issues
kubectl -n common-eu get events --sort-by=.lastTimestamp | grep evplanner-eu | tail -20

# Pod start → Ready timing
kubectl -n common-eu get pod evplanner-eu-87494f966-848w4 -o jsonpath='start={.status.startTime} ready={.status.conditions[?(@.type=="Ready")].lastTransitionTime}{"\n"}'

# Heartbeat (expect HTTP 200)
kubectl -n common-eu exec $POD -c evplanner -- curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:5000/api/heartbeat

# Rollout history
kubectl -n common-eu rollout history deploy/evplanner-eu

# Rollout status
kubectl -n common-eu rollout status deploy/evplanner-eu


# Previous container logs (check after Pod restart)
kubectl -n common-eu logs <pod-name> -c evplanner --previous

# Current logs
kubectl -n common-eu logs <pod-name> -c evplanner --tail=200
kubectl -n common-eu logs -l app=evplanner-eu -c evplanner --since=1h --tail=500

# Aggregated logs from all Pods (with Pod name prefix)
kubectl -n common-eu logs -l app=evplanner-eu -c evplanner --since=30m --prefix=true


# Get events for a specific Pod
kubectl get events -n common-hkm --field-selector involvedObject.name=evplanner-hkm-7bf6589b99-66jdd --sort-by='.lastTimestamp'

# Ephemeral debug container: attach netshoot to an existing Pod for network troubleshooting
#   -it              interactive shell
#   --image          toolbox image (curl, dig, tcpdump, nc, etc.)
#   --target         share the target container's process namespace (same network stack as evplanner)
kubectl debug -it evplanner-na-6dbd944764-vrht4 \
  --image=nicolaka/netshoot \
  --target=evplanner \
  -n common-na
```

## 2. Kubeconfig and contexts

```bash
# Merge multiple kubeconfig files into ~/.kube/config
# KUBECONFIG: colon-separated list of files (left to right; later files override on conflict)
KUBECONFIG=ek2s-eks-1.kubeconfig.yaml:ek2s-eks-2.kubeconfig.yaml \
  kubectl config view --merge --flatten > /root/.kube/config

# View effective config (current ~/.kube/config)
kubectl config view

# Rename a context (shorter name for daily use)
kubectl config rename-context cluster/ek2d-eks-1 dev

# Switch active cluster/namespace/user
kubectl config use-context dev

# List all contexts (* = current)
kubectl config get-contexts

# Restart a deployment, if 'imagePullPolicy: Always' is set, it will refresh the image
kubectl -n common-eu rollout restart deployment/evplanner-eu
```

## 3 Examples
```
kubectl describe pod liveness-exec
kubectl describe pod liveness-http

kubectl delete pod/evplanner-na-645cbbf69b-j428l -n common-na
kubectl exec -it evplanner-eu-7d664ffb64-x49wc -n common-eu -c evplanner -- /bin/bash
kubectl scale deployment.apps/evplanner-eu-2499 -n common-eu --replicas=2

helm rollback -n common-eu evplanner-eu --debug 45
helm ls -a -n common-eu
helm history -n common-na  evplanner-na
helm uninstall evplanner-eu-denali-rainier -n common-eu
helm get values evplanner-na -n common-na
helm -n common-eu upgrade --install evplanner-eu ./evplanner/ -f dev_eu.yaml --set ev.tripplanner.imageag=XXX
```

## 4. k9s (terminal UI)
[k9s](https://github.com/derailed/k9s) — interactive TUI for clusters (pods, logs, exec, port-forward). Install per repo README, then run `k9s`.