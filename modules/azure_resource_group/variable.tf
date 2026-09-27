variable "resource_groups" {
  description = "Resource groups to create."
  type = map(object({
    name     = string
    location = string
  }))
}
