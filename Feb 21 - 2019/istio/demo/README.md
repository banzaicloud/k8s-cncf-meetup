### Prometheus queries

```
sum(istio_requests_total{response_code="200", destination_app="productpage", destination_version="v1", reporter="destination"})
```

### Mixer logs

```
kubectl logs -f -n istio-system $(kubectl get pod -l app=telemetry -n istio-system -o jsonpath={.items..metadata.name} | cut -d' ' -f1) mixer | grep '"destinationApp":"productpage"'
```

### `curl` examples for mTLS

Without mTLS:
```
kubectl exec $(kubectl get pod -l app=productpage -o jsonpath={.items..metadata.name}) -c istio-proxy -- curl http://reviews:9080/reviews/1  -s | jq .
```

With mTLS:
```
kubectl exec $(kubectl get pod -l app=productpage -o jsonpath={.items..metadata.name}) -c istio-proxy -- curl https://reviews:9080/reviews/1  -s --key /etc/certs/key.pem --cert /etc/certs/cert-chain.pem --cacert /etc/certs/root-cert.pem -k | jq .
```

### load testing reviews app

one request:
```
kubectl exec -it $(kubectl get pod -l app=fortio -o jsonpath={.items..metadata.name})  -c fortio /usr/local/bin/fortio -- load -curl  http://reviews.default.svc.cluster.local:9080/reviews/1
```

100 requests from 2 concurrent connections:
```
kubectl exec -it $(kubectl get pod -l app=fortio -o jsonpath={.items..metadata.name})  -c fortio /usr/local/bin/fortio -- load -c 2 -qps 0 -n 100 -loglevel Warning  http://reviews.default.svc.cluster.local:9080/reviews/1
```

errors in prometheus:
```
sum(istio_requests_total{destination_service="ratings.default.svc.cluster.local", source_app="reviews", response_code="500"})
```