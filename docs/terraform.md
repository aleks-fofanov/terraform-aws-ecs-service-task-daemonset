## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (e.g. `1`) | list | `<list>` | no |
| container_definition_json | The JSON of the task container definition | string | - | yes |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, etc. | string | `-` | no |
| ecs_cluster_arn | The ARN of the ECS cluster where service will be provisioned | string | - | yes |
| ignore_changes_task_definition | Whether to ignore changes in container definition and task definition in the ECS service | string | `true` | no |
| name | Solution name, e.g. 'app' or 'cluster' | string | - | yes |
| namespace | Namespace, which could be your organization name, e.g. 'eg' or 'cp' | string | - | yes |
| stage | Stage, e.g. 'prod', 'staging', 'dev', or 'test' | string | - | yes |
| tags | Additional tags (e.g. `map('BusinessUnit`,`XYZ`) | map | `<map>` | no |
| task_cpu | The number of CPU units used by the task | string | `256` | no |
| task_memory | The amount of memory (in MiB) used by the task | string | `512` | no |
| volumes | Task volume definitions as list of maps | list | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| ecs_exec_role_policy_id | The ECS service role policy ID, in the form of role_name:role_policy_name |
| ecs_exec_role_policy_name | ECS service role name |
| service_name | ECS Service name |
| service_role_arn | ECS Service role ARN |
| task_definition_family | ECS task definition family |
| task_definition_revision | ECS task definition revision |
| task_exec_role_arn | ECS Task exec role ARN |
| task_exec_role_name | ECS Task role name |
| task_role_arn | ECS Task role ARN |
| task_role_id | ECS Task role id |
| task_role_name | ECS Task role name |

