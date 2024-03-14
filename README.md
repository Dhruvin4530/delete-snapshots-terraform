# Delete the EBS volumes snapshot after particular days using Terraform

Many times we need to create a snapshot of the EBS volume or copy the AMI from one region to another region or for any other reason and that leads to so many unused snapshots. An unused snapshot will create additional costs and that leads to an unexpected expense.

After you no longer need an Amazon EBS snapshot of a volume, you can delete it. Deleting a snapshot does not affect the volume. Deleting a volume does not affect the snapshots made from it.

![1](https://github.com/Dhruvin4530/delete-snapshots-terraform/blob/main/1.jpg)

Read the detailed overview [here](https://medium.com/@dksoni4530/how-to-delete-the-aws-ebs-volumes-snapshots-using-the-lambda-function-07feaf1c36cb).
