require "barista"
require "./config"
require "./util/*"
require "./commands/*"

module Hokusai::OS
  VERSION = "0.1.0"

  class Builder < Barista::Project
    include_behavior Omnibus
    include Util::PlatformHelper

    def initialize
      install_dir("/opt/hokusai-#{VERSION}")
      barista_dir("/opt/hokusai-barista")
      replace("hokusai")
      conflict("hokusai")
      package_user("root")
      package_group("root")
      maintainer("Zero Stars <zero@skinnyjames.net>")
      homepage("https://hokusai.skinnyjames.net/os")

       
      if ENV["USE_CACHE"]? == "true" || !ENV["CI"]?
        cache(true)

        prefix = [
          "hokusai-os",
          platform_os,
          kernel.machine.gsub(/\s/, "_")
        ].join("-")

        cache_tag_prefix(prefix)
      end
    end

    def build(workers : Int32, filter : Array(String)? = nil)
      colors = Barista::ColorIterator.new

      Log.setup_from_env

      tasks.each do |task_klass|
        logger = Barista::RichLogger.new(colors.next, task_klass.name)

        task = task_klass.new(self, callbacks: callbacks)

        task.on_output do |str|
          logger.info { str }
        end

        task.on_error do |str|
          logger.error { str }
        end
      end

      orchestration = orchestrator(workers: workers, filter: filter)
         
      orchestration.on_task_start do |task|
        Barista::Log.info(task) { "starting build" }
      end

      orchestration.on_task_failed do |task, ex|
        Barista::Log.error(task) { "build failed: #{ex}" }
      end

      orchestration.on_task_succeed do |task|
        Barista::Log.info(task) { "build succeeded" }
      end
      
      orchestration.on_unblocked do |info|
        str = <<-EOH
        Unblocked #{info.unblocked.join(", ")}
        Building #{info.building.join(", ")}
        Active Sequences #{info.active_sequences.map {|k,v| "{ #{k}, #{v} }"}.join(", ")}
        EOH
        Barista::Log.debug(name) { str }
      end

      orchestration.execute
    end

    private def callbacks : Barista::Behaviors::Omnibus::CacheCallbacks
      callbacks = Barista::Behaviors::Omnibus::CacheCallbacks.new
      callbacks.fetch do |cacher|
        dir = Dir.tempdir
        cache_path = File.join("/cache", "hokusai-os", cacher.filename)
        begin
          if File.exists?(cache_path)
            FileUtils.cp_r(cache_path, dir)
            cacher.unpack(File.join(dir, cacher.filename))
          else
            false
          end
        rescue ex
          false
        end
      end

      callbacks.update do |task, path|
        FileUtils.mkdir_p("/cache/hokusai-os") unless Dir.exists?("/cache/hokusai-os")
        FileUtils.cp(path, File.join("/cache", "hokusai-os", "#{task.tag}.tar.gz"))
        true
      end

      callbacks
    end
  end
end

require "./tasks/*"

console = ACON::Application.new("hokusai-os")
console.add(Hokusai::OS::Commands::Build.new)
console.add(Hokusai::OS::Commands::Clean.new)

console.run