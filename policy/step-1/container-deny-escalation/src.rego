# @title Containers must not allow for privilege escalation
#
# Privileged containers can much more easily obtain root on the node.
# As such, they are not allowed.
# @enforcement deny
# @kinds apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

package container_deny_escalation

import data.lib.common as common_lib

violation[{"msg": msg, "details": {}}] {
}
