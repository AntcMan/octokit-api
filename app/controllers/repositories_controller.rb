class RepositoriesController < ApplicationController
  def index
    client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    @repos = client.repos.sort_by { |repo| repo.created_at }.reverse
  end

  def show
    @repository = find_repository
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

  # EDIT
  def edit
    @repository = find_repository
  end

  # UPDATE
  def update
    @repository = find_repository

    if @repository.update(repository_params)
      redirect_to @repository
    else
      render :edit
    end
  end

  # DESTROY
  def destroy
    @repository = find_repository
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
