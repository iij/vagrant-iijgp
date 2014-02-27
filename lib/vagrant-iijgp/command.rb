module VagrantPlugins
  module ProviderIijGp
    class GcListCommand < Vagrant.plugin(2, :command)
      def execute
        with_target_vms(nil, :provider => "iijgp") do |vm|
          vm.action(:gc_list)
        end
      end
    end
  end
end
