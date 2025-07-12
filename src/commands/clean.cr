module Hokusai::OS::Commands
  @[ACONA::AsCommand("clean", description: "Cleans the Hokusai OS project build")]
  class Clean < ACON::Command
    @@default_name = "clean"

    protected def execute(input : ACON::Input::Interface, output : ACON::Output::Interface) : ACON::Command::Status
      begin
        Hokusai::OS::Builder.new.clean
      rescue ex
        output.puts("<error>Build failed: #{ex.message}</error>")
      end

      ACON::Command::Status::SUCCESS
    end
  end
end
