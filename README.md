# AWS Elastic Beanstalk Continuous Delivery with Harness.io

A Custom Deployment type for harness.io that allows you to empower your developers and DevOps teams with the world class capabilities from Harness, such as Automatic Rollbacks, pipeline templates, governance, verification and much more on your Beanstalk applications! To use this, you need to have the Custom Deployments feature enabled in your account. Talk with your Customer Success Manager or Harness Support.

This repo contains Harness Config as Code configuration. If you already have Git Sync enabled in your environment, you can just clone this repo and push the files to your repo, just changing the accountName folder to your actual Account Name, or run the *upload.sh* script in this repo to push all this configuration to your account automatically!

If you prefer to use the script to upload the templates, you should define the following env variables before running:

**Script Usage:**

```
export HARNESS_ACCOUNT_NAME=yourAccountName
export HARNESS_ACCOUNT_ID=yourAccountID
export HARNESS_API_KEY=your api key with permissions on template library

./upload.sh
```

If you see a output like this, you are good to go!

```{
  "metaData": {},
  "resource": {
    "responseStatus": "SUCCESS",
    "errorMessage": "",
    "filesStatus": [
      {
        "yamlFilePath": "Setup/Template Library/se-luisredda/Elastic Beanstalk/Rollback Elastic Beanstalk.yaml",
        "status": "SUCCESS",
        "errorMssg": ""
      },
      {
        "yamlFilePath": "Setup/Template Library/se-luisredda/Elastic Beanstalk/AWS Elastic Beanstalk.yaml",
        "status": "SUCCESS",
        "errorMssg": ""
      },
      {
        "yamlFilePath": "Setup/Template Library/se-luisredda/Elastic Beanstalk/Deploy AWS Beanstalk.yaml",
        "status": "SUCCESS",
        "errorMssg": ""
      }
    ]
  },
  "responseMessages": []
}
```

**Creating your Elastic Beanstalk Services, Environments, Workflows and More**

Before get started, let's take a look on what we have created on Harness Template Library:

On "Elastic Beanstalk Folder":
- AWS Elastic Beanstalk: Custom Deployment specification that allows you to control how Harness fetch the instance names (EC2 instances) and the Infrastructure Variables like your EB Environment Name, Region and STS Role if you would like to deploy from a single delegate into multiple AWS Accounts,
- Deploy AWS Beanstalk: Service Command that specify each deployment Step like Create EB App Version, Update Environment and Steady State Check
- Rollback Elastic Beanstalk: Rollback script template to include in the workflow rollback strategy. Work in progress to use only the Service Command above.

**Harness Service**

- Create a new service and select the "AWS Elastic Beanstalk" deployment type.
- Add your artifact in your service from a S3 source

**Harness Environment**

- On your Harness Environment, you can add one infrastructure definition per Elastic Beanstalk environment.
  - Environment Name (Mandatory): Your Beanstalk Environment Name.
  - AWS Region (Mandatory): Region where you will deploy.
  - STS Role (Optional): ARN of the role that you want to assume to deploy (Ex: in another account). This follow the same principle as we do in AWS Cloud Provider.

**Harness Workflows**

- Create a Workflow and select the Service and Environment you just created. You will see the "Fetch instances" step, that will execute the template to fetch the beanstalk instances. You should KEEP it before any other step.
- Add a new step and link the "Deploy AWS Beanstalk" service command from Template Library. If you have many delegates, pick your delegate selector and make sure that the Delegate have the AWS CLI and JQ installed.
- In the rollback steps, link the "Rollback Elastic Beanstalk" template.

You are good to go and start deploying your Beanstalk services with Harness!

