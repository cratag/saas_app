require 'aws-sdk-s3'
require 'erb'

class S3Client
  AWS_REGION = "us-east-1"

  def initialize
    @client = Aws::S3::Client.new(
      access_key_id: Rails.application.credentials.aws[:access_key_id],
      secret_access_key: Rails.application.credentials.aws[:secret_access_key],
      region: AWS_REGION
    )
  end

  def upload_file(artifact)
    @artifact = artifact
    # Uploads a file to S3 bucket, and returns the URL
    begin
      @client.put_object(
        bucket: bucket,
        key: key,
        body: file_name,
        acl: 'public-read'
      )

      "https://#{bucket}.s3.amazonaws.com/#{key}"
    rescue => exception
      puts "# Error uploading artifact #{file_name} to AWS S3: #{exception}"
      return nil
    end
  end

  private
  def bucket
    ENV['S3_BUCKET_NAME']
  end

  def file_extension
    file_name.slice(file_name.index('.')..-1)
  end

  def file_name
    @artifact.upload.original_filename
  end

  def key
    "#{organization_name}/#{@artifact.name}#{file_extension}"
  end

  def organization_name
    @artifact.project.tenant.name
  end
end
