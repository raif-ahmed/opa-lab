# @title Containers requires that any emptyDir volumes specify a sizeLimit. 
#
# @enforcement deny
# @kinds apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

package container_deny_escalation

import data.lib.common as common_lib

violation[{"msg": msg, "details": {}}] {
	c := common_lib.input_containers[_]
	c.securityContext.privileged
	msg := sprintf("Privileged container is not allowed: %v, securityContext: %v", [c.name, c.securityContext])
}
