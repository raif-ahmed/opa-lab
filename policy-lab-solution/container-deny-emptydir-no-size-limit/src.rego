# @title Containers requires that any emptyDir volumes specify a sizeLimit. 
#
# @enforcement deny
# @kinds apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

package container_deny_emptydir_no_size_limit

import data.lib.common as common_lib

violation[{"msg": msg, "details": {}}] {
	v := common_lib.input_volumes[_]
	common_lib.has_key(v,"emptyDir")
	common_lib.not_has_key(v.emptyDir,"sizeLimit")
	msg := sprintf("Container %v, has an emptyDir but didn't specify sizeLimit", [v.name])
}
