terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    github = {
      source = "integrations/github"
    }
  }
}

provider "github" {
  owner = "BambooTuna"
}