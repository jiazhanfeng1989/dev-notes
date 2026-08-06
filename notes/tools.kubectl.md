---
id: nte8ivtsnx19w3t33pkcaw8
title: Kubectl
desc: ''
updated: 1786002338225
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
```
