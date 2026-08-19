# Check S3 bucket is not public

package terraform

import rego.v1

import input.tfplan as tfplan

deny contains reason if {
	r = tfplan.resource_changes[_]
	r.mode == "managed"
	r.type == "aws_s3_bucket"
	r.change.after.acl == "public"

	reason := sprintf(
		"%-40s :: S3 buckets must not be PUBLIC",
		[r.address],
	)
}
