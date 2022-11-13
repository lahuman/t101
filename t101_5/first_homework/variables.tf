variable "users"{
  description = "iam users"
  type = map(object({
        group = string
  }))
  default = {}
}