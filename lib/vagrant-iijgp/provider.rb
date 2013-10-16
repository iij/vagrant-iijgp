module VagrantPlugins
  module ProviderIijGp
    class Provider < Vagrant.plugin('2', :provider)
      def initialize(machine)
        @logger = Log4r::Logger.new("")
        @machine = machine
      end
      attr_reader :machine

      # @param [Symbol] name Name of the action.
      # @return [Object] A callable action sequence object.
      #   +nil+ means that we don't support the given action.
      def action(name)
        method = "action_#{name}"
        if Action.respond_to? method
          Action.send(method)
        else
          # the specified action is not supported
          nil
        end
      end

      # @return [Hash] SSH information. For the structure of this hash
      #   read the accompanying documentation for this method.
      def ssh_info
        env = @machine.action('read_ssh_info')
        env[:machine_ssh_info]
      end

      # @return [MachineState]
      def state
        env = @machine.action('read_state')

        state = env[:machine_state]

        # Translate into short/long descriptions
        short = I18n.t("vagrant_iijgp.state.#{state}.short")
        long = I18n.t("vagrant_iijgp.state.#{state}.long")

        # Return the MachineState object
        Vagrant::MachineState.new(state, short, long)
      end
    end
  end
end
