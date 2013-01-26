require 'digest/sha1'
require 'base64'

module Puppet
  newtype(:htpasswd) do
    @doc = "Manage an Apache style htpasswd file

    htpasswd { \"user2\":
      ensure => present,
      passwd => \"plain password\",
      target => \"/etc/httpd/conf/htpasswd\",
    }"

    ensurable

    newparam(:name) do
      desc "The resource name"
      isnamevar
    end

    newproperty(:passwd) do
      desc "The plain password for the given user"
      isrequired
      munge do |value|
        "{SHA}#{Base64.encode64(Digest::SHA1.digest(value)).chomp}"
      end
    end

    newproperty(:target) do
      desc "Location of the htpasswd file"
      defaultto do
        if @resource.class.defaultprovider.ancestors.include?(Puppet::Provider::ParsedFile)
          @resource.class.defaultprovider.default_target
        else
          nil
        end
      end
    end
  end
end
