class ProfileRepoService
  def initialize
      @adapter = GithubGateway.new
  end

  def aggregate_repos_info(profile_name)
    response = {}

    if (profile_exists(profile_name))       
      repos_array = get_profile_repos(profile_name)

      payload = {}
      payload["total_repos"] = repos_array.length
      payload['languages'] = get_repos_language_count(repos_array)
      payload["most_used_language"] = most_used_language(payload['languages'])

      response["data"] = payload
      response["status"] = "ok"
    else
      response["status"]= "error: profile name does not exist"
    end

    response
  end

  def profile_exists(profile_name)
    @adapter.profile_exists(profile_name)
  end 

  def get_profile_repos(profile_name)
    @adapter.get_profile_repos(profile_name)
  end

  def get_repos_language_count(repos_array)
    counter = Hash.new
    repo_languages_array = extract_languages_from_repos(repos_array)

    repo_languages_array.each do |language|
      !counter[language] ? counter[language] = 1 : counter[language] += 1
    end

    counter
  end

  def extract_languages_from_repos(repos_array)
    repos_array.map{|repo| repo[:language]}.flatten
  end

  def most_used_language(language_count_hash)
    max_value = language_count_hash.values.max

    language_count_hash.
    select{|k, v| v == max_value}.keys.
    compact
  end

end