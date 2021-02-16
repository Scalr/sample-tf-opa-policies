# Ensure GCS buckets are not public
# Need to check the various ways this can happen

package terraform

import input.tfplan as tfplan

array_contains(arr, elem) {
	arr[_] = elem
}

# Check Bucket Access Control

deny[reason] {
	r = tfplan.resource_changes[_]
	r.mode == "managed"
	r.type == "google_storage_bucket_access_control"
	r.change.after.entity == "Public"

	reason := sprintf("%-40s :: GCS buckets must not be PUBLIC", 
	                    [r.address])
}

# Check google_storage_bucket_acl for predefined ACL's

deny[reason] {
  bad_acls := [ "publicRead", "publicReadWrite" ]
	r = tfplan.resource_changes[_]
	r.mode == "managed"
	r.type == "google_storage_bucket_acl"
	bad_acls[_] == r.change.after.predefined_acl

	reason := sprintf("%-40s :: GCS buckets must not use predefined ACL '%s'", 
	                    [r.address, r.change.after.predefined_acl])
}