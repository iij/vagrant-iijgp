require "vagrant"

module VagrantPlugins
  module ProviderIijGp
    module Errors
      class VagrantIijGpError < Vagrant::Errors::VagrantError
        error_namespace("vagrant_iijgp.errors")
      end

      class RsyncError < VagrantIijGpError
        error_key(:rsync_error)
      end
    end
  end
end
