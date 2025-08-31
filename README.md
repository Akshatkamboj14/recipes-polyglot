To Setup the Secrets in your enviroment, create a .env file in your root folder

```
AWS_ACCESS_KEY_ID=your-access_key
AWS_SECRET_ACCESS_KEY=your-secret_key
AWS_REGION=us-east-1
```

then run this command,
```
kubectl create secret generic aws-secret --from-env-file=../../.env

```
