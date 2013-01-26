require 'puppet/provider/parsedfile'
require 'digest/sha1'
require 'base64'

htpasswd_file = "/etc/httpd/conf/htpasswd"

Puppet::Type.type(:htpasswd).provide(
  :parsed,
  :parent => Puppet::Provider::ParsedFile,
  :default_target => htpasswd_file,
  :filetype => :flat
) do

  desc "htpasswd provider that uses the ParsedFile class"

  text_line :comment, :match => /^#/;
  text_line :blank, :match => /^\s*$/;
  record_line(:parsed,
              :fields => %w{name passwd},
              :joiner => ':',
              :separator => ':')
end
