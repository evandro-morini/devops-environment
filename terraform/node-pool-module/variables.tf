variable "node_pool_name" {
    type = string
    description = "Nome do pool de máquinas"
}

variable "node_pool_location" {
    type = string
    description = "Localização do pool de máquinas"
}

variable "cluster_name" {
    type = string
    description = "Nome do cluster ao qual o node pool será vinculado"
}

variable "machine_type" {
    type = string
    description = "Tipo de máquina que será utilizada nos nós"
}

variable "oauth_scopes" {
  type = list(string)
  description = "OAuth link para a service account"
}

variable "min_node_count" {
    type = number
    description = "Número MÍNIMO de máquinas do autoscaling"
}

variable "max_node_count" {
    type = number
    description = "Número MÁXIMO de máquinas do autoscaling"
}

variable "node_count" {
    type = number
    description = "Número inicial de nodes"
}

