To Setup the Secrets in your enviroment, create a .env file in your root folder

```
AWS_ACCESS_KEY_ID=your-access_key
AWS_SECRET_ACCESS_KEY=your-secret_key
AWS_REGION=us-east-1
```

then run this command,
```
kubectl create secret generic aws-secrets --from-env-file=../../.env

```
------------------------------------------------------------------------------------------------------------------------------

For Ingress, we nned to first apply this file,

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.0/deploy/static/provider/baremetal/deploy.yaml
```
then apply,
```
kubectl apply -f ingress-nodeport.yaml
```

then apply,
```
kubectl apply -f ingress.yaml
```
------------------------------------------------------------------------------------------------------------------------------
for metrcis server
```
kubectl apply -f metrics.yaml
```
