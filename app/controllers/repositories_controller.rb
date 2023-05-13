class RepositoriesController < ApplicationController
  def index
    client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    @repos = client.repos.sort_by { |repo| repo.created_at }.reverse
  end

  def show
    @repository = find_repository
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
  def update
    @repository = Repository.find(params[:id])

    # Update the repository name using Octokit
    client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    begin
      client.update.repository(@repository.full_name, name: params[:repository][:name])
    rescue Octokit::UnprocessableEntity => e
      flash[:error] = e.message
      redirect_to edit_repository_path(@repository)
      return
    end

    if @repository.update(repository_params)
      redirect_to @repository
    else
      render :edit
    end
  end

  # DESTROY
  def destroy
    @repository = Repository.find(params[:id])
    client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    begin
      client.delete_repository(@repository.full_name)
    rescue Octokit::NotFound => e
      flash[:error] = e.message
      redirect_to root_path
      return
    end
    @repository.destroy
    redirect_to root_path
  end

  private

  def find_repository
    Repository.find(params[:id])
  end

  def repository_params
    params.require(:repository).permit(:name, :description)
  end
end
