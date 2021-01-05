
HARNESS_TEMPLATE_LOCATION=/tmp/
HARNESS_TEMPLATE_FILENAME=elasticbeanstalk-templates.zip

echo "Cleaning up temp folders..."
rm $HARNESS_TEMPLATE_LOCATION
rm -rf /tmp/elasticbeanstalk-templates/

echo "Downloading the latest relase from Github..."
wget https://github.com/luisredda/harness-aws-elastic-beanstalk/releases/download/0.1/harness-aws-elastic-beanstalk-0.1.zip -O $HARNESS_TEMPLATE_LOCATION/$HARNESS_TEMPLATE_FILENAME

echo "Unzipping file..."
mkdir $HARNESS_TEMPLATE_LOCATION/elasticbeanstalk-templates/
unzip $HARNESS_TEMPLATE_LOCATION/$HARNESS_TEMPLATE_FILENAME -d /tmp/elasticbeanstalk-templates/

echo "Renaming the template library folder with the your Account Name..."
cd $HARNESS_TEMPLATE_LOCATION/elasticbeanstalk-templates/
mv Setup/Template\ Library/acctName/ Setup/Template\ Library/$HARNESS_ACCOUNT_NAME/

echo "Compressing modified files..."
cd $HARNESS_TEMPLATE_LOCATION/elasticbeanstalk-templates/
zip -FSr $HARNESS_TEMPLATE_LOCATION/$HARNESS_TEMPLATE_FILENAME Setup/

echo "Uploading configuration to your Harness Account..."

curl --location --request POST 'https://app.harness.io/gateway/api/setup-as-code/yaml/upsert-entities?accountId='$HARNESS_ACCOUNT_ID \
--header 'accept: application/json, text/plain, */*' \
--header 'x-api-key: '$HARNESS_API_KEY \
--form 'file=@'$HARNESS_TEMPLATE_LOCATION/$HARNESS_TEMPLATE_FILENAME | jq

echo "Done."
