require "vagrant"
require "log4r"

module VagrantPlugins
  module ProviderIijGp
    class Plugin < Vagrant.plugin("2")
      name "IIJ GP provider"
      description <<-EOF
      The IIJ GP provider allows Vagrant to manage and control
      virtual machine in IIJ GIO hosting package service.
      EOF

      config(:iijgp, :provider) do
        require_relative "config"
        Config
      end

      provider(:iijgp, :parallel => true) do
        setup_logging
        setup_i18n

        require_relative "provider"
        Provider
      end

      def self.setup_logging
        require "log4r"

        level = nil
        begin
          level = Log4r.const_get(ENV["VAGRANT_LOG"].upcase)
        rescue NameError
        end

        level = nil unless level.is_a?(Integer)

        # Set the logging level on all "vagrant_iijgp" namespaced
        # logs as long as we have a valid level.
        if level
          logger = Log4r::Logger.new("vagrant_iijgp")
          logger.outputters = Log4r::Outputter.stderr
          logger.level = level
          logger = nil
        end
      end

      def self.setup_i18n
        I18n.load_path << File.expand_path("locales/en.yml", ProviderIijGp.source_root)
        I18n.reload!
      end
    end
  end
end
