# METADATA
# title: Unique VirtualService host
# description: >-
#   This policy requires unique host across all VirtualService
# custom:
#   enforcement: deny
#   matchers:
#     kinds:
#     - apiGroups:
#       - networking.istio.io
#       kinds:
#       - VirtualService

package virtualservice_deny_duplicate

import data.lib.common as common_lib
vf_host_name_exists := null

identical(obj, review) {
	obj.metadata.namespace == review.object.metadata.namespace
	obj.metadata.name == review.object.metadata.name
}

violation[{"msg": msg, "details": {}}] {
	common_lib.resource.kind == "VirtualService"
	re_match("^networking.istio.io/.+$", common_lib.resource.apiVersion)
	

    other_virtualservices := common_lib.inventory.namespace[_]["networking.istio.io/v1beta1"]["VirtualService"][name]
	
    some i
	common_lib.contains_array_elem(other_virtualservices.spec.hosts, common_lib.resource.spec.hosts[i])
	

	msg := sprintf("VirtualService host <%v> conflicts with an existing VirtualService name:<%v/%v>", [common_lib.resource.spec.hosts[i],other_virtualservices.metadata.namespace,other_virtualservices.metadata.name])

    
}
