# Stage07 - Set up Internet service
In this stage, we set up a service accessible by the internet

##
Update the hellok8s service to use an nlb load balancer:
```
helm uninstall hellok8s
helm install hellok8s ./helm --values ./helm/values-eks3.yaml
```
In the AWS console, navigate to EC2 > Load Balancers.  Find the DNS URLof the load balancer that was created.
In the browser, navigate to the URL of the load balancer, e.g.:
`http://aeb51f9f871cd47cab511a5dda474b72-4296c544cdc993ea.elb.us-west-2.amazonaws.com/secrets`
You should see
```
{
db_password: "supersecret"
}
```




