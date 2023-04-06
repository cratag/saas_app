require 'aws-sdk-s3'
require 'erb'

AWS_REGION = "us-east-1"

class S3Client
  def initialize
    @client = Aws::S3::Client.new(
      access_key_id: Rails.application.credentials.aws_access_key_id,
      secret_access_key: Rails.application.credentials.aws_secret_access_key,
      region: AWS_REGION
    )
  end

  def upload_file(artifact)
    # Uploads a file to S3 bucket, and returns the URL
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
      puts "# Error uploading artifact #{artifact.original_filename} to AWS S3: #{exception}"
      return nil
    end
  end
end
