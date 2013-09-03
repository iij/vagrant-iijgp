module VagrantPlugins
  module ProviderIijGp
    class Config < Vagrant.plugin("2", :config)
      attr_accessor :access_key
      attr_accessor :secret_key

      attr_accessor :gp_service_code
      attr_accessor :gc_service_code

      attr_accessor :virtual_machine_type
      attr_accessor :os

      def initialize
        @access_key = UNSET_VALUE
        @secret_key = UNSET_VALUE
        @gp_service_code = UNSET_VALUE
        @gc_service_code = UNSET_VALUE
        @virtual_machine_type = UNSET_VALUE
        @os = UNSET_VALUE
      end

      def finalize!
        @access_key = ENV['IIJAPI_ACCESS_KEY'] if @access_key == UNSET_VALUE
        @secret_key = ENV['IIJAPI_SECRET_KEY'] if @secret_key == UNSET_VALUE

        @virtual_machine_type = 'V10' if @virtual_machine_type == UNSET_VALUE
        @os = 'CentOS6_64_U' if @os == UNSET_VALUE
      end
    end
  end
end
