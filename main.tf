#############################################################
# Providers
#############################################################

provider "aws" {
  version = "~> 2.12"
}

#############################################################
# Labels
#############################################################

module "default_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=0.2.1"
  attributes = "${var.attributes}"
  delimiter  = "${var.delimiter}"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  tags       = "${var.tags}"
}

module "task_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=0.2.1"
  attributes = ["${compact(concat(var.attributes, list("task")))}"]
  delimiter  = "${var.delimiter}"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  tags       = "${var.tags}"
}

module "service_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=0.2.1"
  attributes = ["${compact(concat(var.attributes, list("service")))}"]
  delimiter  = "${var.delimiter}"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  tags       = "${var.tags}"
}

module "exec_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=0.2.1"
  attributes = ["${compact(concat(var.attributes, list("exec")))}"]
  delimiter  = "${var.delimiter}"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  tags       = "${var.tags}"
}

#############################################################
# Task Defenition
#############################################################

resource "aws_ecs_task_definition" "default" {
  family                   = "${module.default_label.id}"
  container_definitions    = "${var.container_definition_json}"
  requires_compatibilities = ["EC2"]
  network_mode             = "host"
  cpu                      = "${var.task_cpu}"
  memory                   = "${var.task_memory}"
  execution_role_arn       = "${aws_iam_role.ecs_exec.arn}"
  task_role_arn            = "${aws_iam_role.ecs_task.arn}"
  tags                     = "${module.default_label.tags}"
  volume                   = "${var.volumes}"
}

data "aws_iam_policy_document" "ecs_task" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task" {
  name               = "${module.task_label.id}"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_task.json}"
  tags               = "${module.task_label.tags}"
}

data "aws_iam_policy_document" "ecs_service" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

#############################################################
# Service
#############################################################

resource "aws_iam_role" "ecs_service" {
  name               = "${module.service_label.id}"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_service.json}"
  tags               = "${module.service_label.tags}"
}

data "aws_iam_policy_document" "ecs_service_policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:Describe*",
      "ec2:AuthorizeSecurityGroupIngress",
    ]
  }
}

resource "aws_iam_role_policy" "ecs_service" {
  name   = "${module.service_label.id}"
  policy = "${data.aws_iam_policy_document.ecs_service_policy.json}"
  role   = "${aws_iam_role.ecs_service.id}"
}

data "aws_iam_policy_document" "ecs_task_exec" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_exec" {
  name               = "${module.exec_label.id}"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_task_exec.json}"
  tags               = "${module.exec_label.tags}"
}

data "aws_iam_policy_document" "ecs_exec" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

resource "aws_iam_role_policy" "ecs_exec" {
  name   = "${module.exec_label.id}"
  policy = "${data.aws_iam_policy_document.ecs_exec.json}"
  role   = "${aws_iam_role.ecs_exec.id}"
}

resource "aws_ecs_service" "ignore_changes_task_definition" {
  count               = "${var.ignore_changes_task_definition == "true" ? 1: 0}"
  name                = "${module.default_label.id}"
  task_definition     = "${aws_ecs_task_definition.default.family}:${aws_ecs_task_definition.default.revision}"
  launch_type         = "EC2"
  scheduling_strategy = "DAEMON"
  cluster             = "${var.ecs_cluster_arn}"
  tags                = "${module.default_label.tags}"

  lifecycle {
    ignore_changes = ["task_definition"]
  }
}

resource "aws_ecs_service" "default" {
  count               = "${var.ignore_changes_task_definition == "false" ? 1: 0}"
  name                = "${module.default_label.id}"
  task_definition     = "${aws_ecs_task_definition.default.family}:${aws_ecs_task_definition.default.revision}"
  launch_type         = "EC2"
  scheduling_strategy = "DAEMON"
  cluster             = "${var.ecs_cluster_arn}"
  tags                = "${module.default_label.tags}"
}
