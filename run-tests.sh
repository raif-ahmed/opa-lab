conftest fmt policy/
# it is important to put the k8s conf first then paramters file as i parse based on index
yq input/deployment/opa-example-deployment_valid.yaml   data/input-labels.yaml   | conftest test --all-namespaces -o table --combine -p policy-lab-solution -
yq input/deployment/opa-example-deployment_invalid.yaml data/input-labels.yaml   | conftest test --all-namespaces -o table --combine -p policy-lab-solution -

yq input/namespace/opa-example-namespace_valid.yaml   data/input-labels.yaml   | conftest test --all-namespaces -o table --combine -p policy-lab-solution - 
yq input/namespace/opa-example-namespace_invalid.yaml data/input-labels.yaml   | conftest test --all-namespaces -o table --combine -p policy-lab-solution -
