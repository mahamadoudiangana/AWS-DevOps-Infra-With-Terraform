# _`AWS DevOps Infrastructure with Terraform`_ <br>

_`This project demonstrates a scalable AWS DevOps infrastructure setup using Terraform Infrastructure as Code (IaC). Designed for a multi-tier architecture, this project deploys web servers, Docker, Apache 2, and secure networking configurations to support a robust infrastructure suitable for development, testing, and production environments.`_ <br>

## _`Project Overview`_ 
_`The project provisions AWS resources using Terraform with user_data scripts for automated setup and file functions to configure servers on both public and private subnets. Additionally, a bastion host is configured to securely manage private subnet resources.`_ <br>

# _`Architecture Components`_

## _`Networking`_

<ul>
 <li>VPC (Virtual Private Cloud): Creates an isolated network for resources with custom IP ranges.</li>
 <li>Public and Private Subnets:
 <ul>
   <li>Public Subnet: Hosts three EC2 instances for web servers, accessible over the internet. </li>
   <li>Private Subnet: Hosts three EC2 instances with limited access, enhancing security </li>
 </ul>
 </li>

 <li>Internet Gateway: Provides internet access to resources within the public subnet.</li>

 <li>NAT Gateway: Enables instances in the private subnet to access the internet securely for updates and patches.</li>

 <li>Route Tables and Associations: Defines custom routing policies to control traffic flow within the VPC and directs external traffic through the Internet Gateway and NAT Gateway as needed.</li>

  
</ul>




## _`Security`_

<ul>
  <li>Security Groups:
  <ul>
    <li>Web Server Security Group: Allows inbound HTTP (port 80) and SSH (port 22) access only from the specific home IP for security.</li>
    <li>Bastion Host Security Group: Grants SSH access to internal resources within the VPC, acting as a secure jump box.</li>
    <li>Database/Internal Security Group: Restricts traffic to only the VPC for enhanced privacy and secure intercommunication among resources.</li>
  </ul>
  </li>
</ul>



## _`Compute Resources`_

<ul>
  <li>EC2 Instances:
  <ul><
        <li>Web Servers (3 instances): Deployed in the public subnet to handle web traffic. Each server has Docker and Apache 2 installed through Terraform’s user_data functionality.</li>
        <li>Private Instances (3 instances): Launched in the private subnet for backend services or databases with access restricted to the VPC.</li>
        <li>Bastion Host: Configured as a secure jump box in the public subnet to manage instances within the private subnet.</li>
  </ul>
  
  </li>
</ul>

## _`Provisioning and Automation`_

<ul>
  <li>User Data: Automates installation of Docker and Apache 2 on each web server instance.</li>
  <li>Terraform File Functions: Used to reference configuration files for consistent setup across instances.</li>
</ul>

