resource "kubernetes_deployment" "bot" {
  metadata {
    namespace   = var.control_namespace
    name        = "micro-bot"
    labels      = merge(local.common_labels, { "name" = "micro-bot" })
    annotations = merge(local.common_annotations, { "name" = "go.micro.bot" })
  }
  spec {
    replicas = var.replicas
    selector {
      match_labels = merge(local.common_labels, { "name" = "micro-bot" })
    }
    template {
      metadata {
        labels = merge(local.common_labels, { "name" = "micro-bot" })
      }
      spec {
        container {
          name = "micro-bot"

          command = [
            "/micro",
            "bot",
            "--inputs=slack"
          ]

          image             = var.micro_image
          image_pull_policy = var.image_pull_policy

          dynamic "env" {
            for_each = local.common_env_vars
            content {
              name  = env.key
              value = env.value
            }
          }
          env {
            name = "MICRO_SLACK_TOKEN"
            value_from {
              secret_key_ref {
                name = "micro-slack"
                key  = "token"
              }
            }
          }

        }
      }
    }
  }
}

resource "kubernetes_secret" "bot_slack_token" {
  metadata {
    namespace = var.control_namespace
    name      = "micro-slack"
  }
  type = "Opaque"
  data = {
    "token" = var.slack_token
  }
}
