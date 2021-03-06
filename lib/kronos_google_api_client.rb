require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'

class KronosGoogleAPIClient
  def get_config
    if Rails.env.production?
      return 'https://www.googleapis.com/auth/admin.directory.group'
    else
      return ['https://www.googleapis.com/auth/admin.directory.group.readonly', 'https://www.googleapis.com/auth/admin.directory.user.readonly']
    end
  end

  def initialize
    # Initialize the client.
    @client = Google::APIClient.new(
        :application_name => 'Kronos-Website',
        :application_version => '1.0.0'
    )
    @client.authorization = :google_app_default
    @client.authorization.scope = self.get_config
    @client.authorization.person = 'webmaster@kronos.nl'
    @client.authorization.fetch_access_token!

    @admin_api = @client.discovered_api('admin', 'directory_v1')
  end


  def members_of_group(email)
    result = @client.execute(
        :api_method => @admin_api.members.list,
        :parameters => {:groupKey => email}
    )

    result.data
  end

  def create_email_group(email, name, description)
    result = @client.execute(
                        :api_method => @admin_api.groups.insert,
                        :parameters => {},
                        :body_object => {:email => email, :name => name,
                        :description => description}
    )
    result
  end

  def destroy_email_group(email)
    result = @client.execute(
                        :api_method => @admin_api.groups.delete,
                        :parameters => {:groupKey => email}
    )
    result.success?

  end

  def add_member_to_group(user, group_email)
    result = @client.execute(
               :api_method => @admin_api.members.insert,
               :parameters => {:groupKey => group_email},
               :body_object => {:email => user.email, :name => user.name}
    )

    result.success?
  end

  def remove_member_from_group(user, group_email)
    result = @client.execute(
        :api_method => @admin_api.members.delete,
        :parameters => {:groupKey => group_email, :memberKey => user.email}
    )

    result.success?
  end

  def add_alias_to_group(alia, group_email)
    result = @client.execute(
               :api_method => @admin_api.members.insert,
               :parameters => {:groupKey => group_email},
               :body_object => {:email => alia.emailaddress, :name => alia.name}
    )

    result.success?
  end

  def remove_alias_from_group(alia, group_email)
    result = @client.execute(
        :api_method => @admin_api.members.delete,
        :parameters => {:groupKey => group_email, :memberKey => alia.emailaddress}
    )

    result.success?
  end

  def add_group_to_group(mailinglis, group_email)
    result = @client.execute(
               :api_method => @admin_api.members.insert,
               :parameters => {:groupKey => group_email},
               :body_object => {:email => mailinglis.full_email, :name => mailinglis.name}
    )

    result.success?
  end

  def remove_group_from_group(mailinglis, group_email)
    result = @client.execute(
        :api_method => @admin_api.members.delete,
        :parameters => {:groupKey => group_email, :memberKey => mailinglis.full_email}
    )

    result.success?
  end

end
