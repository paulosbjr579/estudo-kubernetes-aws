ENV=prod
REGION=us-east-1
PROJECT=ESTUDO-KUBERNETES
PROFILE=paulo
BACKEND_CONFIG=application/provisioning.tfstate

tf-create:
	cd terraform &&\
	export AWS_PROFILE=$(PROFILE) && export AWS_DEFAULT_REGION=$(REGION_CONFIG) && export AWS_REGION=$(REGION) &&\
	echo "yes" | terraform init -reconfigure -backend-config="key=$(BACKEND_CONFIG)" -backend-config="region=$(REGION)" -backend-config="encrypt=true" &&\
	terraform apply -var "profile=$(PROFILE)" -var "region=$(REGION)" -var "env=$(ENV)" -var "project=$(PROJECT)"

tf-delete:
	cd terraform &&\
	export AWS_PROFILE=$(PROFILE) && export AWS_DEFAULT_REGION=$(REGION_CONFIG) && export AWS_REGION=$(REGION) &&\
	echo "yes" | terraform init -reconfigure -backend-config="key=$(BACKEND_CONFIG)" -backend-config="region=$(REGION)" -backend-config="encrypt=true" &&\
	terraform destroy -var "profile=$(PROFILE)" -var "region=$(REGION)" -var "env=$(ENV)" -var "project=$(PROJECT)"

