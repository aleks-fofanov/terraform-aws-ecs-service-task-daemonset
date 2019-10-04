variable "namespace" {
  type        = "string"
  description = "Namespace, which could be your organization name, e.g. 'eg' or 'cp'"
}

variable "stage" {
  type        = "string"
  description = "Stage, e.g. 'prod', 'staging', 'dev', or 'test'"
}

variable "name" {
  type        = "string"
  description = "Solution name, e.g. 'app' or 'cluster'"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

variable "ecs_cluster_arn" {
  type        = "string"
  description = "The ARN of the ECS cluster where service will be provisioned"
}

variable "container_definition_json" {
  type        = "string"
  description = "The JSON of the task container definition"
}

variable "container_name" {
  type        = "string"
  description = "The name of the container in task definition to associate with the load balancer"
}

variable "container_port" {
  description = "The port on the container to associate with the load balancer"
  default     = 80
}

variable "task_cpu" {
  description = "The number of CPU units used by the task. If using `FARGATE` launch type `task_cpu` must match supported memory values (https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size)"
  default     = 256
}

variable "task_memory" {
  description = "The amount of memory (in MiB) used by the task. If using Fargate launch type `task_memory` must match supported cpu value (https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size)"
  default     = 512
}

variable "deployment_controller_type" {
  description = "Type of deployment controller. Valid values: `CODE_DEPLOY`, `ECS`."
  default     = "ECS"
}

variable "volumes" {
  type        = "list"
  description = "Task volume definitions as list of maps"
  default     = []
}

variable "ignore_changes_task_definition" {
  type        = "string"
  description = "Whether to ignore changes in container definition and task definition in the ECS service"
  default     = "true"
}
