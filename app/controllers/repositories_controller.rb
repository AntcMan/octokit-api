class RepositoriesController < ApplicationController
  require 'octokit'

  def index
    client = Octokit::Client.new(access_token)
    @repos = client.repos.sort_by { |repo| repo.created_at }.reverse
  end

  def show
    @repository_data = Octokit::Client.new(access_token).repo(params[:id].to_i)
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

  # EDIT
  def edit
    # ACCESS THE CORRECT REPO WITH A NEW INSTANCE
    client = Octokit::Client.new(access_token)
    # RETRIEVE THE REPO INFORMATION BASED ON THE ID; ID MUST BE PASSED AS AN INTEGER
    # THE RETRIEVED REPO IS ASSIGNED TO '@REPOSITORY_DATA' INSTANCE; THIS POPULATES THE FORM WITH
    # THE CURRENT REPOSITORY INFO
    @repository_data = client.repository(params[:id].to_i)
  end

  # UPDATE
  def update
    # INITIALIZE A NEW INSTANCE
    client = Octokit::Client.new(access_token)

    # RETRIEVE REPO ID AND ASSIGN IT TO 'REPO_ID'
    repo_id = params[:id].to_i
    puts "repo_id: #{repo_id}"

    new_name = params[:repository][:name]

    puts "new_name: #{new_name}"

    client.update_repository(repo_id, name: new_name)

    # REDIRECT TO THE REPOSITORY SHOW PAGE WITH THE UPDATED NAME
    redirect_to repository_path(repo.id)
  end

  # DESTROY
  def destroy
    Octokit::Client.new(access_token).delete_repo(params[:id].to_i)
    redirect_to root_path
  end

  private

  def access_token
    { access_token: ENV['GITHUB_TOKEN'] }
  end

  def repository_params
    params.require(:repository).permit(:name, :description)
  end
end
