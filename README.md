# Prepare the Environment #
* As we need to write our own policies, according to shown workflow. we will install needed toolset
![](https://raw.githubusercontent.com/raif-ahmed/opa-lab/main/img/development_workflow.JPG)

1. Install git

```ctr:developer
sudo apt-get update 
sudo apt-get install git
```

2. Install conftest

```ctr:developer
LATEST_VERSION=$(wget -O - "https://api.github.com/repos/open-policy-agent/conftest/releases/latest" > /dev/null | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | cut -c 2-)
wget "https://github.com/open-policy-agent/conftest/releases/download/v${LATEST_VERSION}/conftest_${LATEST_VERSION}_Linux_x86_64.tar.gz"
tar xzf conftest_${LATEST_VERSION}_Linux_x86_64.tar.gz
sudo mv conftest /usr/local/bin
```

3. Install konstraint

```ctr:developer
curl https://github.com/plexsystems/konstraint/releases/download/v0.18.0/konstraint-linux-amd64   --location   --output ~/konstraint 
chmod +x ~/konstraint
sudo mv ~/konstraint /usr/local/bin
```

4. Install yq

```ctr:developer
curl https://github.com/mikefarah/yq/releases/download/v4.22.1/yq_linux_amd64   --location   --output ~/yq 
chmod +x ~/yq
sudo mv ~/yq /usr/local/bin
```

1. clone the lab

```ctr:developer
git clone https://github.com/raif-ahmed/opa-lab.git
```

1. go to the lab folder

```ctr:developer
cd opa-lab
```

Now it is time to author our first rule.

So the policy folder contains three folders

```
policy
|-- container-deny-escalation
|-- |-- constraint
|-- |-- lib
|-- container-deny-not-allowed-labels
|-- |-- constraint
|-- |-- lib
```
'container-deny-escalation folder' contains a validation to evaluate a container is trying to be privileged
'lib folder' contains some common expressions and functions
'constraint folder' contains a validation to evaluate if a container try to set 'privileged : true'

container-deny-not-allowed-labels contains a validation to evaluate if a meta label defined is allowed according to set of labels passed as parameter

we will start to build our first rule 'container-deny-escalation'.
OPA Gatekeeper looks on the outcome of the violation rule, and if it evaluate to TRUE then it means that a violation occurred.

# Edit the rule and append our validation #

lets start with viewing our rule file.

```ctr:developer
vi ~/opa-lab/policy/container-deny-escalation/constraint/src.rego
```

Lets quickly explain some basic Rego.

1. violation[{"msg": msg, "details": {}}] -> is called 'Rule head'
2. whats come between the curly brackets '{}' -> is called 'Rule body'.
3. Multiple statements in rule body are **ANDed** together and All statements in rule body should be true for the rule to be true
4. Variables appearing in the head of a rule can be thought of as input and output of the rule
5. violation rule is defining rule header variables (msg, details) which will be be assigned output when rule is true

now inside the empty violation body add

```
c := common_lib.input_containers[_]
c.securityContext.privileged
msg := sprintf("Privileged container is not allowed: %v, securityContext: %v", [c.name, c.securityContext]) 
```

* So what this logic do,
  * it assign variable c all 'containers' object array which is defined in your deployments yaml (pod, deployment, statefulset,..). As 'containers' it can be defined in different way according to deployment 'kind' like 'spec.template.spec.containers', or 'spec.containers',... we took this logic to a common library 'common_lib' so it ca be used again and again.
  * we check if 'c.securityContext.privileged' is true, as it is the only statement we have if it evaluate to rue then violation occurs (rule is true) and msg variable is assigned the message.
  * last step is to assign the message that will be displayed to user.

# test the rule using conftest #

1. Test a valid deplyment

```ctr:developer
yq input/deployment/opa-example-deployment_valid.yaml   data/input-labels.yaml   | conftest test --all-namespaces -o table --combine -p policy/step-1 -
```

2. Test an invalid deplyment

```ctr:developer
yq input/deployment/opa-example-deployment_invalid.yaml data/input-labels.yaml | conftest test --all-namespaces -o table --combine -p policy/step-1 -
```

# generate you OPA gatekeeper deployment files #

check the policy folder before generating Gatekeeper files and after

```ctr:developer
ll policy/step-1/container-deny-escalation/
konstraint create policy/step-1
ll policy/step-1/container-deny-escalation/
```

With the Rancher OPA Gatekeeper App installed to our cluster, and also the needed yaml files generated (template.yaml,constraint.yaml) we can install OPA policies and then have them applied and enforced.

In this step, we're going to deploy the policy that denies the creation of privileged containers.  

The policy will tell OPA Gatekeeper to examine the spec for for any Pod or any deployment type and look for a `securityContext` section along with the `privileged` flag.  If that's set to `true`, then Gatekeeper will return an error back to the client via the Kubernetes API Server.

Let's create the `ConstraintTemplate` object for this policy:

```ctr:developer
kubectl apply -f policy/step-1/container-deny-escalation/template.yaml
```

```ctr:developer
kubectl apply -f policy/step-1/container-deny-escalation/constraint.yaml
```

With the both these resources defined, we should now be able to test OPA Gatekeeper to make sure it's enforcing our policy.

First of all, let's see what happens when we deploy a privileged deployment with the default behaviour and no policy in place preventing such an action.

1. From the menu on the left, click 'Deployments' under the 'Workload' section

2. Click on the 'Create' button at the very top.

3. Scroll to the bottom and click 'Edit as YAML' then replace the contents and paste in the deployment definition below

    ```
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: opa-example-app
      namespace: test
      labels:
        app: not-valid
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: opa-example-app
      template:
        metadata:
          labels:
            app: opa-example-app
        spec:
          containers:
            - name: opa-example-app
              # image: gcr.io/ifont/opa-example-app:latest
              image: nginx:latest
              ports:
                - containerPort: 8080
              imagePullPolicy: Always
              securityContext:
                privileged: true
              resources:
                requests:
                  memory: "64Mi"
                  cpu: "250m"
                limits:
                  memory: "128Mi"
                  cpu: "500m"
    ```

4. Click on 'Create'. After a few seconds, you'll see that the deployed with a privileged container has been created successfully and will be in an "Active" state.

5. Delete the deployment again
<img src="https://raw.githubusercontent.com/raif-ahmed/opa-lab/main/img/delete.JPG" width="200">


https://open-policy-agent.github.io/gatekeeper/website/docs/sync/

apiVersion: config.gatekeeper.sh/v1alpha1
kind: Config
metadata:
  name: config
  namespace: cattle-gatekeeper-system
spec:
  sync:
    syncOnly:
    - group: ""
      kind: Namespace
      version: v1
    - group: networking.istio.io
      kind: VirtualService
      version: v1beta1



audit:
...
auditChunkSize: 500
auditFromCache: true (1)
auditInterval: 60
...


https://engineering.sada.com/examining-gatekeeper-extracting-sample-input-for-opa-gatekeeper-policy-development-b96bda971d01

apiVersion: v1
kind: Namespace
metadata:
  name: policy-review-test
---
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: blockandexportreview
spec:
  crd:
    spec:
      names:
        kind: BlockAndExportReview
      validation:
        legacySchema: true
        openAPIV3Schema:
          properties:
            exportData:
              type: boolean
          type: object
  targets:
  - rego: |
      package blockandexportreview
      violation[{"msg": msg}] {
        data_export := get_data
        msg := sprintf("Blocked to export objects:\nInput: %v%v", [input, data_export])
      }
      get_data = data_export {
        input.parameters.exportInventoryData
        data_export := sprintf(" \nData: {\"inventory\": %v}", [data.inventory])
      }
      get_data = data_export {
        not input.parameters.exportInventoryData
        data_export := ""
      }
    target: admission.k8s.gatekeeper.sh
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: BlockAndExportReview
metadata:
  name: block-and-export-review-input
spec:
  match:
    scope: Namespaced
    namespaces: ["policy-review-test"]
  parameters:
    exportData: true