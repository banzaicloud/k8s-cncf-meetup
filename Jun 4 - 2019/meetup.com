Details
Kubernetes Operators can package, deploy and manage K8s applications and take human operational knowledge and encodes it into the ​software. They are built on the controller-runtime library and provide various abstractions to watch and reconcile resources in a Kubernetes cluster via CRUD (Create, Update, Delete, as well as Get and List in this case) operations.

This meetup will deep dive into several toolkits/frameworks for writing operators and present some of the popular operators we have built and open sourced. For a general introduction into operators (and operator-sdk), you might want to read this post-https://banzaicloud.com/blog/operator-sdk/

Operator SDK and Kubebuilder

At Banzai Cloud we were writing operators since early days (2017) and use both the operator-sdk and kubebuilder. We've been working with CoreOS on the operator-sdk framework before the official release and for some time most of our operators were using it, however recently we switched to kubebuilder. Both toolkits are using the K8s controller-runtime, though, there are slight differences. This talk gives an introduction into both frameworks, the motivation for operators and what's under the hood.

Operators in action

We have open sourced (10+) and running lots of operators and would like to present how they work, why we made them and how they replace human operators to self-heal and manage the clusters. We let the audience choose between Istio, Kafka and Vault (2 out of 3, though time allows we can do all) and demo the benefits of operators over regular deployments.

As always, thanks Prezi for the venue, pizzas and more. We are bringing some Kubernetes t-shirts (around 40, ladies included!) from the recent KubeCon, make sure you arrive in time to get yours.
