#eksctl 설치
choco install eksctl
brew install eksctl

#aws 현재 사용자 정보 (로그인 확인)
aws sts get-caller-identity

#eksctl 생성
eksctl create cluster -f exam1.yaml

#eksctl 삭제
eksctl delete cluster demo-eksctl