# A harmless local file, used later for the `removed` block bonus demo
# (stop Terraform from managing it, without deleting the file itself).

# resource "local_file" "scratch" {
#   filename = "${path.module}/scratch-notes.txt"
#   content  = "Day 4 scratch file — used for the `removed` block bonus demo."
# }
removed {
  from = local_file.scratch

  lifecycle {
    destroy = false
  }
}