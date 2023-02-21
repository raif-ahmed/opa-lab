# METADATA
# title: Containers requires that any emptyDir volumes specify a sizeLimit. 
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

package container_deny_emptydir_no_size_limit

import data.lib.common as common_lib

violation[{"msg": msg, "details": {}}] {
	v := common_lib.input_volumes[_]
	common_lib.has_field(v, "emptyDir")
	common_lib.missing_field(v.emptyDir, "sizeLimit")
	msg := sprintf("Container %v, has an emptyDir but didn't specify sizeLimit", [v.name])
}
