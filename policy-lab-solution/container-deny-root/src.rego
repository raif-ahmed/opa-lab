# @title Containers must not use root (runAsUser=0 or runAsGroup=0 or runAsNonRoot=false)
#
# it si not a good practise to run containers as root user.
# As such, they are not allowed.
# @enforcement deny
# @kinds apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

package container_deny_root

import data.lib.common as common_lib

default runAsNonRoot_not_exists = true
default runAsUser_not_exists = true
default runAsGroup_not_exists = true

container_root_user= true {
	c := common_lib.input_containers[_]
 	common_lib.not_has_key(c.securityContext, "runAsNonRoot")
   	common_lib.not_has_key(c.securityContext, "runAsUser")
   	common_lib.not_has_key(c.securityContext, "runAsGroup")
}

container_root_user = true {
	c := common_lib.input_containers[_]
    c.securityContext.runAsNonRoot == false 
}
container_root_user = true {
	c := common_lib.input_containers[_]
	c.securityContext.runAsUser == 0 
}
container_root_user = true {
	c := common_lib.input_containers[_]
	c.securityContext.runAsGroup == 0 
}


violation[{"msg": msg, "details": {}}] {
	
	c := common_lib.input_containers[_]
	container_root_user


	msg := sprintf("Running container as root is not allowed, ensure you fix your securityContext %v", [c.securityContext] )

}
