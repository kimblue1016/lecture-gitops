# 쿠버네티스 클러스터에서 사용할 수 있는 오브젝트 목록 조회
kubectl api-resources

# 쿠버네티스 클러스터에서 속한 노드 목록 조회
kubectl get nodes

# 쿠버네티스 오브젝트 생성/변경
kubectl apply -f script.yaml

# 실행 중인 Pod(컨테이너) 목록 조회
kubectl get pods

# 애플리케이션 배포 개수를 조정 (replicas: 복제본)
kubectl scale -f script.yaml --replicas=5

# 현재 실행 중인 오브젝트 설정과 입력한 파일의 차이점 분석(only mac)
kubectl diff -f script.yaml

# 쿠버네티스 오브젝트의 spec을 editor로 편집 (replicas를 4로 변경)
kubectl edit deployment/exam-nginx

# 로컬 포트는 파드에서 실행 중인 컨테이너 포트로 포워딩
kubectl port-forward pod/exam-nginx-74786647b5-pvdws 8080:8080

# 현재 실행중인 컨테이너 프로세스에 접속하여 로그 확인
kubectl attach deployment/exam-nginx -c nginx

# 현재 실행중인 컨테이너 프로세스에 모든 로그 출력 (-f: watch 모드)
kubectl logs deployment/exam-nginx -c nginx -f