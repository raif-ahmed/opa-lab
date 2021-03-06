package lib.common

default is_gatekeeper = false

common_labels := [
	{"key": "app.kubernetes.io/name", "allowedRegex": "*"},
	{"key": "app.kubernetes.io/instance", "allowedRegex": "*"},
	{"key": "app.kubernetes.io/version", "allowedRegex": "*"},
	{"key": "app.kubernetes.io/component", "allowedRegex": "*"},
	{"key": "app.kubernetes.io/part-of", "allowedRegex": "*"},
	{"key": "app.kubernetes.io/managed-by", "allowedRegex": "*"},
	{"key": "objectset.rio.cattle.io/hash", "allowedRegex": "*"},
	{"key": "kubernetes.io/metadata.name", "allowedRegex": "*"}
]

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

is_combined {
	has_field(input[_], "contents")
}

resource = input.review.object {
	is_gatekeeper
}

resource = input {
	not is_gatekeeper
	not is_combined
}

resource = input[0].contents {
	not is_gatekeeper
	is_combined
}

parameters = input[1].contents.parameters {
	not is_gatekeeper
	is_combined
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

contains_label(allowedLabels, key, value) {
	allowedLabels[_].key == key

	# do not match if any allowedRegex is not defined, or is an empty string
	allowedLabels[_].allowedRegex != ""
	re_match(allowedLabels[_].allowedRegex, value)
} else = false {
	true
}

not_contains_label(labels, key, value) {
	not contains_label(labels, key, value)
}

is_common_label(key, value) {
	# as of now it is just equality but in future it can be regex
	common_labels[_].key == key
} else = false {
	true
}

not_common_label(key, value) {
	not is_common_label(key, value)
}
