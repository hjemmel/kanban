output "repository_url" {
  description = "The URL of the created repository"
  value       = github_repository.kanban.html_url
}

output "milestone_numbers" {
  description = "Map of milestone names to their numbers"
  value = {
    for k, v in github_repository_milestone.epics :
    k => v.number
  }
}

output "created_issues" {
  description = "List of created issue URLs"
  value = [
    for issue in github_issue.tasks :
    "${github_repository.kanban.html_url}/issues/${issue.number}"
  ]
}
