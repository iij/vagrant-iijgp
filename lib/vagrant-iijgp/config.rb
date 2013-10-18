module VagrantPlugins
  module ProviderIijGp
    class Config < Vagrant.plugin("2", :config)
      attr_accessor :endpoint

      attr_accessor :access_key
      attr_accessor :secret_key

      attr_accessor :gp_service_code
      attr_accessor :gc_service_code

      attr_accessor :virtual_machine_type
      attr_accessor :os

      attr_accessor :ssh_public_key

      attr_accessor :label

      def initialize
        @endpoint = UNSET_VALUE
        @access_key = UNSET_VALUE
        @secret_key = UNSET_VALUE
        @gp_service_code = UNSET_VALUE
        @gc_service_code = UNSET_VALUE
        @virtual_machine_type = UNSET_VALUE
        @os = UNSET_VALUE
        @ssh_public_key = UNSET_VALUE
        @label = UNSET_VALUE
      end

      def finalize!
        @endpoint = nil if @endpoint == UNSET_VALUE
        @access_key = ENV['IIJAPI_ACCESS_KEY'] if @access_key == UNSET_VALUE
        @secret_key = ENV['IIJAPI_SECRET_KEY'] if @secret_key == UNSET_VALUE

        @virtual_machine_type = 'V10' if @virtual_machine_type == UNSET_VALUE
        @os = 'CentOS6_64_U' if @os == UNSET_VALUE
        @ssh_public_key = nil if @ssh_public_key == UNSET_VALUE
        @label = nil if @label == UNSET_VALUE
      end

      def validate(machine)
p [machine, machine.id]
p [@gp_service_code, @gc_service_code]
        errors = _detected_errors

        unless @access_key
          errors << I18n.t("vagrant_iijgp.config.access_key_is_required")
        end

        unless @secret_key
          errors << I18n.t("vagrant_iijgp.config.secret_key_is_required")
        end

        unless @ssh_public_key
          errors << I18n.t("vagrant_iijgp.config.ssh_public_key_is_required")
        end

        if @gp_service_code.nil? or @gp_service_code == UNSET_VALUE
          errors << I18n.t("vagrant_iijgp.config.gp_service_code_is_required")
        end

        { "IIJ GP Provider" => errors }
      end
    end
  end
end
