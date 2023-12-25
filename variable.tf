variable "region" {
  description = "AWS region"
  default     = "us-west-2"  # Change to your desired region
}

variable "git_repo_url" {
  description = "GitHub repository URL for code"
  default     = "https://github.com/amolshete/card-website.git"
}
