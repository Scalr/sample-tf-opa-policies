#!/bin/bash

# Runs Terraform plan and downloads OPA mock data file

# Get TOKEN, and backend details

HOSTNAME=$(jq -r '.backend.config.hostname' .terraform/terraform.tfstate)
if [[ ! "$HOSTNAME" ]]; then
   error "No hostname found in .terraform/terraform.tfstate. Ensure terraform init has been run"
fi

TOKEN=$(awk -v URL=$HOSTNAME '{if ($2 ~ URL) {getline;print $3}}' < ~/.terraformrc | sed 's/"//g')
if [[ ! "$TOKEN" ]]; then
   error "No token found in ~/.terraformrc for $HOSTNAME"
fi

# Run terraform plan

echo "Running terraform plan"

terraform plan | tee .plan.out

# Extract the run_id

RUN_ID=$(grep "https://${HOSTNAME}/app/-.*/runs/run-" .plan.out | cut -d'/' -f 8 | cut -c1-19)

# Download the mock data zip file and unpack

echo "Downloading mock data"

curl -o .mock.zip -X GET 'https://'${HOSTNAME}'/api/iacp/v3/runs/'${RUN_ID}'/policy-input?' -H 'Authorization: Bearer '${TOKEN} -H 'Content-Type: application/vnd.api+json' -H 'prefer: profile=preview'

tar xvf .mock.zip

echo "Mock data file downloaded to 'input.json'"

rm -f .plan.out .mock.zip