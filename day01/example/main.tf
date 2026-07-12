# Day 1 starter: no cloud account or credentials required.
# We generate a random pet name and write a greeting file locally.

resource "random_pet" "name" {
  length    = 2
  separator = "-"
}

resource "local_file" "greeting" {
  filename = "${path.module}/greeting.txt"
  content  = "Hello from TerraWeek 2026! 🚀\nYour infra pet name is: ${random_pet.name.id}\n"
}

output "pet_name" {
  description = "The randomly generated pet name."
  value       = random_pet.name.id
}

output "file_path" {
  description = "Where the greeting file was written."
  value       = local_file.greeting.filename
}
