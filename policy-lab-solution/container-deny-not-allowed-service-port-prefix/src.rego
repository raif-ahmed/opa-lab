# METADATA
# title: Service Port prefix
# description: >-
#   This policy requires that service port names have a prefix from a specified list.
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

package container_deny_not_allowed_service_port_prefix

import data.lib.common as common_lib

allowedServicePortPrefix := common_lib.parameters.servicePortPrefix

definedServicePorts := common_lib.resource.spec.ports

violation[{"msg": msg, "details": {}}] {
	some indx
	portName := definedServicePorts[indx].name
	common_lib.not_contains_prefix(allowedServicePortPrefix, portName)
	msg := sprintf("Port with name <%v> does not satisfy allowed service Prefix", [portName])
}
