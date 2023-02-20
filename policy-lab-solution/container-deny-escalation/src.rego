# METADATA
# title: Containers must not allow for privilege escalation 
# description: >-
#   Privileged containers can much more easily obtain root on the node.
#   As such, they are not allowed.
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

package container_deny_escalation

import data.lib.common as common_lib

violation[{"msg": msg, "details": {}}] {
	c := common_lib.input_containers[_]
	c.securityContext.privileged
	msg := sprintf("Privileged container is not allowed: %v, securityContext: %v", [c.name, c.securityContext])
}
