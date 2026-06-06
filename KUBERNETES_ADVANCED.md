# Kubernetes Advanced Concepts Guide

## Table of Contents
1. [Storage Classes](#storage-classes)
2. [Taints & Tolerations](#taints--tolerations)
3. [Node Affinity](#node-affinity)
4. [Pod Affinity & Anti-Affinity](#pod-affinity--anti-affinity)
5. [Complete Examples](#complete-examples)
6. [Student Exercises](#student-exercises)

---

## Storage Classes

Storage Classes enable dynamic provisioning of persistent storage with different performance characteristics.

### Why Storage Classes?

**Without Storage Classes:**
```bash
# Manual process - slow and error-prone
1. Create Physical Storage
2. Create PersistentVolume (PV)
3. Create PersistentVolumeClaim (PVC)
4. Pod requests PVC
# Problem: Admin must pre-provision storage
```

**With Storage Classes:**
```bash
# Automatic process - fast and scalable
1. Pod needs storage
2. PersistentVolumeClaim references StorageClass
3. Kubernetes automatically:
   - Provisions storage
   - Creates PersistentVolume
   - Binds to PVC
# Problem solved: Self-service storage
```

### Storage Class Types

**Fast Storage (for databases):**
```yaml
kind: StorageClass
metadata:
  name: fast-storage
spec:
  provisioner: kubernetes.io/aws-ebs  # AWS specific
  parameters:
    type: gp3           # General Purpose SSD
    iops: 5000          # 5000 input/output operations per second
    throughput: 250     # 250 MB/s throughput
  reclaimPolicy: Retain # Keep data after PVC deletion
  allowVolumeExpansion: true  # Can grow storage later
```

**Slow Storage (for logs, backups):**
```yaml
kind: StorageClass
metadata:
  name: slow-storage
spec:
  provisioner: kubernetes.io/aws-ebs
  parameters:
    type: st1           # Throughput optimized HDD
    throughput: 40      # Lower throughput, lower cost
  reclaimPolicy: Retain
```

### Reclaim Policies

- **Delete:** Remove storage when PVC is deleted (default)
- **Retain:** Keep storage after PVC deletion (good for databases)
- **Recycle:** Wipe storage and make available (deprecated)

### Volume Binding Modes

- **Immediate:** Provision storage immediately (default)
  - Good for: Databases that need immediate access
  - Problem: Storage might be in wrong zone

- **WaitForFirstConsumer:** Wait until pod is scheduled
  - Good for: Ensure storage is in same zone as pod
  - Problem: Small delay in pod startup

---

## Taints & Tolerations

Taints and tolerations work together to prevent pods from being placed on inappropriate nodes.

### Taints (Applied to Nodes)

A taint is a key-value pair that "taints" a node, preventing pods from scheduling unless they tolerate the taint.

**Apply Taint:**
```bash
# NoSchedule: Don't schedule new pods
kubectl taint nodes node-1 gpu=true:NoSchedule

# NoExecute: Evict existing pods (unless they tolerate)
kubectl taint nodes node-2 dedicated=backend:NoExecute

# PreferNoSchedule: Try not to schedule (soft constraint)
kubectl taint nodes node-3 special=database:PreferNoSchedule
```

**Remove Taint:**
```bash
kubectl taint nodes node-1 gpu=true:NoSchedule-
```

### Tolerations (In Pod Spec)

Tolerations allow pods to be scheduled on tainted nodes.

**Basic Toleration:**
```yaml
tolerations:
  - key: gpu
    operator: Equal
    value: "true"
    effect: NoSchedule
```

**Tolerate Any Value:**
```yaml
tolerations:
  - key: gpu
    operator: Exists    # Accept any value
    effect: NoSchedule
```

**With Eviction Tolerance:**
```yaml
tolerations:
  - key: node.kubernetes.io/not-ready
    operator: Exists
    effect: NoExecute
    tolerationSeconds: 300  # Allow 5 minutes before evicting
```

### Use Cases

**1. GPU Nodes**
```bash
# Taint GPU nodes
kubectl taint nodes gpu-node gpu=true:NoSchedule

# Only ML pods can tolerate this
tolerations:
  - key: gpu
    operator: Exists
    effect: NoSchedule
```

**2. Dedicated Nodes**
```bash
# Reserve node for backend team only
kubectl taint nodes backend-node dedicated=backend:NoExecute

# Only backend pods tolerate this
tolerations:
  - key: dedicated
    operator: Equal
    value: backend
    effect: NoExecute
```

**3. License-Restricted Nodes**
```bash
# Node with expensive licensed software
kubectl taint nodes licensed-node software=paid:NoSchedule

# Only pods using licensed software tolerate this
```

---

## Node Affinity

Node affinity lets you constrain which nodes your pod can be scheduled on, based on node labels.

### Types of Node Affinity

**1. Hard Affinity (Required)**
```yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        - matchExpressions:
            - key: tier
              operator: In
              values:
                - production
```

- Pod **MUST** be scheduled on node with tier=production label
- If no matching nodes, pod stays Pending
- If label removed, pod keeps running but won't move

**2. Soft Affinity (Preferred)**
```yaml
affinity:
  nodeAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100      # Higher weight = higher priority (1-100)
        preference:
          matchExpressions:
            - key: gpu
              operator: In
              values:
                - "true"
      - weight: 50
        preference:
          matchExpressions:
            - key: ssd
              operator: In
              values:
                - "true"
```

- Pod **SHOULD** be scheduled on nodes with gpu=true (weight 100)
- If no GPU nodes, also prefer ssd=true nodes (weight 50)
- If no matching nodes, pod can be scheduled anywhere

### Operators

- **In:** Value is in the list
- **NotIn:** Value is not in the list
- **Exists:** Key exists (any value)
- **DoesNotExist:** Key doesn't exist
- **Gt:** Value is greater than
- **Lt:** Value is less than

### Label Nodes

```bash
# Add labels
kubectl label nodes node-1 tier=production gpu=true
kubectl label nodes node-2 tier=staging
kubectl label nodes node-3 database-node=true

# View labels
kubectl get nodes --show-labels

# Remove label
kubectl label nodes node-1 gpu-
```

### Use Cases

**Schedule on Production Nodes Only:**
```yaml
nodeAffinity:
  requiredDuringScheduling:
    nodeSelectorTerms:
      - matchExpressions:
          - key: environment
            operator: In
            values:
              - production
```

**Prefer High-Performance Nodes:**
```yaml
nodeAffinity:
  preferredDuringScheduling:
    - weight: 100
      preference:
        matchExpressions:
          - key: instance-type
            operator: In
            values:
              - compute-optimized
```

---

## Pod Affinity & Anti-Affinity

Pod affinity/anti-affinity lets you constrain which pods can be co-located.

### Pod Affinity (Attract Pods Together)

**Hard Pod Affinity:**
```yaml
affinity:
  podAffinity:
    requiredDuringScheduling:
      - labelSelector:
          matchExpressions:
            - key: app
              operator: In
              values:
                - backend
        topologyKey: kubernetes.io/hostname
```

- Schedule pod on **same node** as backend pod
- topologyKey=hostname means: same physical node
- Other topology keys: zone, region

**Soft Pod Affinity:**
```yaml
affinity:
  podAffinity:
    preferredDuringScheduling:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchExpressions:
              - key: app
                operator: In
                values:
                  - cache
          topologyKey: kubernetes.io/hostname
```

- Try to schedule on same node as cache pod
- If not possible, schedule elsewhere

### Pod Anti-Affinity (Spread Pods Apart)

**Hard Pod Anti-Affinity:**
```yaml
affinity:
  podAntiAffinity:
    requiredDuringScheduling:
      - labelSelector:
          matchExpressions:
            - key: app
              operator: In
              values:
                - backend
        topologyKey: kubernetes.io/hostname
```

- Never schedule on **same node** as another backend pod
- Each backend pod goes to different node
- Ensures high availability

**Soft Pod Anti-Affinity:**
```yaml
affinity:
  podAntiAffinity:
    preferredDuringScheduling:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchExpressions:
              - key: app
                operator: In
                values:
                  - backend
          topologyKey: topology.kubernetes.io/zone
```

- Try to spread backend pods across different zones
- If not enough zones, multiple pods can share zone

### Topology Keys

- **kubernetes.io/hostname:** Different nodes
- **topology.kubernetes.io/zone:** Different availability zones
- **topology.kubernetes.io/region:** Different regions
- **karpenter.sh/capacity-type:** Different capacity types
- **kubernetes.io/arch:** Different CPU architectures

### Use Cases

**1. Service Co-location (Pod Affinity)**
```yaml
# Schedule frontend on same node as backend for low latency
podAffinity:
  requiredDuringScheduling:
    - labelSelector:
        matchLabels:
          app: backend
      topologyKey: kubernetes.io/hostname
```

**2. High Availability (Pod Anti-Affinity)**
```yaml
# Spread replicas across nodes/zones
podAntiAffinity:
  requiredDuringScheduling:
    - labelSelector:
        matchLabels:
          app: backend
      topologyKey: kubernetes.io/hostname
```

**3. Spread Across Zones**
```yaml
# Better zone spread than node spread
podAntiAffinity:
  preferredDuringScheduling:
    - weight: 100
      podAffinityTerm:
        labelSelector:
          matchLabels:
            app: backend
        topologyKey: topology.kubernetes.io/zone
```

---

## Complete Examples

### Example 1: Database Deployment with All Concepts

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
        tier: database
    spec:
      # TOLERATIONS: Accept database-node taint
      tolerations:
        - key: database-node
          operator: Exists
          effect: NoExecute
      
      # AFFINITY: Must run on database nodes
      affinity:
        nodeAffinity:
          # REQUIRED: Must be labeled for databases
          requiredDuringScheduling:
            nodeSelectorTerms:
              - matchExpressions:
                  - key: database-node
                    operator: In
                    values:
                      - "true"
        
        # POD ANTI-AFFINITY: Prevent multiple replicas on same node
        podAntiAffinity:
          requiredDuringScheduling:
            - labelSelector:
                matchLabels:
                  tier: database
              topologyKey: kubernetes.io/hostname
      
      containers:
        - name: postgres
          image: postgres:15-alpine
          env:
            - name: POSTGRES_DB
              value: krishna_db
          
          # STORAGE: Use database-storage class
          volumeMounts:
            - name: data
              mountPath: /var/lib/postgresql/data
      
      volumes:
        - name: data
          persistentVolumeClaim:
            claimName: postgres-pvc

---
# STORAGE CLASS for database
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: database-storage
spec:
  provisioner: kubernetes.io/aws-ebs
  parameters:
    type: gp3
    iops: 5000
  reclaimPolicy: Retain

---
# PVC using storage class
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: database-storage
  resources:
    requests:
      storage: 20Gi
```

### Example 2: Frontend-Backend with Affinity

```yaml
# Backend Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 3
  template:
    spec:
      affinity:
        # Spread across nodes for HA
        podAntiAffinity:
          preferredDuringScheduling:
            - weight: 100
              podAffinityTerm:
                labelSelector:
                  matchLabels:
                    app: backend
                topologyKey: kubernetes.io/hostname

---
# Frontend Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 2
  template:
    spec:
      affinity:
        # Co-locate with backend for low latency
        podAffinity:
          requiredDuringScheduling:
            - labelSelector:
                matchLabels:
                  app: backend
              topologyKey: kubernetes.io/hostname
```

---

## Student Exercises

### Exercise 1: Create Storage Classes

**Task:** Create 3 storage classes with different performance levels

```bash
# Create fast, normal, slow storage classes
# Hints:
# - fast: gp3 with 5000 IOPS
# - normal: gp3 with 3000 IOPS
# - slow: st1 with 40 throughput

# Solution: See k8s/13-storage-classes.yml
kubectl apply -f k8s/13-storage-classes.yml
kubectl get storageclasses
```

### Exercise 2: Add Taints and Tolerations

**Task:** Taint a node and deploy a pod that tolerates it

```bash
# 1. Taint node-1 with gpu=true:NoSchedule
kubectl taint nodes node-1 gpu=true:NoSchedule

# 2. Deploy a pod WITHOUT toleration - observe Pending status
# 3. Add toleration and deploy - observe Running status

# 4. Remove taint
kubectl taint nodes node-1 gpu=true:NoSchedule-
```

### Exercise 3: Node Affinity Scheduling

**Task:** Schedule backend on production nodes only

```bash
# 1. Label nodes
kubectl label nodes node-1 tier=production
kubectl label nodes node-2 tier=staging

# 2. Deploy backend with nodeAffinity requiring tier=production
# 3. Observe backend only runs on node-1

# 4. Remove production label from node-1
kubectl label nodes node-1 tier-
# Observe pod stays running but won't be rescheduled

# 5. Re-add label
kubectl label nodes node-1 tier=production
```

### Exercise 4: Pod Anti-Affinity for HA

**Task:** Ensure 3 replicas run on 3 different nodes

```bash
# 1. Deploy with required podAntiAffinity
kubectl apply -f k8s/14-advanced-scheduling.yml

# 2. Check pod distribution
kubectl get pods -o wide -n krishna-devops

# 3. Scale to 4 replicas
kubectl scale deployment backend --replicas=4 -n krishna-devops

# 4. 4th pod should stay Pending (no 4th node)
kubectl describe pod <pending-pod-name> -n krishna-devops

# 5. Scale back to 3
kubectl scale deployment backend --replicas=3 -n krishna-devops
```

### Exercise 5: Combine All Concepts

**Task:** Deploy a production-ready backend with:
- Tolerations for production taint
- Node affinity for production tier
- Pod anti-affinity for high availability
- Resource requests/limits

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-production
spec:
  replicas: 3
  template:
    spec:
      # TODO: Add tolerations
      # TODO: Add nodeAffinity
      # TODO: Add podAntiAffinity
      # TODO: Add resources
      containers:
        - name: backend
          image: krishna-backend:latest
```

---

## Commands Reference

```bash
# STORAGE
kubectl get storageclasses
kubectl describe sc <storage-class>
kubectl get pvc -n krishna-devops
kubectl describe pvc <pvc-name> -n krishna-devops

# TAINTS & TOLERATIONS
kubectl taint nodes <node> key=value:effect
kubectl taint nodes <node> key=value:effect-
kubectl describe nodes <node> | grep Taints

# NODE AFFINITY
kubectl label nodes <node> key=value
kubectl get nodes --show-labels
kubectl label nodes <node> key-

# POD AFFINITY
kubectl get pods -o wide  # See pod distribution
kubectl describe pod <pod> -n krishna-devops

# GENERAL
kubectl get nodes
kubectl get pods -o wide -n krishna-devops
kubectl apply -f k8s/
kubectl delete -f k8s/
```

---

## Summary

| Concept | Purpose | Level |
|---------|---------|-------|
| **Storage Classes** | Dynamic storage provisioning | Beginner |
| **Taints & Tolerations** | Prevent pods on certain nodes | Intermediate |
| **Node Affinity** | Control pod-to-node scheduling | Intermediate |
| **Pod Affinity** | Co-locate pods together | Advanced |
| **Pod Anti-Affinity** | Spread pods apart for HA | Advanced |

---

**Happy Learning! 🚀**
