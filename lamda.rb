require 'json'
require 'aws-sdk-secretsmanager'
require 'net/http'
require 'uri'
require 'fileutils'
require 'yaml'
# require 'octokit'
require 'base64'


REPO_OWNER = 'my-organization-sandbox'       # リポジトリの所有者（ユーザー名または組織名）
REPO_NAME = 'yaml_sandbox'            # リポジトリ名
BRANCH = 'main'                    # ダウンロードするブランチ名
DEST_PATH = './application.yaml'        # 保存先のパス


def lambda_handler(event:, context:)
    { statusCode: 200, body: JSON.generate("Hello from Lambda!: #{get_secret}") }
end

def get_secret
  client = Aws::SecretsManager::Client.new(region: 'ap-northeast-1')

  begin
    get_secret_value_response = client.get_secret_value(secret_id: 'GITHUB_API_TOKEN')
  rescue StandardError => e
    raise e
  end

  secret = get_secret_value_response.secret_string
  # Your code goes here.
end

# def octokit_client
#   token = get_secret
#   @client ||= Octokit::Client.new(access_token: token)
# end

def download_private_content
  uri = URI("https://api.github.com/repos/#{REPO_OWNER}/#{REPO_NAME}/contents/sample.yaml?ref=#{BRANCH}")

  secret = get_secret
  request = Net::HTTP::Get.new(uri, {
    'Accept' => 'application/vnd.github.raw+json',
    'Authorization' => "token #{secret}",
    'Content-Type' => 'application/json'
  })

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(request)
  end

  # secret = get_secret
  # JSON.parse(json).deep_symbolize_key
  # Provide authentication credentials
  # client = octokit_client
  sawyer_resource = client.contents("#{REPO_OWNER}/#{REPO_NAME}", path: 'sample.yaml', ref: BRANCH)
  File.open(DEST_PATH, 'wb') { |file| file.write(Base64.decode64(sawyer_resource.content)) }
end

def read_application_manifest
  begin
    YAML.load_file(DEST_PATH)
  rescue StandardError => e
    puts "❌ ファイルの読み込みに失敗しました: #{e.message}"
    exit 1
  end
end

# YAMLファイルの読み込み
def parse_k8s_yaml(file_path)
  content = File.read(file_path)
  sections = content.split(/^---/).map(&:strip) # YAMLを`---`で分割

  extracted_data = []

  sections.each do |section|
    lines = section.lines

    # `---`の直下にある "triggered" を含むコメントを取得
    triggered_comment = lines.find { |line| line.strip.start_with?('#') && line.include?('triggered') }&.strip
    # "triggered by" 以降の部分を抽出し、末尾のピリオドを除去
    triggered_by = triggered_comment&.match(/triggered by (.+)/)&.captures&.first&.gsub(/\.$/, '')

    # YAML部分をパース
    yaml_part = YAML.safe_load(lines.reject { |line| line.strip.start_with?('#') }.join) rescue nil

    name = nil
    if yaml_part && yaml_part['metadata'] && yaml_part['metadata']['name']
      name = yaml_part['metadata']['name']
    end

    if !triggered_by.nil? && !name.nil?
      extracted_data << {
        namespace: yaml_part['metadata']['name'],
        triggered_comment: triggered_by
      }
    end
  end

  extracted_data
end

def create_issue(data)
  body = 'namespaces and authors'
  body << "\n"
  data.each do |entry|
    body << "- #{entry[:namespace]} by @#{entry[:triggered_comment]}"
    body << "\n"
  end

  uri = URI("https://api.github.com/repos/#{REPO_OWNER}/#{REPO_NAME}/issues")

  body = "namespaces and authors\n"
  data.each do |entry|
    body << "- #{entry[:name]} by @#{entry[:triggered_comment]}\n"
  end

  issue = {
    title: 'Test Title',
    body: body
  }.to_json

  secret = get_secret
  request = Net::HTTP::Post.new(uri, {
    'Authorization' => "token #{secret}",
    'Content-Type' => 'application/json'
  })
  request.body = issue

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(request)
  end
  # client = octokit_client
  # client.create_issue("#{REPO_OWNER}/#{REPO_NAME}", 'Test Title', "#{body}")
end

download_private_content
data = parse_k8s_yaml(DEST_PATH)
create_issue(data) if data.length > 0
