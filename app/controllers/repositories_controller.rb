class RepositoriesController < ApplicationController
  require 'octokit'

  def index
    client = Octokit::Client.new(access_token)
    @repos = client.repos.sort_by { |repo| repo.created_at }.reverse
  end

  def show
    # @repository_data = Octokit::Client.new(access_token).repo(params[:id].to_i)
    @repository_data = Octokit::Client.new(access_token).repo(params[:id])
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
    client = Octokit::Client.new(access_token)
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
    Octokit::Client.new(access_token).update_repo(params[:id].to_i)
  end

  # EDIT
  def edit
    Octokit::Client.new(access_token).edit_repo(params[:id].to_i)
    # FORM MUST PING THE GH REPO
    # RENDER THE REPO WITH A FORM CONTAINING CURRENT DATA
    # EDIT THE DATA IN THE FORM
    # SUBMIT FORM
  end

  # DESTROY
  def destroy
    Octokit::Client.new(access_token).delete_repo(params[:id].to_i)
    redirect_to root_path
  end

  private

  def repository_full_name
  end

  def access_token
    { access_token: ENV['GITHUB_TOKEN'] }
  end

  def repository_params
    params.require(:repository).permit(:name, :description)
  end
end
