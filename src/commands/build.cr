module Hokusai::OS::Commands
  @[ACONA::AsCommand("build", description: "Builds the Hokusai OS project")]
  class Build < ACON::Command
    include Barista::Behaviors::Software::OS::Information

    @@default_name = "build"

    protected def execute(input : ACON::Input::Interface, output : ACON::Output::Interface) : ACON::Command::Status
      workers = input.option("workers", Int32?) || memory.cpus.try(&.-(1)) || 1

      begin
        Hokusai::OS::Builder.new.build(workers: workers)
      rescue ex
        output.puts("<error>Build failed: #{ex.message}</error>")
      end

      ACON::Command::Status::SUCCESS
    end

    def configure : Nil
      self
        .option("workers", "w", :optional, "The number of concurrent build workers (default #{memory.cpus.try(&.-(1)) || 1})")
    end
  end
end
