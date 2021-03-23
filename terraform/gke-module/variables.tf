variable "cluster_name" {
    type = string
    description = "Nome do cluster kubernetes"
}

variable "cluster_location" {
    type = string
    description = "Localização do cluster kubernetes"
}

variable "initial_node_count" {
    type = number
    description = "Número inicial de nós do cluster"
}

variable "remove_default_node_pool" {
    type = bool
    description = "Removendo o node pool padrão criado pelo Google"
    default = true
}

variable "labels" {
    type = map
    description = "Labels no formato key:value"
    default = {}
}

variable "tags" {
  type = list(string)
  description = "Tags para identificação"
  default = []
}


