#!/bin/bash

set -e

region=$1
env=$2
action=$3
kops=$4

function help() {
    echo "run.sh [Region] [Environment] [Action] [kops]"
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

function kops_create() {
    echo "Creating Kops resources"
    echo
    kops_dir="${env_dir}/kops"
    scripts/create.sh "${region}" "${env}" "${aws_account}"
    if [[ $? -ne 0 ]]; then
        echo "Problem creating Kops resources"
    fi
}

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

if [ -z "$region" ]; then
    echo "Region is not provided"
    echo
    help
fi
if [ -z "$env" ]; then
    echo "Environment is not provided"
    echo
    help
fi

if [ -z "$aws_account" ]; then
    echo 'Please set aws_account: `export aws_account=prod|non-prod`'
    echo
fi

env_dir="${cloud}/${region}/${aws_account}/${env}"

if [ ! -d "$env_dir" ]; then
    echo "${env_dir} directory does not exist"
    exit 1
fi

module=$(cat "${env_dir}/module" 2>/dev/null)
module_dir="modules/${module}"


if [ -z "${env_dir}/module" ]; then
    echo "${env_dir}/module file does not exist"
    exit 1
fi
if [ -z "$module" ]; then
    echo "${module} is empty"
    exit 1
fi
if [ ! -d "$module_dir" ]; then
    echo "${module_dir} directory does not exist"
    exit 1
fi

# import
if [ "$action" = "import" ];then
    tf_init "${env_dir}" "${module_dir}"
    tf_import "${env_dir}" "${module_dir}" $4 $5
fi


# Plan
if [ "$action" = "plan" ]; then
    tf_init "${env_dir}" "${module_dir}"
    tf_plan "${env_dir}" "${module_dir}"

fi

# Apply
if [ "$action" = "apply" ]; then
    tf_init "${env_dir}" "${module_dir}"
    tf_plan "${env_dir}" "${module_dir}"
    
    if [ -n "$kops" ] && [ "$kops" = "kops" ]; then
        echo "***********************************************************"
        echo "Are you sure you want to apply the above plan? type (y/n)"
        echo "If there are no changes, type y to continue generating kops"
        echo "***********************************************************"
    else
        echo "**************************************************"
        echo "Are you sure you want to apply the above plan? type (y/n)"
        echo "**************************************************"
    fi
    
    read yes_answer
    if [[ $yes_answer != "y" ]]; then
        echo "quitting"
        exit 0
    fi

    tf_apply "${env_dir}"
    # Create kops TF outputs if flag is set
    if [ -n "$kops" ] && [ "$kops" = "kops" ]; then
        kops_create
    fi
fi

# Destroy
if [ "$action" = "destroy" ]; then
    echo "${env_dir} ${module_dir}"
    tf_init "${env_dir}" "${module_dir}"
    tf_plan_destroy "${env_dir}" "${module_dir}"
    echo "Are you sure you want to destroy ${env_dir}? y/n"
    read yes_answer
    if [[ $yes_answer != "y" ]]; then
        echo "quitting"
        exit 0
    fi

    tf_destroy "${env_dir}" "${module_dir}"
fi
