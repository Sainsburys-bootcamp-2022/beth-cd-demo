init:
	terraform init \
		-backend-config="key=${MY_NAME}-cd-demo"

plan:
	terraform plan \
		-var="owner_name=${MY_NAME}" \
		-out=tfplan

apply:
	terraform apply tfplan

destroy:
	terraform destroy \
		-var="owner_name=${MY_NAME}"
