> The K8S visualizer used for the demo is available here: https://github.com/martonsereg/gcp-live-k8s-visualizer

### 0. why do we want this?

### 1. deploy a front-end app without selectors / affinity
```
kubectl get nodes --show-labels

kubectl create configmap nginx-config --from-file=conf.d
kubectl apply -f 1-very-important-deployment-basic.yaml
kubectl expose deployment very-important-app --port=80 --type=LoadBalancer
kubectl get services --watch

kubectl get pods -o wide
```

visualizer:

```
kubectl proxy --www=./gcp-live-k8s-visualizer --www-prefix=/visualizer/
```

```
kubectl delete deploy very-important-app
```

### 2. deploy a front-end app with a node selector
```
diff 1-very-important-deployment-basic.yaml 2-very-important-deployment-ns.yaml
kubectl apply -f 2-very-important-deployment-ns.yaml
kubectl delete deploy very-important-app
```

### 3. deploy a front-end app with node affinity

nodeAffinites vs nodeSelector:

- you can indicate that the rule is “soft”/“preference” rather than a hard requirement, so if the scheduler can’t satisfy it, the pod will still be scheduled
- the language is more expressive (not just “AND of exact match”)
- you can constrain against labels on other pods running on the node (or other topological domain), rather than against labels on the node itself, which allows rules about which pods can and cannot be co-located

```
diff 2-very-important-deployment-ns.yaml 3-very-important-deployment-na.yaml
kubectl apply -f 3-very-important-deployment-na.yaml
kubectl delete deploy very-important-app
```

### 4. required during scheduling

You can think of them as “hard” and “soft” respectively, in the sense that the former specifies rules that must be met for a pod to be scheduled onto a node (just like nodeSelector but using a more expressive syntax), while the latter specifies preferences that the scheduler will try to enforce but will not guarantee.

```
diff 3-very-important-deployment-na.yaml 4-very-important-deployment-na-resources.yaml
kubectl apply -f 4-very-important-deployment-na-resources.yaml
kubeutil

vi 4-very-important-deployment-na-resources.yaml change replicas to 8
kubectl apply -f 4-very-important-deployment-na-resources.yaml
kubeutil
kubectl get pods
kubectl describe pod _
kubectl delete deploy very-important-app
```

### 5. preferred during scheduling

```
diff 4-very-important-deployment-na-resources.yaml 5-very-important-deployment-na-preferred.yaml
kubectl apply -f 5-very-important-deployment-na-preferred.yaml
kubeutil
kubectl get pods
vi 5-very-important-deployment-na-preferred.yaml change replicas to 8
kubectl apply -f 5-very-important-deployment-na-preferred.yaml
kubectl delete deploy very-important-app
```

The weight field in preferredDuringSchedulingIgnoredDuringExecution is in the range 1-100. For each node that meets all of the scheduling requirements (resource request, RequiredDuringScheduling affinity expressions, etc.), the scheduler will compute a sum by iterating through the elements of this field and adding “weight” to the sum if the node matches the corresponding MatchExpressions. This score is then combined with the scores of other priority functions for the node. The node(s) with the highest total score are the most preferred.
For more information on node affinity, see the design doc.


### 6. node anti-affinity + MatchExpression operators

In, NotIn, Exists, DoesNotExist, Gt, Lt. You can use NotIn and DoesNotExist to achieve node anti-affinity behavior, or use node taints to repel pods from specific nodes.

```
diff 3-very-important-deployment-na.yaml 6-very-important-deployment-naa.yaml
kubectl apply -f 6-very-important-deployment-naa.yaml
kubectl delete deploy very-important-app
```

### 7. pod anti-affinity

Inter-pod affinity and anti-affinity allow you to constrain which nodes your pod is eligible to be scheduled based on labels on pods that are already running on the node rather than based on labels on nodes.
The rules are of the form “this pod should (or, in the case of anti-affinity, should not) run in an X if that X is already running one or more pods that meet rule Y”

```
kubectl apply -f 7-redis-deployment.yaml
```

### 8. pod affinity

```
kubectl apply -f 8-very-important-deployment-pa.yaml
kubectl delete deploy very-important-app
```

note:
> requiredDuringSchedulingIgnoredDuringExecution affinity would be “co-locate the pods of service A and service B in the same zone, since they communicate a lot with each other” and an example preferredDuringSchedulingIgnoredDuringExecution anti-affinity would be “spread the pods from this service across zones” (a hard requirement wouldn’t make sense, since you probably have more pods than zones).


### Q&A
