#istio :: https://istio.io

#install istioctl
choco install istioctl
brew install istioctl

#install istio
#istio profile :: https://istio.io/latest/docs/setup/additional-setup/config-profiles/
istioctl install --set profile=demo -y

#istio target namespace
kubectl label namespace default istio-injection=enabled

#show namespace label
kubectl get namespaces --show-labels

#deploy exam (bookinfo)
#https://github.com/istio/istio/tree/master/samples/bookinfo
kubectl apply -f ./bookinfo.yaml
kubectl get services
kubectl get pods

#check deploy
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage

#access gateway http://localhost/productpage
kubectl get svc istio-ingressgateway -n istio-system


#install observability
kubectl apply -f ./addons
istioctl dashboard prometheus
istioctl dashboard grafana
istioctl dashboard jaeger
istioctl dashboard kiali
