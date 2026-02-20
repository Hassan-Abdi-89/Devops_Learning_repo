![Created VPC](image-1.png)
![Private subnet](image-2.png)
![Public subnet](image-3.png)
![Create Internet gateway](image-4.png)
Lets add an elastic ip  on your VPC dashboard:
VPC → Elastic IPs → Allocate Elastic IP

Create NAT Gateway
Go to:
VPC → NAT Gateways → Create NAT Gateway
Fill in:
Name: MyLab-NAT
Subnet: Public-Subnet ⚠️ IMPORTANT
Elastic IP: Select the one you just created
Click Create NAT Gateway

Launching EC2 in the public subnet

![ssh working ](image-5.png)


Launch EC2 in the Private Subnet 
![Creatin security group](image-6.png)
To see if the instance we log in through ssh as you can see its only accessible through the public instance .
![Private EC2 LOG IN](image-7.png)