# @title Required Labels
#
# This policy allows you to require certain labels are set on a resource.
# @enforcement deny
# @parameter labels array object
# @kinds core/Namespace apps/DaemonSet apps/Deployment apps/StatefulSet

package container_deny_not_allowed_labels

import data.k8s as common

allowedLabels := {[label, value] | some index; label := common.parameters.labels[index].key; value := common.parameters.labels[index].allowedvalue}


violation[{"msg": msg, "details": {}}] {
	# always the allowed labels will be larger than the defined labels
	#some i
	common.not_contains_label(allowedLabels, common.definedLabels[i])
	msg := sprintf("label '%v':'%v', is not allowed.", [common.definedLabels[i][0], common.definedLabels[i][1]])
}
