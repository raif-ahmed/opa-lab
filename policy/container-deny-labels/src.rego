# @title Required Labels
#
# This policy allows you to require certain labels are set on a resource.
#
# @parameter labels array object
# @kinds Namespace apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod


package k8slabels

import data.k8s


violation[{"msg": msg, "details": {}}] {

   # always the allowed labels will be larger than the defined labels
   #some i
   k8s.not_contains_label(k8s.allowedLabels,k8s.definedLabels[i])
   msg := sprintf("label '%v':'%v', is not allowed.",[k8s.definedLabels[i][0],k8s.definedLabels[i][1]])
}
