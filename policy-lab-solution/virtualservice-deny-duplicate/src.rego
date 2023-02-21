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

identical(obj1, obj2) {
	obj1.metadata.namespace == obj2.metadata.namespace
	obj1.metadata.name == obj2.metadata.name
}

violation[{"msg": msg, "details": {}}] {
	common_lib.resource.kind == "VirtualService"
	re_match("^networking.istio.io/.+$", common_lib.resource.apiVersion)
	

    other_virtualservice := common_lib.inventory.namespace[_][gv]["VirtualService"][name]
	# lets match all the group versions (v1beta1,v1,..) 
	re_match("^networking.istio.io/.+$", gv)

    some i
	# first check if this is the same VirtualService object
    not identical(common_lib.resource,other_virtualservice)
	# check that the host is not not defined in any of the vc defined in the cluster
	common_lib.contains_array_elem(other_virtualservice.spec.hosts, common_lib.resource.spec.hosts[i])
	
	

	msg := sprintf("VirtualService host <%v> conflicts with an existing VirtualService name:<%v/%v>", [common_lib.resource.spec.hosts[i],other_virtualservice.metadata.namespace,other_virtualservice.metadata.name])

    
}
