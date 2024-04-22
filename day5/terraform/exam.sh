#eks context 접속
aws eks update-kubeconfig --region ap-northeast-2 --name demo-eks-terraform

#argocd namespace 생성
kubectl create namespace argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl get po ‒n argocd

kubectl get svc -n argocd

kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

kubectl get svc -n argocd

kubectl port-forward svc/argocd-server -n argocd 8080:443

argocd admin initial-password -n argocd
