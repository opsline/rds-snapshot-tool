#!/bin/bash

set -e

client=$1
action=$2


function help() {
    echo "run.sh [client] [action]"
    exit 1
}

function tf_init() {
    env_dir=$1
    module_dir=$2
    terraform init \
        -backend-config="${env_dir}/backend.tfvars" \
        -input=false \
        -reconfigure \
        "${module_dir}"
}

function tf_plan() {
    env_dir=$1
    module_dir=$2
    optional_dir=$3
    terraform plan \
        -var-file="${env_dir}/terraform.tfvars" \
        -out="${env_dir}${optional_dir}/terraform.tfplan" \
        -input=false \
        "${module_dir}"
}

function tf_apply() {
    env_dir=$1
    optional_dir=$2
    terraform apply \
        -input=false \
        "${env_dir}${optional_dir}/terraform.tfplan"
}

function tf_plan_destroy() {
    env_dir=$1
    module_dir=$2
    terraform plan -destroy \
        -var-file="${env_dir}/terraform.tfvars" \
        -input=false \
        "${module_dir}"
}

function tf_import() {
    env_dir=$1
    module_dir=$2
    resource=$3
    resource_name=$4

    terraform import \
        -var-file="${env_dir}/terraform.tfvars" \
        -provider="aws" \
        -config="${module_dir}" \
        -input=false \
        "${resource}" \
        "${resource_name}"
}

function tf_destroy() {
    env_dir=$1
    module_dir=$2
    terraform destroy \
        -var-file="${env_dir}/terraform.tfvars" \
        -input=false \
        -auto-approve \
        "${module_dir}"
}

function import() {
    tf_dir=$1
    module_dir=$2
    tf_init ${tf_dir} ${module_dir}
    tf_import ${tf_dir} ${module_dir}
}

function plan() {
    tf_dir=$1
    module_dir=$2
    tf_init ${tf_dir} ${module_dir}
    tf_plan ${tf_dir} ${module_dir}
}

function apply() {
    tf_dir=$1
    module_dir=$2
    tf_init ${tf_dir} ${module_dir}
    tf_apply ${tf_dir} ${module_dir}
}

function detroy() {
    tf_dir=$1
    module_dir=$2
    echo "${tf_dir} ${module_dir}"
    tf_init "${tf_dir}" "${module_dir}"
    tf_plan_destroy "${tf_dir}" "${module_dir}"
    echo "Are you sure you want to destroy ${tf_dir}? y/n"
    read yes_answer
    if [[ $yes_answer != "y" ]]; then
        echo "quitting"
        exit 0
    fi
    tf_destroy "${tf_dir}" "${module_dir}"
}



if [ -z "$client" ]; then
    echo "Client is not provided"
    echo
    help
fi

if [ -z "$action" ]; then
    echo "Action is not provided"
    echo
    help
fi

if [ -z "$aws_cloud" ]; then
    cloud="aws"
else
    cloud="${aws_cloud}"
fi

source_dir="${cloud}/${client}/source"
destination_dir="${cloud}/${client}/destination"

if [ ! -d "$source_dir" ]; then
    echo "${source_dir} directory does not exist"
    exit 1
fi
if [ ! -d "$destination_dir" ]; then
    echo "${destination_dir} directory does not exist"
    exit 1
fi

source_module_dir="modules/rds-snapshot-source"
destination_module_dir="modules/rds-snapshot-destination"

if [ ! -d "$source_module_dir" ]; then
    echo "${source_module_dir} directory does not exist"
    exit 1
fi
if [ ! -d "$destination_module_dir" ]; then
    echo "${destination_module_dir} directory does not exist"
    exit 1
fi

# import
if [ "$action" = "import" ];then
    echo; echo "### Source Import ###"; echo
    import "${source_dir}" "${source_module_dir}"
    echo; echo "### Destination Import ###"; echo
    import "${destination_dir}" "${destination_module_dir}"
fi


# Plan
if [ "$action" = "plan" ]; then
    echo; echo "### Source Plan ###"; echo
    plan "${source_dir}" "${source_module_dir}"
    echo; echo "### Destination Plan ###"; echo
    plan "${destination_dir}" "${destination_module_dir}"
fi

# Apply
if [ "$action" = "apply" ]; then
    echo; echo "### Source Apply ###"; echo
    apply "${source_dir}" "${source_module_dir}"
    echo; echo "### Destination Apply ###"; echo
    apply "${destination_dir}" "${destination_module_dir}"
fi

# Destroy
if [ "$action" = "destroy" ]; then
    echo; echo "### Source Destroy ###"; echo
    destroy "${source_dir}" "${source_module_dir}"
    echo; echo "### Destination Destroy ###"; echo
    destroy "${destination_dir}" "${destination_module_dir}"
fi
