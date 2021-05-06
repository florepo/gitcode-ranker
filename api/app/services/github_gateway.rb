class GithubGateway
  def initialize
    @access_token = Rails.application.credentials.dig(:github, :access_token)
    @client = Octokit::Client.new(:access_token => @access_token)
    @client.auto_paginate = true
  end

  def profile_exists(profile_name)
    begin
      user = @client.user profile_name
      user.present? ? true : false
    rescue
      puts("profile not found")
    end
  end

  def get_profile_repos(profile_name)
    @client.repositories(profile_name, {sort: :pushed_at})
  end
end
