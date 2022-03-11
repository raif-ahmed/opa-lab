package k8s

default is_gatekeeper = false

has_field(obj, field) {
	not object.get(obj, field, "N_DEFINED") == "N_DEFINED"
}

missing_field(obj, field) {
	obj[field] == ""
}

missing_field(obj, field) {
	not has_field(obj, field)
}

is_gatekeeper {
	has_field(input, "review")
	has_field(input.review, "object")
}

resource = input.review.object {
	is_gatekeeper
}

resource = input {
	not is_gatekeeper
}

parameters = data.parameters {
	not is_gatekeeper
}

parameters = input.parameters {
	is_gatekeeper
}

# For Pod Containers
input_containers[c] {
	c := resource.spec.containers[_]
}

# For Pod InitContainers
input_containers[c] {
	c := resource.spec.initContainers[_]
}

# For Templated Pod Containers
input_containers[c] {
	c := resource.spec.template.spec.containers[_]
}

# For Templated Pod InitContainers
input_containers[c] {
	c := resource.spec.template.spec.initContainers[_]
}

contains_label(labels, label) {
	labels[_] == label
	#labels[_].value == label.allowedvalue
} else = false {
	true
}

not_contains_label(labels, label) {
	not contains_label(labels, label)
}

definedLabels := {[label, value] | some label; value := resource.metadata.labels[label]}