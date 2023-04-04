require 'aws-sdk-s3'
require 'erb'

class S3Client
  def initialize
    @client = Aws::S3::Client.new(
      access_key_id: Rails.application.credentials.aws_access_key_id,
      secret_access_key: Rails.application.credentials.aws_secret_access_key,
      region: "us-east-1"
    )
  end

  def upload_file(artifact)
    begin
      file_extension = artifact.upload.original_filename.slice(artifact.upload.original_filename.index('.')..-1)
      @client.put_object(
        bucket: ENV['S3_BUCKET_NAME'],
        key: "#{artifact.project.tenant.organization}/#{artifact.name}#{file_extension}",
        body: artifact.upload.original_filename,
        acl: 'public-read'
      )
      "https://#{ENV['S3_BUCKET_NAME']}.s3.amazonaws.com/#{artifact.project.tenant.organization}/#{artifact.name}#{file_extension}"
    rescue => exception
      puts exception
      return nil
    end
  end
end