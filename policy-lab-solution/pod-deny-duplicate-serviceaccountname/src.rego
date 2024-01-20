# METADATA
# title: Service Account Deny Duplicate
# description: >-
#   This policy requires that service account is uniques for each workload per namespace.
# custom:
#   enforcement: deny
#   matchers:
#     kinds:
#     - apiGroups:
#       - apps
#       - ""
#       kinds:
#       - DaemonSet
#       - Deployment
#       - ReplicaSet
#       - StatefulSet
#       - StatefulSet
#       - Pod


package pod_deny_duplicate_serviceaccountname

import data.lib.common as common_lib

violation[{"details": {}, "msg": msg}] {
	common_lib.is_workload_type(common_lib.resource)
	some i
	common_lib.resource.metadata.namespace == common_lib.inventory.namespace[_][_][_][i].metadata.namespace
	common_lib.resource.spec.template.spec.serviceAccountName == common_lib.inventory.namespace[_][_][_][i].spec.template.spec.serviceAccountName
	other_workload := common_lib.inventory.namespace[_][_][_][i]

	# check if this is the same workload object
	common_lib.not_identical_k8s_workload(common_lib.resource, other_workload)
	
	msg := sprintf("ServiceAccountName <%v> conflicts with a defined ServiceAccountName in an existing Workload <%v> of Kind <%v>", [common_lib.resource.spec.template.spec.serviceAccountName, other_workload.metadata.name, other_workload.kind])
}
