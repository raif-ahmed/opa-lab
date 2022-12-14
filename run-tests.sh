conftest fmt policy/
# it is important to put the k8s conf first then paramters file as i parse based on index
# container-deny-escalation
yq input/deployment/opa-example-deployment_valid.yaml     | conftest test --all-namespaces -o table --combine  -p policy-lab-solution/lib -p  policy-lab-solution/container-deny-escalation -
yq input/deployment/opa-example-deployment_invalid.yaml   | conftest test --all-namespaces -o table --combine  -p policy-lab-solution/lib -p  policy-lab-solution/container-deny-escalation -

# container-deny-not-allowed-labels
yq input/namespace/opa-example-namespace_valid.yaml   data/input-labels.yaml   | conftest test --all-namespaces -o table --combine -p policy-lab-solution/lib -p  policy-lab-solution/container-deny-not-allowed-labels - 
yq input/namespace/opa-example-namespace_invalid.yaml data/input-labels.yaml   | conftest test --all-namespaces -o table --combine -p policy-lab-solution/lib -p  policy-lab-solution/container-deny-not-allowed-labels -

# container-deny-root
yq input/deployment/opa-example-deployment_valid.yaml     | conftest test --all-namespaces -o table --combine  -p policy-lab-solution/lib -p  policy-lab-solution/container-deny-root -
yq input/deployment/opa-example-deployment_invalid.yaml   | conftest test --all-namespaces -o table --combine  -p policy-lab-solution/lib -p  policy-lab-solution/container-deny-root -


# container-deny-not-allowed-service-port-prefix
yq input/service/opa-example-service_valid.yaml  data/input-service-prefixes.yaml   | conftest test --all-namespaces -o table --combine -p policy-lab-solution/lib -p policy-lab-solution/container-deny-not-allowed-service-port-prefix -
yq input/service/opa-example-service_invalid.yaml  data/input-service-prefixes.yaml   | conftest test --all-namespaces -o table --combine -p policy-lab-solution/lib -p policy-lab-solution/container-deny-not-allowed-service-port-prefix -

# container-deny-emptydir-no-size-limit
yq input/service/opa-example-service_valid.yaml  data/input-service-prefixes.yaml   | conftest test --all-namespaces -o table --combine -p policy-lab-solution/lib -p policy-lab-solution/ -
yq input/service/opa-example-service_invalid.yaml  data/input-service-prefixes.yaml   | conftest test --all-namespaces -o table --combine -p policy-lab-solution/lib -p policy-lab-solution/ -


# all tests togther on all files
yq input/deployment/opa-example-deployment_valid.yaml   data/input-labels.yaml   | conftest test --all-namespaces -o table --combine -p policy-lab-solution -
yq input/deployment/opa-example-deployment_invalid.yaml data/input-labels.yaml   | conftest test --all-namespaces -o table --combine -p policy-lab-solution -

yq input/namespace/opa-example-namespace_valid.yaml   data/input-labels.yaml   | conftest test --all-namespaces -o table --combine -p policy-lab-solution - 
yq input/namespace/opa-example-namespace_invalid.yaml data/input-labels.yaml   | conftest test --all-namespaces -o table --combine -p policy-lab-solution -


