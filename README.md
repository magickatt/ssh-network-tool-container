# SSH-able network tools in a container image

Slightly unusual container image, but if you need to grant SSH access to an external party for them to be able to use network tools within your containerised infrastructure (k8s and so forth) this may come in handy!

Inspired by
* https://docs.docker.com/engine/examples/running_ssh_service/
* https://github.com/Praqma/Network-MultiTool

## SSH username and public key

The default username in the Dockerfile is `test` but this can be changed with a [build-time variable](https://docs.docker.com/engine/reference/commandline/build/#set-build-time-variables---build-arg) which you can modify then push your built image to a private registry.

The public key is expected to be mounted in the `/opt/ssh_network_tool/keys` directory as `public_key` which will be copied to `authorized_keys` at startup.

## Kubernetes

```bash
kubectl apply -f pod.yaml
```

The included `k8s.yaml` is intended to be used to test with Minikube. If you need to deploy this to a cloud cluster you will need to add an ingress (such as changing the service type to `type: LoadBalancer` if your provider supports it)

### SSH into pod running on Minikube

```bash
ssh $(minikube ip) -l test \
  -i ~/.ssh/id_rsa \
  -p $(kubectl get svc ssh-network-tools -o=jsonpath="{.spec.ports[?(@.port==22)].nodePort}")
```

## Build

```bash
docker build . --build-arg username=magickatt --build-arg password=something
```
