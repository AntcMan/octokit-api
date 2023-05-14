class RepositoriesController < ApplicationController
  require 'octokit'

  def index
    client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    @repos = client.repos.sort_by { |repo| repo.created_at }.reverse
  end

  def show
    client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    # @repository = client.repository(params[:repo_name])
  end

  def new
    @repository = Repository.new(repository_params)
    if @repository.save
      redirect_to @repository
    else
      render 'new'
    end
  end

  def create
    client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    repo_name = params[:name]

    begin
      client.create_repository(repo_name, options = {})
      flash[:success] = "Repository '#{repo_name}' created."
    rescue Octokit::UnprocessableEntity => e
      flash[:error] = e.message
    end

    redirect_to root_path
  end

  # UPDATE

  # EDIT

  # DESTROY
  def destroy
    client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    repo = Repo.find(params[:id])
    client.delete_repository
    repo.destroy
    redirect_to root_path
  end

  private

  def repository_params
    params.require(:repository).permit(:name, :description)
  end
end
