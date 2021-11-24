LOCAL_DEV_CLUSTER ?= kind-local-dev-cluster
NOW := $(shell date +%m_%d_%Y_%H_%M)
SERVICE_NAME := example-readmodel

onboard: deploy-to-local-cluster

connect-to-local-dev-cluster:
	kubectl ctx $(LOCAL_DEV_CLUSTER)

deploy-to-local-cluster:
	kubectl ctx $(LOCAL_DEV_CLUSTER)
	helm template ./charts/$(SERVICE_NAME)/ \
		-f ./charts/$(SERVICE_NAME)/values.yaml \
		| kubectl apply -f -
	sleep 5
	kubectl wait --for=condition=ready pod --selector=cluster-name=$(SERVICE_NAME)-postgresql --timeout=600s

delete-local-deployment:
	kubectl ctx $(LOCAL_DEV_CLUSTER)
	helm template ./charts/$(SERVICE_NAME)/ \
		-f ./charts/$(SERVICE_NAME)/values.yaml \
		| kubectl delete -f -