class RepositoriesController < ApplicationController
  def index
    client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    @repos = client.repos.sort_by { |repo| repo.created_at }.reverse
  end

  def new
    @repository = Repository.new(repository.params)
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
    @repository = Repository.find(params[:id])
    @repository.destroy
    redirect_to root_path
  end
end
