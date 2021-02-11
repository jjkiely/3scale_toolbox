require 'json'
require 'cri'
require 'yaml'
require 'uri'
require 'time'
require 'csv'
require 'net/http'
require 'pathname'
require 'oas_parser'
require '3scale/api'
require 'json-schema'
require 'erb'

require '3scale_toolbox/version'
require '3scale_toolbox/helper'
require '3scale_toolbox/error'
require '3scale_toolbox/remote_cache'
require '3scale_toolbox/proxy_logger'
require '3scale_toolbox/resource_reader'
require '3scale_toolbox/configuration'
require '3scale_toolbox/remotes'
require '3scale_toolbox/3scale_client_factory'
require '3scale_toolbox/crds'
require '3scale_toolbox/entities'
require '3scale_toolbox/attribute_filters'
require '3scale_toolbox/base_command'
require '3scale_toolbox/openapi'
require '3scale_toolbox/commands'
require '3scale_toolbox/cli'

module ThreeScaleToolbox
  def self.load_plugins
    plugin_paths.each { |plugin_path| require plugin_path }
  end

  def self.plugin_paths
    Gem.find_files('3scale_toolbox_plugin')
  end

  def self.default_config_file
    # THREESCALE_CLI_CONFIG env var has priority over $HOME/.3scalerc.yaml file
    ENV['THREESCALE_CLI_CONFIG'] || File.join(Gem.user_home, '.3scalerc.yaml')
  end
end
