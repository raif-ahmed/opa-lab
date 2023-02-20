# METADATA
# title: Required Labels
# description: >-
#   This policy allows you to require certain labels are set on a resource.
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
#       - StatefulSet
#       - Pod
#   parameters:
#     labels:
#       type: array
#       description: Array of required label keys.
#       items:
#         type: object

package container_deny_not_allowed_labels

import data.lib.common as common_lib

allowedLabels := common_lib.parameters.labels

definedLabels := common_lib.resource.metadata.labels

violation[{"msg": msg, "details": {}}] {
	some key
	value := definedLabels[key]
	common_lib.not_contains_label(allowedLabels, key, value)
	common_lib.not_common_label(key, value)
	msg := sprintf("Label <%v: %v> does not satisfy allowed regex", [key, value])
}
