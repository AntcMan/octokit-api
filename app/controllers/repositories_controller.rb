class RepositoriesController < ApplicationController
  def index
    client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    @repos = client.repos
  end
end
