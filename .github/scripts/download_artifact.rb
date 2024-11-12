require "json"
require "octokit"
require "fileutils"

artifact_name = ARGV.first
out_dir = ARGV[1]

owner = ENV["GITHUB_REPOSITORY_OWNER"]
owner_repo = ENV["GITHUB_REPOSITORY"]
repo = owner_repo.split("/").last
branch = ENV["BRANCH_NAME"]

debug = false

def sh(*args)
  puts "executing: #{args.join(' ')}" if false
  system(*args, false ? {} : {:out => '/dev/null'}) || exit(1)
end

if debug
  stack = Faraday::RackBuilder.new do |builder|
    builder.use Faraday::Retry::Middleware, exceptions: Faraday::Retry::Middleware::DEFAULT_EXCEPTIONS + [Octokit::ServerError] # or Faraday::Request::Retry for Faraday < 2.0
    builder.use Octokit::Middleware::FollowRedirects
    builder.use Octokit::Response::RaiseError
    builder.use Octokit::Response::FeedParser
    builder.response :logger do |logger|
	logger.filter(/(Authorization: "(token|Bearer) )(\w+)/, '\1[REMOVED]')
    end
    builder.adapter Faraday.default_adapter
  end
  Octokit.middleware = stack
end

options = {
  headers: {
    "Authorization" => "token #{ENV["GH_TOKEN"]}"
  },
  query: {
    "per_page" => "100",
  },
}

octokit = Octokit::Client.new
octokit.bearer_token = ENV["GH_TOKEN"]

doc = octokit.repository_artifacts(owner_repo, options)

results = {}
doc["artifacts"].each do |artifact|
  next if results.key? artifact["name"]
  next unless artifact["name"] =~ /#{artifact_name}/
  next if artifact["expired"]
  results[artifact["name"]] = artifact
end

FileUtils.mkdir_p(out_dir)
results.each do |k, v|
  url = octokit.artifact_download_url(owner_repo, v.id)
  zipfile = "#{out_dir}/#{v['name']}.zip"
  puts format("Downloading %s", zipfile)
  sh "curl", "--output", "#{zipfile}", "#{url}"
  sh "unzip", "-o", "#{zipfile}", "-d", "#{out_dir}"
  sh "rm", "-f", "#{zipfile}"
end
