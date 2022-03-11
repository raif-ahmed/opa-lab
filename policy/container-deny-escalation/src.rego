# @title Containers must not allow for privilege escalation
#
# Privileged containers can much more easily obtain root on the node.
# As such, they are not allowed.
# @enforcement deny
# @kinds apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

package container_deny_escalation

import data.k8s as common

violation[{"msg": msg, "details": {}}] {
	c := common.input_containers[_]
	c.securityContext.privileged
	msg := sprintf("Privileged container is not allowed: %v, securityContext: %v", [c.name, c.securityContext])
}
