conftest fmt policy/
# it is important to put the k8s conf first then paramters or data file as i parse based on index
# container-deny-escalation
yq input/deployment/opa-example-deployment_valid.yaml     | conftest test --all-namespaces -o table --combine  -p policy-lab-solution/lib -p  policy-lab-solution/container-deny-escalation -
yq input/deployment/opa-example-deployment_invalid.yaml   | conftest test --all-namespaces -o table --combine  -p policy-lab-solution/lib -p  policy-lab-solution/container-deny-escalation -

# container-deny-not-allowed-labels
yq input/namespace/opa-example-namespace_valid.yaml   data/input-params-labels.yaml   | conftest test --all-namespaces -o table --combine -p policy-lab-solution/lib -p  policy-lab-solution/container-deny-not-allowed-labels - 
yq input/namespace/opa-example-namespace_invalid.yaml data/input-params-labels.yaml   | conftest test --all-namespaces -o table --combine -p policy-lab-solution/lib -p  policy-lab-solution/container-deny-not-allowed-labels -

# container-deny-root
yq input/deployment/opa-example-deployment_valid.yaml     | conftest test --all-namespaces -o table --combine  -p policy-lab-solution/lib -p  policy-lab-solution/container-deny-root -
yq input/deployment/opa-example-deployment_invalid.yaml   | conftest test --all-namespaces -o table --combine  -p policy-lab-solution/lib -p  policy-lab-solution/container-deny-root -


# container-deny-not-allowed-service-port-prefix
yq input/service/opa-example-service_valid.yaml  data/input-params-service-prefixes.yaml   | conftest test --all-namespaces -o table --combine -p policy-lab-solution/lib -p policy-lab-solution/container-deny-not-allowed-service-port-prefix -
yq input/service/opa-example-service_invalid.yaml  data/input-params-service-prefixes.yaml   | conftest test --all-namespaces -o table --combine -p policy-lab-solution/lib -p policy-lab-solution/container-deny-not-allowed-service-port-prefix -

# container-deny-emptydir-no-size-limit
yq input/deployment/opa-example-deployment_valid.yaml     | conftest test --all-namespaces -o table --combine  -p policy-lab-solution/lib -p  policy-lab-solution/container-deny-emptydir-no-size-limit -
yq input/deployment/opa-example-deployment_invalid.yaml   | conftest test --all-namespaces -o table --combine  -p policy-lab-solution/lib -p  policy-lab-solution/container-deny-emptydir-no-size-limit -


# virtualservice-deny-duplicate
yq input/istio/opa-example-vs-1.yaml   data/input-data-inventory.yaml  | conftest test --all-namespaces -o table --combine  -p policy-lab-solution/lib -p  policy-lab-solution/virtualservice-deny-duplicate -

# pod-deny-duplicate-serviceaccount
# same serviceaccountname on different deployment
yq input/serviceaccountname/opa-example-deployment_invalid_1.yaml   data/input-data-inventory-1.yaml  | conftest test --trace --all-namespaces -o table --combine  -p policy-lab-solution/lib -p  policy-lab-solution/pod-deny-duplicate-serviceaccountname -
yq input/serviceaccountname/opa-example-deployment_invalid_2.yaml   data/input-data-inventory-1.yaml  | conftest test --trace --all-namespaces -o table --combine  -p policy-lab-solution/lib -p  policy-lab-solution/pod-deny-duplicate-serviceaccountname -
# same serviceaccountname on same deployment
yq input/serviceaccountname/opa-example-deployment_valid_1.yaml     data/input-data-inventory-1.yaml  | conftest test --all-namespaces -o table --combine  -p policy-lab-solution/lib -p  policy-lab-solution/pod-deny-duplicate-serviceaccountname -
# different serviceaccountname on different deployment
yq input/serviceaccountname/opa-example-deployment_valid_2.yaml     data/input-data-inventory-1.yaml  | conftest test --all-namespaces -o table --combine  -p policy-lab-solution/lib -p  policy-lab-solution/pod-deny-duplicate-serviceaccountname -


# all tests togther on all files
yq input/deployment/opa-example-deployment_valid.yaml   data/input-params-labels.yaml   | conftest test --all-namespaces -o table --combine -p policy-lab-solution -
yq input/deployment/opa-example-deployment_invalid.yaml data/input-params-labels.yaml   | conftest test --all-namespaces -o table --combine -p policy-lab-solution -

yq input/namespace/opa-example-namespace_valid.yaml   data/input-params-labels.yaml   | conftest test --all-namespaces -o table --combine -p policy-lab-solution - 
yq input/namespace/opa-example-namespace_invalid.yaml data/input-params-labels.yaml   | conftest test --all-namespaces -o table --combine -p policy-lab-solution -


