## Part 2 - December 18, 2018, PREZI

# Where will my pod land? - Peter Ableda, Cloudera

kube-scheduler is one of the K8s Master processes responsible for assigning Pods to Nodes. This talk walks you through how the Kubernetes scheduler works, what kind of scheduling algorithms are available and how to configure them. We will take a look at how the Cloudera Data Science Workbench configures the scheduler and check it’s behavior on a live cluster.

Break - Pizza, beer, etc courtesy of Prezi

# Custom schedulers on the spot - Marton Sereg, Banzai Cloud

At Banzai Cloud we are building an enterprise-grade managed Kubernetes Platform and K8s distribution. Our customers attach different SLA policies to their Kubernetes clusters (time, cost, etc.) and these imply a highly configurable but SLA-aware custom K8s scheduler. This talk will highlight best practices and deep dive into the internals such as scheduler caches, topologies, informers, etc - through one of the most popular schedulers in the Pipeline ecosystem: the AWS spot-instance-aware scheduler.
